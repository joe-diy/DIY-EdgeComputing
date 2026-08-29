# Chapter Eight - Detecting Problems

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

**Like chapter seven, this needs a Raspberry Pi 4 or 5 with 8 GB RAM: the chat stack from CH07, this monitor, and the model it calls all share the node. Analysis is slow — a single error takes minutes to work through on a Pi, not seconds. Plan for the wait.**

Chapter seven put a language model on the Pi and proved it answers with the network unplugged. This chapter watches that model for the moment it stops answering — and turns the failure into something you can read instead of something you guess at.

## You need more than vibes

A user messages you: "the AI's down." You open a terminal. There is no dashboard, no log tail, no idea which of the two containers died or why. You have vibes.

Open Horizon already surfaces some of this. `hzn node list` shows the agent's health, `hzn agreement list` shows whether the workload still has an agreement, and `hzn eventlog list` records execution and agreement failures. That tells you *that* something broke. It does not tell you *what*, or *why*, or *how bad*.

`joewxboy/service-edge-ai` sits on top of that. It is a log-watching workload monitor: it polls the local agent API every 60 seconds for running workloads, tails the logs of the ones that opt in, matches error patterns case-insensitively, and when it catches one it sends the error plus surrounding context to a **local** LLM — the same Ollama runtime chapter seven started — and writes a structured proposal to disk: a one-line summary, a likely root cause, a severity, a confidence score, and suggested remediation steps.

*Why?*

The failure stops being a 3 a.m. page with no context and becomes an artifact you can open: *what* broke, *probably why*, *how bad it is*, and *what to try first*. The monitor never touches the broken workload — every proposal it writes is advisory and carries `requires_human_review: true` — but it does the first pass of triage for you, offline, on hardware you own.

## Deploy the monitor

The monitor ships as its own Open Horizon service with a Makefile that publishes it and registers the node. Clone it, point it at chapter seven's Ollama, and publish:

```bash
git clone https://github.com/joewxboy/service-edge-ai
cd service-edge-ai
export HZN_ORG_ID=<your-org>
sudo mkdir -p /var/log/workloads
# point it at the Ollama runtime CH07 already started:
export MONITOR_LLM_HOST=http://<pi-ip>:11434
export MONITOR_LLM_MODEL=llama3.2:3b
# a 3B model on a Pi needs minutes per analysis; the 30 s default cancels every one:
export MONITOR_LLM_TIMEOUT=600
make deploy-check
make publish
curl -sS http://<pi-ip>:8080/health | jq
```

`make deploy-check` dry-runs policy compatibility before anything is registered; `make publish` then publishes the service plus its policies and runs `hzn register` for the node. `MONITOR_LLM_HOST` is the setting that matters here — it defaults to `http://localhost:11434`, and on a single Pi that is the same Ollama chapter seven published on port `11434`, so one model runtime now serves both the chat UI and the monitor's analysis calls. `MONITOR_LLM_MODEL` defaults to `llama3.2:3b-instruct-q4_K_M`; with `MONITOR_LLM_AUTO_PULL=true` (the default) the monitor pulls that model on first run if CH07 has not already cached it. Proposals are written under `MONITOR_PROPOSAL_DIR`, which defaults to `/var/lib/monitor/proposals`.

The health endpoint on port `8080` reports the monitor's own state — `workloads_discovered` (everything the agent is running), `workloads_monitored` (the subset that has opted in), and `proposals_written`. Straight after publish, `workloads_monitored` is `0`: nothing has opted in yet.

*Why?*

Running `deploy-check` before `publish` means a policy mismatch surfaces as a readable dry-run failure, not as a node that registers and then silently never gets an agreement. And pointing `MONITOR_LLM_HOST` at the runtime CH07 already started, instead of standing up a second one, keeps the memory budget sane: one 3B model resident in RAM, answering both chat prompts and analysis prompts. `MONITOR_LLM_TIMEOUT` matters just as much — it defaults to 30 seconds, and a 3B model working through an error on a Pi takes minutes. Leave the default and every analysis is cancelled before it finishes, so no proposal is ever written and chapter nine has nothing to act on; `600` gives it the ten minutes it needs.

## Opt the AI service in

Monitoring is opt-in. A workload the monitor discovers but that has not opted in is listed in `workloads_discovered` and never read. To opt chapter seven's `edge-ai-chat` service in, open its `service.definition.json` and edit the `open-webui` block inside the `deployment.services` section — the same block from chapter seven that already carries `OLLAMA_BASE_URL`:

```json
"open-webui": {
  "image": "ghcr.io/open-webui/open-webui:main",
  "privileged": true,
  "environment": [
    "OLLAMA_BASE_URL=http://ollama:11434",
    "MONITORING_ENABLED=true",
    "MONITORING_LOG_PATHS=/var/log/workloads/edge-ai-chat/app.log",
    "MONITORING_ERROR_PATTERNS=ERROR,FATAL,Traceback"
  ],
  "ports": [ { "HostPort": "3000", "HostIP": "0.0.0.0" } ],
  "binds": [ "/var/log/workloads:/var/log/workloads:rw" ]
}
```

*Why?* the variables must live inside `deployment`: the Open Horizon exchange discards unknown top-level service-definition fields, so a custom `monitoring` block would never reach the node.

*Why?* the `ports` entry is carried over unchanged from chapter seven: this block is an *edit* to CH07's `open-webui` service, not a replacement, and dropping `3000` takes the chat UI offline — which is exactly what chapter nine's demo checks recovered.

*Why?* the shared bind plus `privileged`: `MONITORING_LOG_PATHS` is resolved inside the monitor's container, so both containers have to see the same file, and a writable bind onto the root-owned `/var/log/workloads` needs `privileged: true`. That applies to **both** sides of the mount: `make publish` already sets `privileged: true` on the `service-edge-ai` monitor container (confirm it in the published definition, or add it), and it stays on `open-webui` here because the workload writes `app.log` into that same root-owned tree.

Republish the edited definition:

```bash
hzn exchange service publish -f service.definition.json
```

The agent re-forms the agreement with the new definition, the workload writes to the shared log path, and on the next discovery poll the monitor picks it up — `workloads_monitored` on the health endpoint goes from `0` to `1`.

## Break it on purpose

```bash
# on the Pi:
docker kill $(docker ps --filter name=open-webui -q)   # or: podman kill $(podman ps --filter name=open-webui -q)
hzn eventlog list | tail -n 20                          # agreement/exec errors show here
watch -n 5 'ls -t /var/lib/monitor/proposals/edge-ai-chat/'
cat /var/lib/monitor/proposals/edge-ai-chat/*.json | jq '{error_summary, root_cause, severity, confidence, requires_human_review}'
```

Expect a proposal file within a poll cycle or two: the monitor polls every 60 s, and the analysis itself is minutes on a Pi, not seconds. When it lands, the `jq` filter above pulls out some of the fields chapter nine's executor will gate on.

The full file looks like this — one per distinct problem, at `/var/lib/monitor/proposals/edge-ai-chat/<problem-key>.json`, rewritten in place each time the same error recurs:

```json
{
  "error_summary": "The open-webui container for edge-ai-chat exited and is no longer serving the chat UI.",
  "root_cause": "The open-webui container exited after receiving SIGKILL; it was terminated externally rather than crashing on an internal error.",
  "severity": "critical",
  "remediation_steps": [
    "Step 1: Confirm the container is down with 'docker ps' (or 'podman ps') on the node.",
    "Step 2: Check 'hzn eventlog list' for the agreement or execution error recorded alongside the exit.",
    "Step 3: Let the agent re-create the container from the existing agreement, or re-run the deployment if the agreement was cancelled.",
    "Step 4: Verify recovery by re-checking /var/log/workloads/edge-ai-chat/app.log and reloading http://<pi-ip>:3000."
  ],
  "confidence": 0.94,
  "requires_human_review": true,
  "disclaimer": "This remediation proposal is generated by an AI system. Validate all steps before execution in production environments.",
  "metadata": {
    "timestamp": "2026-08-29T03:14:22.017430+00:00",
    "workload_id": "<org>/edge-ai-chat_1.0.0_arm64",
    "service_name": "edge-ai-chat",
    "log_path": "/var/log/workloads/edge-ai-chat/app.log",
    "line_number": 128,
    "occurrences": 1,
    "analysis_duration_ms": 141773
  }
}
```

As the same error recurs the file is updated in place — `occurrences` climbs and `metadata.timestamp` moves — rather than a new file per hit. Chapter nine's executor reads exactly five of these fields — `severity`, `confidence`, `requires_human_review`, `root_cause`, and `metadata.service_name` — to decide whether to act and on what. This proposal's `confidence` of `0.94` sits above the `>= 0.9` bar chapter nine's auto-remediation will gate on, so it is the kind that gets acted on unattended; a lower-confidence call — say `0.7` — would be written in exactly the same shape but held for a human instead.

<!-- screenshot: hzn eventlog red + the proposal JSON side by side -->

*Why?*

The container dying used to be silence — you found out when a user complained. Now it is a described event on disk, with a root-cause guess and a severity, written while you were asleep.

## Next

On to [chapter nine](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH09%20-%20Autonomous%20Remediation#chapter-nine---autonomous-remediation) — now that it can see the break and describe it, can it fix it?
