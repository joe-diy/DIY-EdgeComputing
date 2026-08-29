# Verification: `service-edge-ai`

**Verified 2026-08-29 against `github.com/joewxboy/service-edge-ai`**
(repo description: "Open Horizon service definition for a local Edge AI service
that will watch workloads for errors and help remediate what it finds").

This resolves the "service-edge-ai specifics unconfirmed" open question carried
in both `2026-08-27-book-outline-design.md` and
`2026-08-29-video-series-plan-design.md`. The findings below are the source of
truth for CH06–CH09 and V7–V10.

## Two contradictions with the original specs

Both specs were written without repo access and got two things wrong:

1. **There is no API key.** Both specs assumed CH06 binds "an API key the AI
   chapter needs" and that V7/V8 rotate that token. In reality `service-edge-ai`
   authenticates to nothing: it talks only to a **local Ollama** runtime
   (`http://localhost:11434`) and the **local anax API**
   (`http://localhost:8510`), neither of which requires a credential. The AI
   stack needs no secret of its own.
2. **It never acts.** Both specs assumed CH07 deploys a chat/inference LLM the
   reader talks to, and that CH09 has the AI "fix errors without a human in the
   loop." In reality `service-edge-ai` is a **workload monitor**: it detects
   errors in other workloads' logs and writes **advisory** remediation-proposal
   JSON. Every proposal carries `requires_human_review: true`, and the README
   states plainly: "The service never executes remediation itself."

## What it actually is

| Spec assumption | Reality |
|---|---|
| A chat/inference service the reader queries | A **log-watching workload monitor**. It discovers workloads via the anax API, tails the logs of workloads that opt in, and turns detected errors into structured JSON proposals. |
| Needs a secret / API key (bound in CH06) | **No secret.** Local Ollama + local anax only; neither is authenticated. |
| The AI fixes problems autonomously (CH09) | **Advisory only.** Writes one proposal file per distinct problem; `requires_human_review: true` on every one; never executes anything. |
| "Which model/runtime?" unknown | **Ollama**, model `llama3.2:3b-instruct-q4_K_M` by default, with `MONITOR_LLM_AUTO_PULL=true` so the model is pulled on first run if missing. |
| "Does it fit a Pi?" unknown | **4 GB RAM floor** (README: "at least 4 GB of RAM — local inference with a 3B quantized model needs roughly 2 GB beyond the runtime"). A **4 GB container memory limit** is enforced. **arm64 is supported** (x86_64 or arm64 Linux). Analysis is slow: the shipped fixture records `analysis_duration_ms: 136014` — ~136 seconds for a single analysis. Expect minutes per error on a Pi. |

### How it works (from the README)

1. **Discovery** — polls the anax API every 60 s for registered and running workloads.
2. **Permission check** — only workloads whose service definition sets
   `MONITORING_ENABLED=true` are eligible; everything else is discovered but never read.
3. **Log monitoring** — tails the declared log paths, matches error patterns
   case-insensitively, collects 50 lines of context either side.
4. **Analysis** — sends the error, workload metadata, and any operator-supplied
   documentation (SKILL.md files, runbooks) to a local Ollama model, which
   returns a structured JSON verdict with a severity and confidence score.
5. **Proposal** — writes an actionable proposal to
   `/var/lib/monitor/proposals/<workload>/<problem-key>.json` — one file per
   distinct problem, updated in place as it recurs.

> Proposals are **advisory**. The service never executes remediation itself.

### Prerequisites (from the README)

- **Management Hub:** install the Open Horizon Management Hub, use an existing
  hub, or apply for a temporary account on the LF Edge community hub.
- **Edge node:** an x86_64 or arm64 Linux machine with the Open Horizon agent
  (anax) installed and registered, and **at least 4 GB of RAM**.
- **Optional utilities:** `make`, `git`, `jq`, `curl`, `docker`.

Confirm the agent is present:

```bash
hzn version
hzn node list | jq '.configstate.state'
```

## Configuration — the `MONITOR_*` variables

Settings come from `config/config.yaml`, overridden by environment variables
(which is how Open Horizon `userInput` supplies them). Verbatim from the repo
README:

| Variable | Default | Meaning |
|---|---|---|
| `MONITOR_ANAX_URL` | `http://localhost:8510` | Open Horizon agent API |
| `MONITOR_POLL_INTERVAL` | `60` | Seconds between discovery polls |
| `MONITOR_LOG_POLL_INTERVAL` | `1` | Seconds between log reads |
| `MONITOR_MAX_BUFFER_MB` | `100` | In-memory log buffer ceiling |
| `MONITOR_LLM_MODEL` | `llama3.2:3b-instruct-q4_K_M` | Ollama model |
| `MONITOR_LLM_HOST` | `http://localhost:11434` | Ollama runtime |
| `MONITOR_LLM_TIMEOUT` | `30` | Seconds before an analysis is cancelled |
| `MONITOR_LLM_AUTO_PULL` | `true` | Pull the model if missing |
| `MONITOR_MAX_QUEUE_SIZE` | `50` | Pending analyses before shedding |
| `MONITOR_CACHE_TTL` | `900` | Seconds an analysis is reused |
| `MONITOR_CONTEXT_DIR` | `/etc/edge-ai-monitor/context` | Node-wide knowledge injected into prompts |
| `MONITOR_CONTEXT_ENABLED` | `true` | Master switch for knowledge injection |
| `MONITOR_CONTEXT_MAX_BYTES` | `8000` | Guidance budget per prompt |
| `MONITOR_EXPORT_ENABLED` | `true` | Master switch for northbound export (inert without sinks) |
| `MONITOR_EXPORT_SPOOL_DIR` | `/var/lib/monitor/spool` | Store-and-forward queue |
| `MONITOR_EXPORT_NODE_ID` | *(from the agent)* | Node identity attached to exports |
| `MONITOR_PROPOSAL_DIR` | `/var/lib/monitor/proposals` | Proposal output |
| `MONITOR_LOG_LEVEL` | `INFO` | Logging verbosity |
| `MONITOR_HEALTH_PORT` | `8080` | Health endpoint port |

Validate config without starting the service: `edge-ai-monitor --check`.

## Opting a workload in

Monitoring is opt-in. Add `MONITORING_*` environment variables to the
**`deployment`** section of the workload's service definition:

```json
{
  "deployment": {
    "services": {
      "sensor": {
        "image": "examples/sensor:1.2.0",
        "environment": [
          "MONITORING_ENABLED=true",
          "MONITORING_LOG_PATHS=/var/log/workloads/sensor/app.log",
          "MONITORING_ERROR_PATTERNS=ERROR,FATAL,SensorFault"
        ]
      }
    }
  }
}
```

- They must live **inside `deployment`** — the Open Horizon exchange discards
  unknown top-level service definition fields, so a custom `monitoring` section
  would never reach the node.
- `MONITORING_LOG_PATHS` is resolved **inside the monitor container**, so the
  workload and the monitor must **share a volume** — a shared `/var/log/workloads`
  mount is the convention.
- A writable bind to the root-owned `/var/log/workloads` additionally needs
  **`privileged: true`** on the monitor.
- Omitting the variables, or setting `MONITORING_ENABLED=false`, means the
  workload is discovered but never read.

## Deploy flow

Locally, without a hub:

```bash
docker compose up --build
curl -sS http://127.0.0.1:8080/health | jq
```

On an Open Horizon node:

```bash
export HZN_ORG_ID=<your-org>
sudo mkdir -p /var/log/workloads     # shared log mount
make publish                          # publish service + policies, then hzn register the node
make deploy-check                     # check policy compatibility before registering
curl -sS http://127.0.0.1:8080/health | jq
```

Other Makefile targets: `build`, `buildx`, `push-multiarch`, `unittest`,
`run`/`stop`/`attach`, `test`, `log`, `check`, `clean`/`distclean`.

### Health endpoint

`curl -sS http://127.0.0.1:8080/health | jq` returns 200 while running, 503
while shutting down:

```json
{
  "healthy": true,
  "startup_errors": [],
  "workloads_discovered": 3,
  "workloads_monitored": 1,
  "log_paths_watched": 2,
  "analysis_queue_depth": 0,
  "analyses_completed": 4,
  "analyses_failed": 0,
  "analyses_dropped": 0,
  "proposals_written": 4,
  "proposals_updated": 37,
  "proposal_storage_failures": 0
}
```

## Proposal file shape

One file per distinct problem at
`/var/lib/monitor/proposals/<workload>/<problem-key>.json`, updated in place as
the problem recurs. Verbatim example from the README:

```json
{
  "error_summary": "The sensor service is unable to connect to the database.",
  "root_cause": "The database server at db.internal:5432 is not reachable or is down.",
  "severity": "critical",
  "remediation_steps": [
    "Step 1: Verify that the database server is running and accessible from the sensor's network.",
    "Step 2: Check the network configuration for firewall rules blocking port 5432 on db.internal.",
    "Step 3: Review the database server logs for errors explaining why it cannot accept connections.",
    "Step 4: Verify examples/sensor v1.2.0 recovered by re-checking /var/log/workloads/sensor/app.log."
  ],
  "confidence": 0.95,
  "requires_human_review": true,
  "disclaimer": "This remediation proposal is generated by an AI system. Validate all steps before execution in production environments.",
  "metadata": {
    "timestamp": "2026-08-13T19:42:09.429591+00:00",
    "workload_id": "examples/example.com.sensor_1.2.0_amd64",
    "service_name": "sensor",
    "log_path": "/var/log/workloads/sensor/app.log",
    "line_number": 6,
    "occurrences": 3,
    "analysis_duration_ms": 136014
  }
}
```

Fields to build against: `error_summary`, `root_cause`, `severity`,
`remediation_steps[]`, `confidence` (0–1 float), `requires_human_review`
(always `true`), `disclaimer`, and `metadata` (`timestamp`, `workload_id`,
`service_name`, `log_path`, `line_number`, `occurrences`,
`analysis_duration_ms`).

## Decisions

Four decisions are now locked. Every later task (CH06–CH09 drafts, V7–V10 beat
sheets) builds on these exactly as stated.

1. **CH07 deploys a real chat LLM, not `service-edge-ai`.** CH07 is an Open
   Horizon service running **Ollama** (`ollama/ollama`) + **Open WebUI**
   (`ghcr.io/open-webui/open-webui`), default model `llama3.2:3b` (fall back to
   `llama3.2:1b` if 8 GB is tight). *Rationale: `service-edge-ai` is a monitor,
   not something you talk to; V8's "ask it a question with the Wi-Fi off" demo
   needs a genuine interactive inference service, and CH08's monitor reuses this
   same Ollama runtime.*
2. **CH06 binds a private container-registry pull credential**, not an AI API
   key. Same Open Horizon secrets-manager mechanism; the example is a registry
   pull secret because the AI stack itself needs no secret. V7's rotation demo
   rotates that credential. *Rationale: the original "API key the AI chapter
   needs" does not exist; a private-registry pull credential is a real,
   always-applicable secret that the secrets-manager workflow demonstrates just
   as well.*
3. **CH08 deploys `service-edge-ai` as the monitor.** It is a log-watching
   workload monitor that writes advisory proposal JSON to
   `/var/lib/monitor/proposals/<workload>/<key>.json` and reuses CH07's Ollama
   at `MONITOR_LLM_HOST`. Opt-in is `MONITORING_ENABLED=true` +
   `MONITORING_LOG_PATHS` + `MONITORING_ERROR_PATTERNS` inside the workload's
   **`deployment`** section, plus a shared `/var/log/workloads` volume and
   `privileged: true` on the monitor. *Rationale: this is precisely what the
   repo does — detect failure states in a deployed workload and surface them —
   which is CH08's "recognize failure states" goal.*
4. **CH09 builds the executor — it is net-new reader content.**
   `service-edge-ai` is advisory-only by design (`requires_human_review: true`
   on every proposal; "The service never executes remediation itself"), so
   CH09's autonomous layer — read proposal → gate on severity/confidence → act
   (restart / roll back / re-request agreement) — is written by the reader on
   top of the monitor. *Rationale: the repo deliberately stops at the proposal;
   closing the loop is the capstone's original intent and remains valuable, but
   it is the book's contribution, not the repo's.*

### Hardware reality to carry into CH07–CH09

- **RAM:** the repo's stated floor is **4 GB**, but CH07–CH09 stack a chat LLM,
  the monitor, and one or more workloads on the same node, so the book requires
  a **Pi 4 or Pi 5 with 8 GB RAM**. The 4 GB Pi is out of scope for these
  chapters.
- **Architecture:** arm64 is supported.
- **Latency:** analysis takes minutes, not seconds (~136 s per error in the
  shipped fixture). CH07–CH09 must set this expectation; V8–V10 must plan
  B-roll / editing around it rather than faking real-time.
