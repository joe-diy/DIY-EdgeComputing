# Open Horizon + Local AI: Book & Video Series Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extend the *DIY Edge Computing* book from 2 chapters to 10 (revise CH01, add CH02–CH09) teaching Open Horizon fleet management and a local-AI capstone, and produce the written production package for the 11-episode companion YouTube Shorts series — chapter section and its video built together, one topic at a time.

**Architecture:** This is a Jekyll (`jekyll-theme-tactile`) GitHub Pages content repo — no application, no test suite. "Implementation" means Markdown chapter READMEs that follow the book's established voice, plus per-episode video artifact files under `docs/video/`. Each chapter builds on the accumulated state of the prior chapters and ends with a `## Next` link, keeping the book linear. The AI arc uses a real edge chat LLM (Ollama + Open WebUI) for CH07 and `joewxboy/service-edge-ai` for the CH08–CH09 detection/remediation capstone.

**Tech Stack:** Jekyll + GitHub Pages + Markdown; Ruby/Bundler (`github-pages` gem bundle); Open Horizon (anax agent, `hzn` CLI, exchange/agbot/CSS management hub); Docker & Podman; Ollama + Open WebUI; `joewxboy/service-edge-ai` (Python + Ollama workload monitor).

**Spec:** `docs/superpowers/specs/2026-08-27-book-outline-design.md` (book outline) and `docs/superpowers/specs/2026-08-29-video-series-plan-design.md` (video series). Both are Approved. This plan implements both together. The `service-edge-ai` open question in both specs has been resolved — see Task 1 and `docs/video/00-verification-service-edge-ai.md`.

## Global Constraints

Every task's requirements implicitly include this section.

- **Voice & structure (from `CLAUDE.md`):** chapter READMEs are a numbered walkthrough of commands/steps; after each major step an italicized `*Why?*` paragraph explains the reasoning; the file ends with a `## Next` section linking to the following chapter. Keep this exactly.
- **Code fences:** commands the reader runs are fenced ` ```bash `. Console output samples are fenced plain (no language). Keep this convention.
- **Image paths:** relative into that chapter's own `images/` folder (e.g. `images/agent-install.png`), never absolute. For screenshots that do not exist yet, do **not** emit a broken `<img>` tag — leave an HTML comment `<!-- screenshot: <what to capture> -->` so `jekyll build` never 404s and the hardware-verification pass knows what to shoot.
- **Chapter directory naming:** new chapters use `CH<NN> - <Title>` exactly (e.g. `CH02 - Open Horizon Fundamentals`). The existing `CH01 - Docker` directory keeps its path (only its H1/content change) so the one inbound link from the Introduction stays valid.
- **`## Next` wiring convention:** the task that creates chapter *N* is also responsible for adding/updating the `## Next` link in chapter *N-1* that points to it. Links are GitHub tree URLs with URL-encoded spaces, matching the existing style in `Introduction - Getting Ready/README.md` (e.g. `https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH02%20-%20Open%20Horizon%20Fundamentals`).
- **Unverified content marker:** every new or substantially revised chapter opens (right under the H1) with:
  `> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See \`docs/video/HARDWARE-VERIFICATION.md\`.`
- **Hub-neutrality (book outline principle):** the main path assumes an already-running management hub (LF Edge Community Lab's free hub or a company hub). Give generic "get your org, exchange URL, CSS URL and credentials from your hub provider" instructions — never hosting-specific steps — except in CH03, which is the optional self-hosting branch.
- **Container-engine neutrality (book outline principle):** from CH02 onward the text says "your container engine" and never assumes Docker specifically. Any literal `docker` command in CH02+ must either be shown with its `podman` equivalent or be genuinely Docker-specific and flagged as such.
- **Build check:** where Ruby/Bundler is available, `bundle exec jekyll build` must exit 0 after every task. If Bundler is unavailable in the execution environment, the minimum bar is: Markdown parses, every relative link and image path resolves to a file that exists, and the `## Next` chain is unbroken — note in the commit body that the jekyll build was not run.
- **Commits:** one or more commits per task, present-tense conventional-commit subject lines (`docs:`, `feat:`). Never `git push` unless the user asks.
- **Video artifacts are written packages, not media.** Tasks produce beat sheets, shot lists, asset checklists and caption/end-card copy. Recording, editing and publishing are human steps captured as unchecked checklist items in each episode file and in `docs/video/index.md`.

---

## File Structure

**Book chapters** (each a directory with `README.md` + `images/`):

| Path | Responsibility |
|---|---|
| `Introduction - Getting Ready/README.md` | *Exists.* Minor edit: add Podman to the software-install section; soften Docker-only wording. |
| `CH01 - Docker/README.md` | *Exists.* Revise to teach Docker **and** Podman side-by-side; add a `## Next` to CH02. |
| `CH02 - Open Horizon Fundamentals/README.md` | New. Install the anax agent on the Pi; register it as a node against an existing hub. |
| `CH03 - Hosting Your Own Hub/README.md` | New, **optional branch**. Stand up exchange + agbot + CSS on a second host. |
| `CH04 - Deployment Policies/README.md` | New. Author and publish a deployment policy that targets nodes by property. |
| `CH05 - Node Policies/README.md` | New. Node-side properties/constraints so services land on the right hardware. |
| `CH06 - Secrets Management/README.md` | New. Store and bind a **private container-registry pull credential** via the Horizon secrets manager; rotate it without redeploy. |
| `CH07 - Deploying Local AI/README.md` | New. Deploy Ollama + Open WebUI as a Horizon service on a Pi 5 (8 GB); chat with a local model offline. |
| `CH08 - Detecting Problems/README.md` | New. Deploy `service-edge-ai` as a monitor; opt the CH07 workload in; break it; read the AI-generated proposal. |
| `CH09 - Autonomous Remediation/README.md` | New, **capstone**. Build the executor that consumes proposals and applies gated auto-fixes. |

**Video artifacts** (`docs/video/`):

| Path | Responsibility |
|---|---|
| `docs/video/00-verification-service-edge-ai.md` | The resolved `service-edge-ai` open question: findings + the four decisions that reshape CH06–CH09 / V7–V10. |
| `docs/video/00-template.md` | Reusable video template spec: cold-open sting, lower-thirds, end card, caption style, 2:30 budget table, recording-rig checklist, asset naming. |
| `docs/video/index.md` | 11-row production tracker (episode, pairs-with chapter, beat-sheet / recorded / edited / published status). |
| `docs/video/Ep0-trailer.md` | Trailer beat sheet (compressed structure; montage sourced from V8–V10; V1–V3 rough-cut fallback). |
| `docs/video/V01-intro-getting-ready.md` … `V10-ch09-remediation.md` | One file per episode: 7-beat sheet (refined from the video spec), shot list, on-screen asset checklist, caption + end-card copy. |
| `docs/video/HARDWARE-VERIFICATION.md` | Running checklist of every command and claim across CH01–CH09 that needs a real-hardware pass. |

**Not touched:** `_site/` (generated), `_config.yml`, `Gemfile*`. `index.html` gets an optional TOC in Task 13.

---

## Task 1: Resolve the `service-edge-ai` open question

**Files:**
- Create: `docs/video/00-verification-service-edge-ai.md`
- Modify: `docs/superpowers/specs/2026-08-27-book-outline-design.md` (append an addendum section)
- Modify: `docs/superpowers/specs/2026-08-29-video-series-plan-design.md` (append an addendum section)

**Interfaces:**
- Produces: the locked decisions every later task depends on —
  1. **CH07 uses a real chat LLM**, not `service-edge-ai`: an Open Horizon service running **Ollama** (`ollama/ollama`) + **Open WebUI** (`ghcr.io/open-webui/open-webui`), default model `llama3.2:3b` (fall back to `llama3.2:1b` if 8 GB is tight). V8's "ask it a question offline" demo stands.
  2. **CH06 binds a private container-registry pull credential** (not an AI API key — the AI stack needs none). V7's rotation demo rotates that credential.
  3. **CH08 deploys `service-edge-ai` as the monitor.** It is a log-watching workload monitor that writes advisory remediation-proposal JSON to `/var/lib/monitor/proposals/<workload>/<key>.json`; it reuses CH07's Ollama at `MONITOR_LLM_HOST`. Opt-in is `MONITORING_ENABLED=true` + `MONITORING_LOG_PATHS` + `MONITORING_ERROR_PATTERNS` inside the workload's **`deployment`** section, plus a shared `/var/log/workloads` volume and `privileged: true`.
  4. **CH09 builds the executor.** `service-edge-ai` is advisory-only by design (`requires_human_review: true` on every proposal); CH09's "autonomous" layer — read proposal → gate on severity/confidence → act — is net-new content the reader builds.
- Also produces: hardware reality to carry into CH07–CH09 — 4 GB RAM floor (Pi 4/5 **8 GB only**), arm64 supported, fixture analysis latency ~136 s per error (expect minutes on a Pi).

- [ ] **Step 1: Write the verification findings file**

Create `docs/video/00-verification-service-edge-ai.md` with:
- A "Verified 2026-08-29 against `github.com/joewxboy/service-edge-ai`" header.
- A "What it actually is" table (spec assumption → reality) covering: it is a workload **monitor** not a chat service; **no secret/API key** (local Ollama + local anax only); proposals are **advisory only**; model is Ollama `llama3.2:3b-instruct-q4_K_M` with `MONITOR_LLM_AUTO_PULL=true`; **4 GB RAM floor**, 4 GB container cap, arm64 OK, ~136 s/analysis in the shipped fixture.
- The full `MONITOR_*` config-variable table (from the repo README): `MONITOR_ANAX_URL` `http://localhost:8510`, `MONITOR_LLM_MODEL`, `MONITOR_LLM_HOST` `http://localhost:11434`, `MONITOR_LLM_TIMEOUT` 30, `MONITOR_LLM_AUTO_PULL` true, `MONITOR_CONTEXT_DIR` `/etc/edge-ai-monitor/context`, `MONITOR_PROPOSAL_DIR` `/var/lib/monitor/proposals`, `MONITOR_HEALTH_PORT` 8080, etc.
- The opt-in mechanism: `MONITORING_ENABLED`, `MONITORING_LOG_PATHS`, `MONITORING_ERROR_PATTERNS` in the `deployment` section; shared log volume; `privileged: true` for a writable bind to root-owned `/var/log/workloads`.
- The deploy flow: `make publish` (wraps service + policy publish + `hzn register`), `make deploy-check`, `curl http://127.0.0.1:8080/health | jq`.
- The example proposal JSON shape (`error_summary`, `root_cause`, `severity`, `remediation_steps`, `confidence`, `requires_human_review`, `metadata`).
- A "Decisions" section stating the four locked decisions from the Interfaces block above, each with one sentence of rationale.

- [ ] **Step 2: Append an addendum to the book outline spec**

At the end of `docs/superpowers/specs/2026-08-27-book-outline-design.md` add:

```markdown
---

## Addendum 2026-08-29: `service-edge-ai` verified — CH06/CH07 revised

The "service-edge-ai specifics unconfirmed" open question is resolved. Findings:
`docs/video/00-verification-service-edge-ai.md`. Net changes to the chapter list:

- **CH06 Secrets Management** now binds a **private container-registry pull
  credential** (the AI stack needs no secret of its own). Same Open Horizon
  secrets-manager mechanism; different, always-applicable example.
- **CH07 Deploying Local AI** deploys **Ollama + Open WebUI** as the edge chat
  service (real offline inference the reader can talk to). `service-edge-ai` is
  *not* CH07 — it is the CH08–CH09 capstone.
- **CH08 Detecting Problems** deploys `service-edge-ai` as a log-watching
  monitor that emits advisory JSON proposals, reusing CH07's Ollama runtime.
- **CH09 Autonomous Remediation** adds the executor (proposal → gated action)
  on top, because `service-edge-ai` is advisory-only by design.
- **Hardware:** the AI chapters require a Pi 4/5 with **8 GB RAM**; analysis is
  minutes, not seconds. Called out in CH07–CH09.
```

- [ ] **Step 3: Append the matching addendum to the video series spec**

At the end of `docs/superpowers/specs/2026-08-29-video-series-plan-design.md` add an "Addendum 2026-08-29" section stating: V7's rotation demo rotates the **registry credential**; V8 deploys **Ollama + Open WebUI** and the offline-question demo is unchanged; V9 reads a **`service-edge-ai` proposal file**; V10 shows the **reader-built executor** acting on that proposal; V8–V10 need an **8 GB Pi** and analysis latency is minutes (plan B-roll/edit around it, don't fake real-time).

- [ ] **Step 4: Build check**

Run: `bundle exec jekyll build`
Expected: exit 0. (Or, no Bundler: confirm the three Markdown files parse and all internal links resolve.)

- [ ] **Step 5: Commit**

```bash
git add "docs/video/00-verification-service-edge-ai.md" "docs/superpowers/specs/"
git commit -m "docs: resolve service-edge-ai open question; revise CH06/CH07 arc"
```

---

## Task 2: Video template and production tracker

**Files:**
- Create: `docs/video/00-template.md`
- Create: `docs/video/index.md`

**Interfaces:**
- Produces: `docs/video/00-template.md` — every later episode file references it for the cold-open sting, lower-third style, end-card wording ("full walkthrough → <chapter>"), caption style and the 2:30 beat budget. `docs/video/index.md` — the 11-row status table later tasks tick.

- [ ] **Step 1: Write the template spec**

Create `docs/video/00-template.md` containing:
- **Format:** vertical 1080×1920, YouTube Shorts, hard cap 3:00, target 2:30 (trailer ~0:50).
- **Beat budget table** (verbatim from the video spec Section 4): Relatable problem 0:00–0:20 · The fix 0:20–0:40 · Punchline 0:40–0:50 · Demo 0:50–2:00 · Hook 2:00–2:12 · CTA 2:12–2:22 · Book pointer 2:22–2:30.
- **Cold open:** no intro, no "hey guys" — open *inside* the pain. 0.5 s sting + on-screen problem statement.
- **Lower-thirds:** command being run, bottom third, monospace, high contrast; node/host name top-left when multiple machines are on screen.
- **End card (last 8 s):** "Full walkthrough → *DIY Edge Computing*, <Chapter>" + repo URL. Consistent across all episodes.
- **Captions:** burned-in, sentence case, ≤2 lines, Gen-Z-register but dry; no emoji spam.
- **Register:** solo creator, one joke per video, on the turn from problem to fix.
- **Recording rig checklist:** standing screen-capture source, talking-head cam, mic, lav; start/stop not re-rig each week; project template in the editor with the sting/lower-third/end-card presets.
- **Asset naming:** `V<NN>-<slug>-<take>.<ext>`, proposals/screens as `V<NN>-shot-<n>.png`.

- [ ] **Step 2: Write the production tracker**

Create `docs/video/index.md` with a table: `Ep | Pairs with | Dramatized moment | Beat sheet | Recorded | Edited | Published`. Seed all 11 rows (Ep0 + V1–V10) from the video spec Section 1 table, "Dramatized moment" column copied verbatim. Set every status cell to `☐`. Add a note: V4 is the bonus/off-critical-path episode; the trailer is produced last, published first.

- [ ] **Step 3: Build check**

Run: `bundle exec jekyll build` → exit 0 (or link-resolve check).

- [ ] **Step 4: Commit**

```bash
git add "docs/video/00-template.md" "docs/video/index.md"
git commit -m "docs: add video template spec and production tracker"
```

---

## Task 3: Revise CH01 for Docker + Podman neutrality (+ V2)

**Files:**
- Modify: `CH01 - Docker/README.md` (retitle H1, add Podman throughout, add `## Next`)
- Modify: `Introduction - Getting Ready/README.md` ("Installing Software" section only)
- Create: `docs/video/V02-ch01-docker-podman.md`

**Interfaces:**
- Consumes: nothing from earlier tasks.
- Produces: a CH01 that later chapters can refer to as "your container engine (Docker or Podman)". The `## Next` link target `CH02%20-%20Open%20Horizon%20Fundamentals` (directory created in Task 4).

- [ ] **Step 1: Retitle CH01 and add the unverified marker**

In `CH01 - Docker/README.md`: change the H1 from `# Chapter One - Images and Containers` to `# Chapter One - Containers with Docker and Podman`. Immediately under it add the Global-Constraints unverified blockquote.

- [ ] **Step 2: Make the command walkthrough engine-neutral**

Rework the "Basic Docker Commands" section (now "Basic container commands") so every command is shown for both engines. Pattern to apply to each existing command:

```bash
# Docker
docker run -it ubuntu /bin/bash
# Podman — identical flags, same OCI image, no rebuild
podman run -it ubuntu /bin/bash
```

Cover the same verbs already in the chapter: `run -it`, `run -itd`, `ps`, `ps -q`, `ps -a`, `attach`, `rm`, `rm $(… ps -aq)`, `images`, `images -q`, `rmi`, `rmi $(… images -q)`. Add one `*Why?*` paragraph: both engines implement the same CLI surface and run the same OCI images, so the book teaches "a container engine" and you pick either; Podman is daemonless and rootless-by-default, Docker has Docker Desktop and a larger ecosystem.

- [ ] **Step 3: Make the Dockerfile / build section neutral**

In "Create simple Dockerfile" and "Build Docker Image": note the file is a `Containerfile`/`Dockerfile` (both names work), and show `docker build ./` **and** `podman build ./`. Keep the VS Code / Docker Hub mentions but frame Docker Hub as "a registry" with a nod that Podman pushes to the same registries.

- [ ] **Step 4: Add CH01's `## Next`**

Append to `CH01 - Docker/README.md`:

```markdown
## Next

On to [chapter two](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH02%20-%20Open%20Horizon%20Fundamentals#chapter-two---open-horizon-fundamentals), where one command turns this Pi into a managed fleet node.
```

- [ ] **Step 5: Update the Introduction's software section**

In `Introduction - Getting Ready/README.md`, "Installing Software" section: change "In chapter one, you will be using Docker." to "In chapter one, you will be using a container engine — Docker or Podman.". After the `docker-ce` install block, add:

```bash
# Podman is in the Raspberry Pi OS / Debian repos:
sudo apt-get -y install podman
```

Add one sentence: either engine is fine for the rest of the book; install whichever you prefer (or both). Leave the existing `## Next` link to CH01 unchanged.

- [ ] **Step 6: Write the V2 beat sheet**

Create `docs/video/V02-ch01-docker-podman.md`: the 7 beats from the video spec V2 section, plus a **shot list** (terminal: `docker run hello-world`; same as `podman run hello-world`; `diff` the two outputs; `docker images` / `podman images` side by side), an **asset checklist** (split-screen terminal recording, byte-diff overlay), and **caption/end-card copy** ("Two engines, one muscle memory." / "Full walkthrough → CH01").

- [ ] **Step 7: Build check**

Run: `bundle exec jekyll build` → exit 0. Confirm the CH01 → CH02 link is well-formed (target created next task) and the Introduction → CH01 link still resolves.

- [ ] **Step 8: Commit**

```bash
git add "CH01 - Docker/README.md" "Introduction - Getting Ready/README.md" "docs/video/V02-ch01-docker-podman.md"
git commit -m "docs: revise CH01 for Docker+Podman neutrality; add V2 beat sheet"
```

---

## Task 4: CH02 — Open Horizon Fundamentals (+ V3)

**Files:**
- Create: `CH02 - Open Horizon Fundamentals/README.md`
- Create: `CH02 - Open Horizon Fundamentals/images/.gitkeep`
- Modify: `CH01 - Docker/README.md` (confirm `## Next` from Task 3 points here — no change if already correct)
- Create: `docs/video/V03-ch02-fundamentals.md`

**Interfaces:**
- Consumes: "your container engine" from CH01.
- Produces: a registered edge node concept that CH04/CH05 target with policies; the environment variables `HZN_ORG_ID`, `HZN_EXCHANGE_URL`, `HZN_FSS_CSSURL`, `HZN_EXCHANGE_USER_AUTH` and the file `node.policy.json` that later chapters reuse; the node property `purpose` (set here, constrained in CH04).

- [ ] **Step 1: Scaffold**

Create the directory, `images/.gitkeep`, and `README.md` starting with `# Chapter Two - Open Horizon Fundamentals` + the unverified blockquote.

- [ ] **Step 2: Write "What Open Horizon is" + "What you need"**

Prose section: Open Horizon is a management hub (exchange + agbot + CSS) plus a lightweight agent (anax) on each edge node; you describe *what should run where* with policies and the agent makes it so — no SSH per node. `*Why?*` paragraph: SSH-per-node does not scale to dozens of sites.

"What you need" — generic hub-neutral instructions:
```bash
# From your hub provider (LF Edge Community Lab free hub, or your company hub):
export HZN_ORG_ID=<your-org>
export HZN_EXCHANGE_URL=<https://.../v1>
export HZN_FSS_CSSURL=<https://.../>
export HZN_EXCHANGE_USER_AUTH=<user>:<apikey-or-password>
```
`*Why?*`: the book does not host a hub for you; the free community lab hub is fine for learning, a company hub for production.

- [ ] **Step 3: Write "Install the agent"**

```bash
# On the Raspberry Pi:
curl -sSL https://raw.githubusercontent.com/open-horizon/anax/master/agent-install/agent-install.sh -o agent-install.sh
chmod +x agent-install.sh
sudo -E ./agent-install.sh -O "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH" -i 'anax:'
```
Explain the flags: `-E` preserves the `HZN_*` env vars into the root process (without it the script fails asking for `HZN_FSS_CSSURL`); `-i 'anax:'` fetches the latest packages from the official repository; `-O` / `-u` are org and credentials. Note the expected final line: *"Horizon node is registered. Workload agreement negotiation should begin shortly."* Add a screenshot comment: `<!-- screenshot: agent-install.sh success output on the Pi -->`.

- [ ] **Step 4: Write "Verify and register with a node policy"**

```bash
hzn version
hzn node list | jq '.configstate.state'   # -> "configured"
```
If the installer registered the node already, show re-registering with an explicit policy:
```bash
cat > node.policy.json <<'EOF'
{
  "properties": [
    { "name": "purpose", "value": "edge-ai" },
    { "name": "model", "value": "rpi5-8gb" }
  ],
  "constraints": []
}
EOF
hzn register --policy node.policy.json
hzn node list | jq '{id: .id, org: .organization, state: .configstate.state}'
```
`*Why?*`: properties describe the node so the hub can match services to it later without anyone naming the node. Add `<!-- screenshot: the node appearing online in the hub web UI -->`.

- [ ] **Step 5: Write the troubleshooting aside + `## Next`**

Short list: `sudo -E` missing → "HZN_FSS_CSSURL must be specified"; `-i 'anax:'` missing → "packages not found"; node not registering → run `hzn register -o "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH"` manually. Then:

```markdown
## Next

On to [chapter three](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH03%20-%20Hosting%20Your%20Own%20Hub#chapter-three---hosting-your-own-hub) if you want to run the hub yourself — **optional**. To stay on the shared hub, skip straight to [chapter four](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH04%20-%20Deployment%20Policies#chapter-four---deployment-policies).
```

- [ ] **Step 6: Confirm CH01 → CH02 link**

Open `CH01 - Docker/README.md`; verify the `## Next` added in Task 3 targets `CH02%20-%20Open%20Horizon%20Fundamentals` with anchor `#chapter-two---open-horizon-fundamentals`. Fix if the H1 slug differs.

- [ ] **Step 7: Write the V3 beat sheet**

Create `docs/video/V03-ch02-fundamentals.md`: 7 beats from video spec V3; shot list (run `agent-install.sh`; `hzn register`; cut to a browser refreshing the hub dashboard, node flips to green "from across the internet"); assets (Pi terminal capture, hub-UI screen capture, a "×40 across 5 buildings" motion-graphic card); caption "Forty Pis. One command. Zero road trips." / end-card "Full walkthrough → CH02".

- [ ] **Step 8: Build check**

Run: `bundle exec jekyll build` → exit 0. Grep the new README for a bare `docker`/`podman` command — there should be none (CH02 is engine-agnostic). Confirm all four links in the two `## Next` sections are well-formed.

- [ ] **Step 9: Commit**

```bash
git add "CH02 - Open Horizon Fundamentals/" "CH01 - Docker/README.md" "docs/video/V03-ch02-fundamentals.md"
git commit -m "docs: add CH02 Open Horizon Fundamentals and V3 beat sheet"
```

---

## Task 5: CH03 — Hosting Your Own Hub *(optional branch)* (+ V4)

**Files:**
- Create: `CH03 - Hosting Your Own Hub/README.md`
- Create: `CH03 - Hosting Your Own Hub/images/.gitkeep`
- Create: `docs/video/V04-ch03-selfhost.md`

**Interfaces:**
- Consumes: the container engine (CH01), the agent/hub concepts and `HZN_*` vars (CH02).
- Produces: an alternative set of `HZN_EXCHANGE_URL` / `HZN_FSS_CSSURL` / `HZN_AGBOT_URL` values pointing at the reader's own host. Readers who take this branch use these from CH04 onward; readers who skip it keep the shared-hub values from CH02. Nothing later *requires* CH03.

- [ ] **Step 1: Scaffold + "This chapter is optional" banner**

Directory, `images/.gitkeep`, `README.md` with `# Chapter Three - Hosting Your Own Hub`, the unverified blockquote, then a bold callout: *Optional. Skip this and stay on the shared hub from CH02 — you rejoin the main path at CH04 either way. Take it if you need full control over where fleet data lives.*

- [ ] **Step 2: Write "What you're standing up" + prerequisites**

The hub is three container workloads — **exchange** (the API + policy store), **agbot** (the agreement bot that matches nodes to services), **CSS** (the Cloud Sync Service for file/model distribution) — plus a database. Prereq: a second always-on 64-bit Linux host (a NUC, a spare server, a cloud VM) with your container engine and `docker compose` (or `podman compose`); **not** the Pi. `*Why?*`: data residency, offline operation, cost predictability, and no dependency on a shared hub's uptime or policies.

- [ ] **Step 3: Write "Bring the stack up"**

Use the upstream all-in-one:
```bash
curl -sSL https://raw.githubusercontent.com/open-horizon/devops/master/mgmt-hub/deploy-mgmt-hub.sh -o deploy-mgmt-hub.sh
chmod +x deploy-mgmt-hub.sh
./deploy-mgmt-hub.sh
```
It prints the generated admin credentials, exchange root password and the URLs. Capture them:
```bash
export HZN_EXCHANGE_URL=http://<this-host-ip>:3090/v1
export HZN_FSS_CSSURL=http://<this-host-ip>:9443/
export HZN_AGBOT_URL=http://<this-host-ip>:3111
hzn exchange version
```
`<!-- screenshot: deploy-mgmt-hub.sh completion banner with URLs and credentials -->`. `*Why?*`: one script so the book does not become a hub-operations manual; sizing, TLS and backups are noted as "beyond this chapter".

- [ ] **Step 4: Write "Point an agent at your hub"**

Re-run the CH02 install against the new URLs (unregister first if needed):
```bash
hzn unregister -f -r
sudo -E ./agent-install.sh -O "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH" -i 'anax:'
hzn node list | jq '.configstate.state'
```
Note: everything from CH04 on works the same whether the hub is yours or the community's — only the `HZN_*` URLs differ. `<!-- screenshot: the Pi registered in your own hub UI -->`.

- [ ] **Step 5: `## Next`**

```markdown
## Next

On to [chapter four](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH04%20-%20Deployment%20Policies#chapter-four---deployment-policies) — deployment policies work identically against your hub or the shared one.
```

- [ ] **Step 6: Write the V4 beat sheet (bonus)**

Create `docs/video/V04-ch03-selfhost.md`: 7 beats from video spec V4; mark **bonus / off critical path**; shot list (`git`/`curl` the script, `compose up`, `hzn exchange version` against `localhost`, register a Pi, node in *your* dashboard); note in the file: record against a throwaway hub config, then switch the bench back to the shared hub so later episodes are unaffected. Caption "Built my own cloud. It's in the closet." / end-card "Full walkthrough → CH03 (optional)".

- [ ] **Step 7: Build check**

Run: `bundle exec jekyll build` → exit 0. Verify CH02's `## Next` offers both CH03 and CH04, and CH03's `## Next` → CH04.

- [ ] **Step 8: Commit**

```bash
git add "CH03 - Hosting Your Own Hub/" "docs/video/V04-ch03-selfhost.md"
git commit -m "docs: add CH03 self-hosted hub (optional) and V4 beat sheet"
```

---

## Task 6: CH04 — Deployment Policies (+ V5)

**Files:**
- Create: `CH04 - Deployment Policies/README.md`
- Create: `CH04 - Deployment Policies/images/.gitkeep`
- Create: `docs/video/V05-ch04-deployment-policies.md`

**Interfaces:**
- Consumes: a registered node with a `purpose` property (CH02); `HZN_*` env vars (CH02 or CH03).
- Produces: a published deployment policy named `<org>/policy-edge-ai` with constraint `purpose == edge-ai`; the workflow `hzn exchange deployment addpolicy` / `hzn deploycheck deployment`; the pattern "publish a policy, register a matching node, service auto-deploys" that CH07 reuses to deploy the AI stack.

- [ ] **Step 1: Scaffold**

Directory, `images/.gitkeep`, `README.md` with `# Chapter Four - Deployment Policies` + unverified blockquote.

- [ ] **Step 2: Write "What a deployment policy is"**

A deployment policy attaches to a **service** and says *which nodes it belongs on*, by property constraint — never by hostname. The agbot continuously matches published services against node properties and forms agreements automatically. `*Why?*`: you stop deploying to nodes; nodes that match pull the workload themselves, so adding the 41st Pi is zero extra work.

- [ ] **Step 3: Write "A service to deploy"**

Use a published sample so the chapter is self-contained — the IBM hello service, or a tiny published `web-hello`. Show listing what is available:
```bash
hzn exchange service list -o IBM | jq '.[] | select(test("helloworld"))'
```
Note: CH07 replaces this sample with the real Ollama + Open WebUI service; the *policy mechanics* are identical.

- [ ] **Step 4: Write "Author and publish the policy"**

```bash
cat > deployment.policy.json <<'EOF'
{
  "label": "edge-ai services",
  "description": "Runs on any node whose purpose is edge-ai",
  "service": {
    "name": "<service-name>",
    "org": "<service-org>",
    "arch": "*",
    "serviceVersions": [{ "version": "*" }]
  },
  "constraints": [ "purpose == edge-ai" ],
  "userInput": []
}
EOF
hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-edge-ai"
hzn exchange deployment listpolicy "$HZN_ORG_ID/policy-edge-ai"
```
`*Why?*` on `constraints`: it is a boolean expression over node properties; `purpose == edge-ai` matches the property set in CH02's `node.policy.json`.

- [ ] **Step 5: Write "Watch it deploy itself"**

```bash
hzn deploycheck deployment -b "$HZN_ORG_ID/policy-edge-ai"   # dry-run compatibility
# then, on a freshly registered node with purpose=edge-ai — walk away, come back:
hzn agreement list | jq '.[] | {service: .workload_to_run.url, state: .agreement_finalized_time}'
```
`<!-- screenshot: hzn agreement list showing the service running on a node that was never named -->`. `*Why?*`: the node was selected by property; no targeting, no SSH.

- [ ] **Step 6: `## Next`**

```markdown
## Next

On to [chapter five](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH05%20-%20Node%20Policies#chapter-five---node-policies) — where the node itself gets a say in what lands on it.
```

- [ ] **Step 7: Write the V5 beat sheet**

`docs/video/V05-ch04-deployment-policies.md`: 7 beats from video spec V5; shot list (publish policy with `purpose == edge-ai`; plug in a fresh Pi; timelapse "walk away"; return to `hzn agreement list` green); caption "They deploy to themselves." / end-card "Full walkthrough → CH04".

- [ ] **Step 8: Build check**

Run: `bundle exec jekyll build` → exit 0. Confirm CH04 `## Next` → CH05 and CH03 + CH02-branch links into CH04 resolve.

- [ ] **Step 9: Commit**

```bash
git add "CH04 - Deployment Policies/" "docs/video/V05-ch04-deployment-policies.md"
git commit -m "docs: add CH04 deployment policies and V5 beat sheet"
```

---

## Task 7: CH05 — Node Policies (+ V6)

**Files:**
- Create: `CH05 - Node Policies/README.md`
- Create: `CH05 - Node Policies/images/.gitkeep`
- Create: `docs/video/V06-ch05-node-policies.md`

**Interfaces:**
- Consumes: a published service + deployment policy pattern (CH04); a registered node and `node.policy.json` (CH02).
- Produces: the `hzn policy update` workflow and node properties like `camera == true`, `arch`, `ram_gb`; the idea that a service's own constraints and a node's own properties must both agree before an agreement forms — reused in CH08 where the monitor is constrained to nodes running the AI workload.

- [ ] **Step 1: Scaffold**

Directory, `images/.gitkeep`, `README.md` with `# Chapter Five - Node Policies` + unverified blockquote.

- [ ] **Step 2: Write "Two halves of the match"**

CH04 was the service side. The node side is a **node policy**: the node advertises properties about itself (`camera == true`, `arch == arm64`, `ram_gb == 8`), and a service that declares a constraint only lands where the constraint holds. Both sides opt in. `*Why?*`: an image classifier on a camera-less Pi just logs errors forever; let the hardware declare what it is.

- [ ] **Step 3: Write "Set node properties"**

```bash
cat > node.policy.json <<'EOF'
{
  "properties": [
    { "name": "purpose", "value": "edge-ai" },
    { "name": "model",   "value": "rpi5-8gb" },
    { "name": "camera",  "value": true },
    { "name": "ram_gb",  "value": 8, "type": "int" }
  ],
  "constraints": []
}
EOF
hzn policy update -f node.policy.json
hzn policy list | jq '.properties'
```
Do this on the camera Pi only; leave the second Pi with `camera` absent.

- [ ] **Step 4: Write "Constrain a service to it"**

Add a constraint to the deployment policy from CH04 (or a second policy):
```bash
# in deployment.policy.json:
"constraints": [ "purpose == edge-ai", "camera == true" ]
```
```bash
hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-camera"
hzn deploycheck all -b "$HZN_ORG_ID/policy-camera"
```

- [ ] **Step 5: Write "Only the right Pi picks it up"**

```bash
# on the camera Pi:
hzn agreement list | jq 'length'   # -> 1
# on the other Pi:
hzn agreement list | jq 'length'   # -> 0
```
`<!-- screenshot: agreements on the camera Pi only; the other stays clean -->`. `*Why?*`: no manual placement; the fleet sorts itself.

- [ ] **Step 6: `## Next`**

```markdown
## Next

On to [chapter six](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH06%20-%20Secrets%20Management#chapter-six---secrets-management) — because that service is pulling from a private registry with a credential you should not hardcode.
```

- [ ] **Step 7: Write the V6 beat sheet**

`docs/video/V06-ch05-node-policies.md`: 7 beats from video spec V6; shot list (two Pis labelled on screen, one with a camera module; publish camera-constrained service; agreement forms on the camera Pi only); caption "The Pi finally knows what it is." / end-card "Full walkthrough → CH05".

- [ ] **Step 8: Build check**

Run: `bundle exec jekyll build` → exit 0. Confirm CH05 `## Next` → CH06 and CH04 `## Next` → CH05.

- [ ] **Step 9: Commit**

```bash
git add "CH05 - Node Policies/" "docs/video/V06-ch05-node-policies.md"
git commit -m "docs: add CH05 node policies and V6 beat sheet"
```

---

## Task 8: CH06 — Secrets Management: private registry credential (+ V7)

**Files:**
- Create: `CH06 - Secrets Management/README.md`
- Create: `CH06 - Secrets Management/images/.gitkeep`
- Create: `docs/video/V07-ch06-secrets.md`

**Interfaces:**
- Consumes: a published service + deployment policy (CH04/CH05); `HZN_*` env vars.
- Produces: a secret named `<org>/registry-pull` in the Horizon secrets manager holding `{ "auth": "<user>:<token>" }`; the `secretBinding` block shape used in a service definition; the rotation workflow (`hzn secretsmanager secret add` again → nodes pick up the new value with no redeploy). CH07 reuses `registry-pull` to pull the Open WebUI / model image if it is in a private registry.

- [ ] **Step 1: Scaffold**

Directory, `images/.gitkeep`, `README.md` with `# Chapter Six - Secrets Management` + unverified blockquote.

- [ ] **Step 2: Write "The problem with the obvious approach"**

A private image needs a registry login. Put that login in the service definition and it is in git; put it in the image and it ships to every node in the clear. `*Why?*`: credentials in git get scraped within minutes of a repo going public; you also want to rotate without rebuilding or re-registering anything.

- [ ] **Step 3: Write "Store the credential"**

The management hub runs a Vault-backed secrets manager. Store an org-scoped secret:
```bash
printf '{ "auth": "%s:%s" }' "$REGISTRY_USER" "$REGISTRY_TOKEN" \
  | hzn secretsmanager secret add --secretName registry-pull --secretFile -
hzn secretsmanager secret list
hzn secretsmanager secret read --secretName registry-pull   # metadata, not the value
```
`*Why?*` on org scope vs user scope: org secrets are bindable by any deployment policy in the org; user secrets are private to you.

- [ ] **Step 4: Write "Bind it to a service"**

In the service definition (or the deployment policy `secretBinding`):
```json
"secretBinding": [
  {
    "serviceOrgid": "<org>",
    "serviceUrl": "<service-name>",
    "secrets": [ { "registry-auth": "<org>/registry-pull" } ]
  }
]
```
The agent mounts the secret at `/open-horizon-secrets/registry-auth` inside the container; the service reads it at start to `docker login` its own pulls, or the agent uses it for the image pull directly. Show verifying:
```bash
hzn service configstate list
# exec into the running container:
cat /open-horizon-secrets/registry-auth
```

- [ ] **Step 5: Write "Rotate it, tell nobody"**

```bash
printf '{ "auth": "%s:%s" }' "$REGISTRY_USER" "$NEW_REGISTRY_TOKEN" \
  | hzn secretsmanager secret add --secretName registry-pull --secretFile -
```
The agent detects the new secret version and updates the mount on its next poll — no `hzn register`, no image rebuild, no redeploy. `<!-- screenshot: secret value inside the container changing after a rotate, same container ID -->`. `*Why?*`: rotation is now a one-liner against the hub, not a fleet-wide maintenance window.

- [ ] **Step 6: `## Next`**

```markdown
## Next

On to [chapter seven](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH07%20-%20Deploying%20Local%20AI#chapter-seven---deploying-local-ai) — the payoff: a real LLM running on the Pi, its image pulled with the credential you just secured.
```

- [ ] **Step 7: Write the V7 beat sheet**

`docs/video/V07-ch06-secrets.md`: adapt video spec V7's beats to the **registry credential** (not an AI API key) — problem: registry token pasted into a service def that is in a public repo (record scratch); fix: Horizon secrets manager, bind at deploy time; punchline "Rotated my token. Told nobody. Everything kept working."; demo: add secret → reference from service → deploy → `cat` it inside the container → rotate → the container sees the new value, same container, no redeploy. End-card "Full walkthrough → CH06".

- [ ] **Step 8: Build check**

Run: `bundle exec jekyll build` → exit 0. Confirm CH06 `## Next` → CH07 and CH05 `## Next` → CH06.

- [ ] **Step 9: Commit**

```bash
git add "CH06 - Secrets Management/" "docs/video/V07-ch06-secrets.md"
git commit -m "docs: add CH06 secrets (registry credential) and V7 beat sheet"
```

---

## Task 9: CH07 — Deploying Local AI: Ollama + Open WebUI (+ V8)

**Files:**
- Create: `CH07 - Deploying Local AI/README.md`
- Create: `CH07 - Deploying Local AI/images/.gitkeep`
- Create: `docs/video/V08-ch07-local-ai.md`

**Interfaces:**
- Consumes: deployment-policy workflow (CH04), node properties (CH05), `registry-pull` secret + `secretBinding` shape (CH06).
- Produces: a running Ollama runtime reachable on the node at `http://<node>:11434` and an Open WebUI chat UI on `http://<node>:3000`; the Horizon service name `edge-ai-chat` (org `<org>`) and its `userInput` key `OLLAMA_MODEL` (default `llama3.2:3b`). CH08's monitor reuses the Ollama endpoint via `MONITOR_LLM_HOST`; CH08 opts *this* service in to monitoring.

- [ ] **Step 1: Scaffold + hardware callout**

Directory, `images/.gitkeep`, `README.md` with `# Chapter Seven - Deploying Local AI` + unverified blockquote, then a bold hardware note: *This chapter needs a Raspberry Pi 4 or 5 with **8 GB RAM**. A 3B model quantised to 4-bit needs ~2 GB plus runtime; inference is seconds-to-minutes per prompt on a Pi, not instant. On 8 GB that is tight alongside the monitor from CH08 — use `llama3.2:1b` if you hit the memory ceiling.*

- [ ] **Step 2: Write "What you're deploying"**

Two containers as one Horizon service: **Ollama** (`ollama/ollama`) serves the model over HTTP; **Open WebUI** (`ghcr.io/open-webui/open-webui`) is the browser chat front-end pointed at Ollama. `*Why?*`: every cloud AI tutorial ends at "call the API" — your prompts leave the building, you pay per token, and no connectivity means no AI. Local inference fixes all three.

- [ ] **Step 3: Write the service definition**

```json
{
  "org": "<org>",
  "url": "edge-ai-chat",
  "version": "1.0.0",
  "arch": "arm64",
  "deployment": {
    "services": {
      "ollama": {
        "image": "ollama/ollama:latest",
        "environment": [ "OLLAMA_HOST=0.0.0.0" ],
        "ports": [ { "HostPort": "11434", "HostIP": "0.0.0.0" } ]
      },
      "open-webui": {
        "image": "ghcr.io/open-webui/open-webui:main",
        "environment": [ "OLLAMA_BASE_URL=http://ollama:11434" ],
        "ports": [ { "HostPort": "3000", "HostIP": "0.0.0.0" } ]
      }
    }
  },
  "userInput": [
    { "name": "OLLAMA_MODEL", "label": "model to pull", "type": "string", "defaultValue": "llama3.2:3b" }
  ]
}
```
If either image is in a private registry, add the `secretBinding` from CH06 referencing `<org>/registry-pull`. Note the images above are public, so the binding is optional here — "same pattern applies the moment you use a private model image".

- [ ] **Step 4: Write "Publish and deploy it"**

```bash
hzn exchange service publish -f service.definition.json
# reuse the CH04 deployment policy — point it at edge-ai-chat:
hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-edge-ai"
hzn deploycheck all -b "$HZN_ORG_ID/policy-edge-ai"
# on the Pi (purpose=edge-ai from CH02): agreement forms, images pull, model pulls
hzn agreement list | jq '.[].workload_to_run.url'
```
First model pull takes a while on a Pi — `<!-- screenshot: ollama pull progress in hzn service log -->`.

- [ ] **Step 5: Write "Talk to it — offline"**

```bash
# from a laptop on the same LAN:
open http://<pi-ip>:3000        # create the local account, pick the model
# sanity-check the raw API:
curl -s http://<pi-ip>:11434/api/generate -d '{"model":"llama3.2:3b","prompt":"one-sentence hello","stream":false}' | jq -r .response
```
Then: disconnect the Pi's network (unplug Ethernet / `sudo nmcli radio wifi off`) and ask it another question through the UI. It answers. `<!-- screenshot: chat answering with the Wi-Fi indicator off -->`. `*Why?*`: the model, the weights and the inference all live on the Pi; the network was only ever carrying your keystrokes.

- [ ] **Step 6: `## Next`**

```markdown
## Next

On to [chapter eight](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH08%20-%20Detecting%20Problems#chapter-eight---detecting-problems) — what happens when this crashes at 3 a.m. and nobody is watching?
```

- [ ] **Step 7: Write the V8 beat sheet**

`docs/video/V08-ch07-local-ai.md`: 7 beats from video spec V8, with beat 2 now concrete (Ollama + Open WebUI via Horizon, model auto-pulled; no API key); shot list (`hzn agreement list` green; open chat UI; on camera unplug the router; ask a question; it answers); note the latency reality — record the answer, speed-ramp the wait in the edit, do not fake real-time; caption "OpenAI called. I sent it to voicemail." / end-card "Full walkthrough → CH07".

- [ ] **Step 8: Build check**

Run: `bundle exec jekyll build` → exit 0. Confirm CH07 `## Next` → CH08 and CH06 `## Next` → CH07.

- [ ] **Step 9: Commit**

```bash
git add "CH07 - Deploying Local AI/" "docs/video/V08-ch07-local-ai.md"
git commit -m "docs: add CH07 local AI (Ollama + Open WebUI) and V8 beat sheet"
```

---

## Task 10: CH08 — Detecting Problems: the service-edge-ai monitor (+ V9)

**Files:**
- Create: `CH08 - Detecting Problems/README.md`
- Create: `CH08 - Detecting Problems/images/.gitkeep`
- Create: `docs/video/V09-ch08-detecting.md`

**Interfaces:**
- Consumes: the running `edge-ai-chat` service and the Ollama endpoint `http://<node>:11434` (CH07); deployment/node policy workflow (CH04/CH05).
- Produces: `service-edge-ai` running on the node with `MONITOR_LLM_HOST` pointed at CH07's Ollama; the CH07 service definition edited to add `MONITORING_ENABLED=true` + `MONITORING_LOG_PATHS=/var/log/workloads/edge-ai-chat/app.log` + `MONITORING_ERROR_PATTERNS=ERROR,FATAL` in its `deployment` section, a shared `/var/log/workloads` volume and `privileged: true`; proposal files at `/var/lib/monitor/proposals/edge-ai-chat/<key>.json` with the schema (`error_summary`, `root_cause`, `severity`, `remediation_steps`, `confidence`, `requires_human_review`, `metadata`) that CH09's executor parses.

- [ ] **Step 1: Scaffold**

Directory, `images/.gitkeep`, `README.md` with `# Chapter Eight - Detecting Problems` + unverified blockquote.

- [ ] **Step 2: Write "You need more than vibes"**

A user says the AI is down. You have no dashboard, no logs, no idea. Open Horizon already surfaces node and agreement health; on top of that, `service-edge-ai` watches a workload's logs and, when it sees an error, asks a **local** LLM what went wrong and writes a structured proposal. `*Why?*`: the failure becomes a readable artifact — summary, likely root cause, severity, suggested steps — instead of a paging alert with no context.

- [ ] **Step 3: Write "Deploy the monitor"**

```bash
git clone https://github.com/joewxboy/service-edge-ai
cd service-edge-ai
export HZN_ORG_ID=<your-org>
sudo mkdir -p /var/log/workloads
# point it at the Ollama runtime CH07 already started:
export MONITOR_LLM_HOST=http://<pi-ip>:11434
export MONITOR_LLM_MODEL=llama3.2:3b
make deploy-check
make publish
curl -sS http://<pi-ip>:8080/health | jq
```
Explain: `make publish` publishes the service + its policies and registers the node; `MONITOR_LLM_AUTO_PULL=true` means it pulls the model if CH07 has not already; the health endpoint reports `workloads_discovered`, `workloads_monitored`, `proposals_written`.

- [ ] **Step 4: Write "Opt the AI service in"**

Monitoring is opt-in — edit CH07's `edge-ai-chat` service definition, `deployment` section:
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
  "binds": [ "/var/log/workloads:/var/log/workloads:rw" ]
}
```
`*Why?*` the variables must be inside `deployment`: the exchange discards unknown top-level fields, so a custom `monitoring` block would never reach the node. `*Why?*` the shared bind + `privileged`: `MONITORING_LOG_PATHS` is resolved inside the monitor's container, so both containers must see the same file, and a writable bind to root-owned `/var/log/workloads` needs `privileged: true`. Republish:
```bash
hzn exchange service publish -f service.definition.json
```

- [ ] **Step 5: Write "Break it on purpose"**

```bash
# on the Pi:
docker kill $(docker ps --filter name=open-webui -q)   # or: podman kill …
hzn eventlog list | tail -n 20                          # agreement/exec errors show here
watch -n 5 'ls -t /var/lib/monitor/proposals/edge-ai-chat/'
cat /var/lib/monitor/proposals/edge-ai-chat/*.json | jq '{error_summary, root_cause, severity, confidence, requires_human_review}'
```
Expect a proposal file within a poll cycle or two (the monitor polls every 60 s; analysis is minutes on a Pi). `<!-- screenshot: hzn eventlog red + the proposal JSON side by side -->`. `*Why?*`: the container dying is now a described event with a root-cause guess, not silence.

- [ ] **Step 6: `## Next`**

```markdown
## Next

On to [chapter nine](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH09%20-%20Autonomous%20Remediation#chapter-nine---autonomous-remediation) — now that it can see the break and describe it, can it fix it?
```

- [ ] **Step 7: Write the V9 beat sheet**

`docs/video/V09-ch08-detecting.md`: 7 beats from video spec V9; shot list (AI service green on the dashboard; `docker kill` the container on camera; `hzn eventlog` flips red; `cat` the proposal JSON, highlight `root_cause`); note: the analysis wait is real — cut to the proposal, timestamp-overlay the gap; caption "It broke, and for once it admitted it." / end-card "Full walkthrough → CH08".

- [ ] **Step 8: Build check**

Run: `bundle exec jekyll build` → exit 0. Confirm CH08 `## Next` → CH09 and CH07 `## Next` → CH08. Grep the README: any `docker`-only command (`docker kill`, `docker ps`) must also show the `podman` form or note "or your engine's equivalent".

- [ ] **Step 9: Commit**

```bash
git add "CH08 - Detecting Problems/" "docs/video/V09-ch08-detecting.md"
git commit -m "docs: add CH08 detecting problems (service-edge-ai monitor) and V9 beat sheet"
```

---

## Task 11: CH09 — Autonomous Remediation: the executor (capstone) (+ V10)

**Files:**
- Create: `CH09 - Autonomous Remediation/README.md`
- Create: `CH09 - Autonomous Remediation/images/.gitkeep`
- Create: `CH09 - Autonomous Remediation/remediate.sh` (reference snippet the reader deploys)
- Create: `docs/video/V10-ch09-remediation.md`

**Interfaces:**
- Consumes: proposal files at `/var/lib/monitor/proposals/<workload>/<key>.json` with fields `severity`, `confidence`, `requires_human_review`, `root_cause`, `metadata.service_name` (CH08); the running `edge-ai-chat` service (CH07); `hzn` on the node.
- Produces: the final book artifact — a deployed `edge-ai-remediator` service that closes the loop. No later task consumes it.

- [ ] **Step 1: Scaffold + honest framing**

Directory, `images/.gitkeep`, `README.md` with `# Chapter Nine - Autonomous Remediation` + unverified blockquote, then: *`service-edge-ai` stops at advice on purpose — every proposal carries `requires_human_review: true` and it never touches your workloads. This chapter builds the missing piece: a small, auditable executor that reads those proposals and acts on the safe ones.*

- [ ] **Step 2: Write "The gate"**

You do not want a model with `sudo`. The executor only acts when **all** hold: `severity` in {`high`,`critical`}, `confidence >= 0.9`, and the proposal's `root_cause` matches a known, reversible pattern (container exited / OOM / config typo). Everything else is logged and left for a human. `*Why?*`: bounded autonomy — the blast radius of a wrong call is one `docker restart`, not a fleet.

- [ ] **Step 3: Write `remediate.sh`**

```bash
#!/usr/bin/env bash
set -euo pipefail
PROPOSAL_DIR=${MONITOR_PROPOSAL_DIR:-/var/lib/monitor/proposals}
LOG=/var/log/workloads/remediator/actions.log
mkdir -p "$(dirname "$LOG")"

find "$PROPOSAL_DIR" -name '*.json' -newer /tmp/.remediator-cursor 2>/dev/null | while read -r f; do
  read -r sev conf review cause svc < <(jq -r '[.severity, .confidence, .requires_human_review, .root_cause, .metadata.service_name] | @tsv' "$f")
  if [[ "$sev" =~ ^(high|critical)$ ]] && (( $(echo "$conf >= 0.9" | bc -l) )); then
    case "$cause" in
      *"exited"*|*"OOM"*|*"not running"*|*"crash"*)
        echo "$(date -Is) RESTART $svc (conf=$conf) :: $cause" >> "$LOG"
        docker restart "$(docker ps -a --filter "name=$svc" -q)" || hzn register --policy /etc/horizon/node.policy.json ;;
      *)
        echo "$(date -Is) SKIP $svc unknown cause :: $cause" >> "$LOG" ;;
    esac
  else
    echo "$(date -Is) HOLD $svc sev=$sev conf=$conf review=$review" >> "$LOG"
  fi
done
touch /tmp/.remediator-cursor
```
Explain every branch. Note `docker restart` → `podman restart` on Podman hosts.

- [ ] **Step 4: Write "Deploy it as a service"**

A minimal Horizon service `edge-ai-remediator` that runs `remediate.sh` on a timer, with `binds` for `/var/lib/monitor/proposals:ro`, `/var/log/workloads:rw`, and the container socket (`/var/run/docker.sock` or the Podman socket) — call out the security tradeoff of mounting the socket and why it is scoped to this one node. Publish with `hzn exchange service publish -f remediator.service.json` and let the CH04 policy place it.

- [ ] **Step 5: Write "Watch it heal"**

```bash
# everything green:
hzn agreement list | jq 'length'
# break it:
docker kill $(docker ps --filter name=open-webui -q)
# hands off the keyboard. CH08 writes a proposal; the remediator reads it:
tail -f /var/log/workloads/remediator/actions.log
# -> RESTART edge-ai-chat ... ; service returns to green
curl -sS http://<pi-ip>:8080/health | jq '.healthy'
```
`<!-- screenshot: actions.log RESTART line + health back to true, no hands on keyboard -->`. `*Why?*`: the 3 a.m. OOM crash is now a log line and a recovered service, and the low-confidence cases still wait for you.

- [ ] **Step 6: `## Next` (series wrap)**

```markdown
## Next

That is the build: a Pi that runs AI and heals itself. From here — add nodes and let the policies place everything; wire `service-edge-ai`'s [northbound export](https://github.com/joewxboy/service-edge-ai) to your issue tracker; or raise the executor's confidence gate as you learn which fixes are safe. Join the [Open Horizon community](https://github.com/open-horizon) and tell us what you built.
```

- [ ] **Step 7: Write the V10 beat sheet**

`docs/video/V10-ch09-remediation.md`: 7 beats from video spec V10; shot list (all green; break the workload; hands visibly leave the keyboard; `actions.log` tails a RESTART line; health flips back to true); note the multi-minute analysis gap — B-roll the "asleep at 3 a.m." frame over it; caption "I automated my own on-call." / end-card "Full walkthrough → CH09".

- [ ] **Step 8: Build check**

Run: `bundle exec jekyll build` → exit 0. `bash -n "CH09 - Autonomous Remediation/remediate.sh"` → no syntax errors. Confirm CH08 `## Next` → CH09.

- [ ] **Step 9: Commit**

```bash
git add "CH09 - Autonomous Remediation/" "docs/video/V10-ch09-remediation.md"
git commit -m "docs: add CH09 autonomous remediation capstone and V10 beat sheet"
```

---

## Task 12: Trailer + V1 beat sheets; finalize the tracker

**Files:**
- Create: `docs/video/Ep0-trailer.md`
- Create: `docs/video/V01-intro-getting-ready.md`
- Modify: `docs/video/index.md` (fill in all 11 rows now that every beat sheet exists)

**Interfaces:**
- Consumes: every V1–V10 beat sheet (Tasks 3–11) and `docs/video/00-template.md` (Task 2).
- Produces: the complete written video package. No later task consumes it.

- [ ] **Step 1: Write the V1 beat sheet**

`docs/video/V01-intro-getting-ready.md` from video spec V1: problem (digging the cable drawer for a monitor); fix (Raspberry Pi Imager pre-configure — bake SSH + Wi-Fi onto the card); demo (flash with the SSH+Wi-Fi preset → boot with only power → `ssh pi@raspberrypi.local` → prompt, no screen ever connected); hook ("it's alive but it can't run anything — next we give it an engine"); end-card "Full walkthrough → the Introduction chapter". Add shot list + asset checklist. Note: the Introduction chapter README is **not** changed by this plan; V1 dramatizes it as written.

- [ ] **Step 2: Write the trailer beat sheet**

`docs/video/Ep0-trailer.md` from video spec Ep0: ~0:50, compressed structure (problem → what the series is → punchline "No cloud bill. No PhD. One Pi." → montage → hook "Ten videos. One build. Starts now." → CTA → book pointer). **Montage source:** clips from V8–V10 (headless boot, node appears in hub, service auto-deploys, LLM answers offline, container dies red, executor restarts it). **Fallback:** rough cut from V1–V3 footage + screen-recorded mockups if the capstone is not shot by launch; re-cut later. State: produced last, published first.

- [ ] **Step 3: Fill the production tracker**

In `docs/video/index.md`, ensure all 11 rows are present with the beat-sheet cell now `☑` (file exists) and recorded/edited/published still `☐`. Add a "Build order" line: `Ep0(last) → V1 → V2 → V3 → (V4 bonus) → V5 → V6 → V7 → V8 → V9 → V10`.

- [ ] **Step 4: Build check**

Run: `bundle exec jekyll build` → exit 0. Confirm every `docs/video/V*.md` and `Ep0-trailer.md` link resolves from `index.md`.

- [ ] **Step 5: Commit**

```bash
git add "docs/video/Ep0-trailer.md" "docs/video/V01-intro-getting-ready.md" "docs/video/index.md"
git commit -m "docs: add trailer and V1 beat sheets; finalize video tracker"
```

---

## Task 13: Full-book integration pass

**Files:**
- Create: `docs/video/HARDWARE-VERIFICATION.md`
- Modify: `index.html` (optional TOC — see Step 4)
- Modify: any chapter README with a broken link found in Step 1

**Interfaces:**
- Consumes: every chapter and video file from Tasks 1–12.
- Produces: a verified, navigable book and the deferred-verification checklist.

- [ ] **Step 1: Walk the `## Next` chain**

Trace: `Introduction → CH01 → CH02 → CH03 → CH04 → CH05 → CH06 → CH07 → CH08 → CH09`, plus the CH02→CH04 skip link. For each link confirm: the target directory name matches the URL exactly (spaces as `%20`), and the `#chapter-...` anchor matches the target's H1 GitHub slug (lowercase, spaces→`-`, `&`/punctuation dropped). Fix any mismatch in place.

- [ ] **Step 2: Convention sweep**

For CH02–CH09: confirm each opens with the unverified blockquote; each ends with exactly one `## Next` (CH09's is the series-wrap variant); every reader command is in a ` ```bash ` fence; no absolute image paths; every `<img>` points to a file that exists and every not-yet-captured screenshot is an `<!-- screenshot: ... -->` comment. For CH02–CH09: grep for a bare `docker `/`docker-compose ` not paired with a `podman` form or an "or your engine's equivalent" note; fix.

- [ ] **Step 3: Build**

Run: `bundle exec jekyll build`
Expected: exit 0, no `_site` errors. If Bundler is unavailable, state so in the commit body and confirm every internal link/image resolves by hand.

- [ ] **Step 4: Optional — chapter TOC on the landing page**

`index.html` is currently a placeholder. If it still is, add a plain `<ul>` of the ten chapters linking to each directory (relative links), matching the existing minimal markup. Skip if the user has since styled it.

- [ ] **Step 5: Write the hardware-verification checklist**

`docs/video/HARDWARE-VERIFICATION.md`: one section per chapter (CH01–CH09), each a checkbox list of the exact commands and claims to validate on the bench — agent install on a real Pi, `hzn register`, policy match, secret rotation visible in-container, model pull + offline answer timing, monitor proposal latency, executor restart. Cross-reference the "critical dates" from the video spec Section 3 (service-edge-ai locked by end of week 2; bench at CH07 state by week 8). This is the list the parallel shared-prep weeks work through.

- [ ] **Step 6: Commit**

```bash
git add "docs/video/HARDWARE-VERIFICATION.md" index.html $(git diff --name-only)
git commit -m "docs: full-book integration pass; add hardware-verification checklist"
```

---

## Self-Review

**Spec coverage — book outline:**
- CH01 Docker+Podman neutrality → Task 3. ✅
- CH02 Fundamentals (agent install + register to existing hub) → Task 4. ✅
- CH03 self-hosted hub, optional branch, rejoin at CH04 → Task 5. ✅
- CH04 deployment policies → Task 6. ✅
- CH05 node policies → Task 7. ✅
- CH06 secrets → Task 8 (registry credential per resolved open question). ✅
- CH07 local AI → Task 9 (Ollama + Open WebUI per resolved open question). ✅
- CH08 detecting problems → Task 10 (`service-edge-ai` monitor). ✅
- CH09 autonomous remediation → Task 11 (executor built on proposals). ✅
- Linear `## Next` flow → wiring convention in Global Constraints + Task 13 Step 1. ✅
- "One chapter, one short video" → every chapter task also produces its beat sheet. ✅
- `service-edge-ai` open question → Task 1. ✅

**Spec coverage — video series:**
- 11 videos (Ep0 + V1–V10), V4 bonus → Tasks 3–12, tracker in Task 2/12. ✅
- Video template / recording rig / end card → Task 2. ✅
- 7-beat sheets per video → each chapter task; format from `00-template.md`. ✅
- Build-in-chapter-order sequence → "Build order" line in Task 12 Step 3; matches Task order. ✅
- Trailer produced last, published first → Task 12 Step 2. ✅
- Parallel shared-prep (chapter + video same week) → each Task 3–11 pairs a chapter with its beat sheet; `HARDWARE-VERIFICATION.md` (Task 13) is the week-by-week bench worklist. ✅
- V7–V10 revised for verified reality → Tasks 8–11 beat-sheet steps + Task 1 addenda. ✅
- Week-by-week timeline / cadence model → this is an execution schedule for the human creator, not a repo artifact; captured by reference in `HARDWARE-VERIFICATION.md`. Not turned into plan tasks because the plan produces the *written package*, not the shooting schedule. Noted here intentionally.

**Placeholder scan:** command blocks are concrete; screenshots are explicit `<!-- screenshot: ... -->` directives, not vague "add an image". Prose sections specify the exact commands and `*Why?*` points to cover. No "TBD"/"similar to Task N"/"add error handling". ✅

**Type/name consistency:** service name `edge-ai-chat` (CH07) referenced identically in CH08/CH09; secret `<org>/registry-pull` and mount `/open-horizon-secrets/registry-auth` consistent CH06→CH07; proposal path `/var/lib/monitor/proposals/<workload>/<key>.json` and fields (`severity`, `confidence`, `requires_human_review`, `root_cause`, `metadata.service_name`) consistent CH08→CH11 executor; env vars `MONITOR_LLM_HOST` / `MONITOR_LLM_MODEL` / `MONITORING_ENABLED` / `MONITORING_LOG_PATHS` / `MONITORING_ERROR_PATTERNS` match the verified repo README; node property `purpose == edge-ai` set in CH02, constrained in CH04, reused in CH07. Beat-sheet filenames `V0N-chNN-slug.md` consistent between each creating task and Task 12's tracker. ✅

---

## Execution Handoff

Plan complete and saved to `docs/superpowers/plans/2026-08-29-open-horizon-book-and-video-series.md`. Two execution options:

**1. Subagent-Driven (recommended)** — dispatch a fresh subagent per task, review between tasks, fast iteration. REQUIRED SUB-SKILL: superpowers:subagent-driven-development.

**2. Inline Execution** — execute tasks in this session using superpowers:executing-plans, batch execution with checkpoints for review.

Which approach?
