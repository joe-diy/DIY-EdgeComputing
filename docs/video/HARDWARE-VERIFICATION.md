# Hardware Verification Checklist — DIY Edge Computing

**Date:** 2026-08-29
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md) Section 3
**Purpose:** the bench worklist for the parallel shared-prep weeks. Every chapter
CH01–CH09 carries the `⚠️ Not yet hardware-verified` blockquote until the items
below are checked off on a real Raspberry Pi bench (2 Pis + camera + optional
NUC, per the video spec Section 2 "Reusable assets"). Each box is a concrete
command or claim to run and confirm — output shape, timing, and side effects —
against real hardware, not documentation.

Check an item only when it has been run on the bench and the observed behaviour
matches what the chapter (or this list) says. Where a box asks an open question,
record the answer here and reconcile the chapter prose to it.

---

## Critical dates (video spec Section 3)

- [x] `service-edge-ai` model / runtime / secret **locked by end of week 2** —
  DONE. See [`00-verification-service-edge-ai.md`](00-verification-service-edge-ai.md)
  and the spec's "Addendum 2026-08-29 — `service-edge-ai` verified".
- [ ] Bench reaches **CH07 state (LLM running on a Pi) by week 8**, so V8 can be
  recorded on real hardware and the trailer re-cut (week 11) has capstone footage.
- [ ] Second Pi + camera on the bench before CH05 / V6 week (spec Section 2 hard
  dependency).
- [ ] NUC (or spare 64-bit Linux host) available for CH03 / V4; bench reset to
  shared-hub state afterwards so later chapters are unaffected.

---

## CH01 — Containers with Docker and Podman

- [ ] `docker run -it ubuntu /bin/bash` and `podman run -it ubuntu /bin/bash` on
  the Pi both pull `ubuntu:latest` (arm64) and drop to a `root@…#` shell.
- [ ] `docker ps` / `podman ps` show identical column headers and (when nothing
  runs) no rows.
- [ ] `docker run -itd ubuntu` / `podman run -itd ubuntu` each print a container
  ID; `ps` then lists the abbreviated ID.
- [ ] `docker ps -q` / `podman ps -q`, `docker ps -a` / `podman ps -a`,
  `docker images` / `podman images`, `docker images -q` / `podman images -q`
  give the same output shape under both engines.
- [ ] `docker attach <ID>` / `podman attach <ID>` re-enter the shell; `exit`
  stops the container.
- [ ] `docker rm <ID>` / `podman rm <ID>` and the bulk `rm $(… ps -aq)` /
  `rmi $(… images -q)` forms behave identically.
- [ ] The same `container run` / `ps` / `images` commands give byte-identical
  output (modulo the engine name) under Docker and Podman on a Pi — the CH01
  "aha" and V2's dramatized moment.
- [ ] `docker build ./` / `podman build ./` build the sample `Dockerfile`;
  Podman also builds it when the file is named `Containerfile`.
- [ ] `sudo usermod -aG docker pi` then reboot: `pi` runs `docker` without
  `sudo`.

## CH02 — Open Horizon Fundamentals

- [ ] The four `HZN_*` exports from an LF Edge Community Lab free-hub account are
  accepted by the installer.
- [ ] `curl … agent-install.sh` then `sudo -E ./agent-install.sh -O "$HZN_ORG_ID"
  -u "$HZN_EXCHANGE_USER_AUTH" -i 'anax:'` succeeds on a real Pi and ends with
  *"Horizon node is registered. Workload agreement negotiation should begin
  shortly."*
- [ ] Dropping `-E` reproduces `Error: HZN_FSS_CSSURL must be specified`
  (confirms the troubleshooting note).
- [ ] `hzn version` and `hzn node list | jq '.configstate.state'` → `"configured"`.
- [ ] Node appears online in the hub web UI.
- [ ] **Open question:** is `hzn unregister -f -r` actually required before
  `hzn register --policy node.policy.json`, or does the installer leave the node
  in a state where `hzn register` alone works? Does the `-r` (remove exchange
  record) matter here, or is `-f` enough? Record the answer and fix the prose.
- [ ] After re-register, `hzn node list | jq '{id, org, state}'` shows the node
  `configured` with the `purpose=edge-ai` / `model=rpi5-8gb` policy attached.
- [ ] Fallback `hzn register -o "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH"`
  recovers a node that never reached `configured`.

## CH03 — Hosting Your Own Hub

- [ ] `deploy-mgmt-hub.sh` completes on a NUC / spare 64-bit Linux host (not the
  Pi) and prints the completion banner with admin credentials, exchange root
  password, and service URLs.
- [ ] **Open question:** does the script run the stack under `podman compose`, or
  is it Docker-only in practice? Note which engine was used and any `podman
  compose` gaps.
- [ ] The printed URLs/ports answer: exchange on `:3090/v1`
  (`hzn exchange version` returns a version), CSS on `:9443/`, agbot on `:3111`.
- [ ] Re-pointing the CH02 Pi at the new hub: `hzn unregister -f -r` then the
  byte-for-byte CH02 `agent-install.sh` line with the new `HZN_*` values in the
  environment → `hzn node list | jq '.configstate.state'` → `"configured"`
  against the self-hosted hub.
- [ ] After the re-point, `hzn unregister -f -r` + `hzn register --policy
  node.policy.json` re-attaches the CH02 node policy; `hzn policy list | jq
  '.properties'` shows `purpose=edge-ai` / `model=rpi5-8gb` against the
  self-hosted hub — without this step the installer's default policy is all the
  node carries and nothing from CH04 on matches.
- [ ] `HZN_ORG_ID` / `HZN_EXCHANGE_USER_AUTH` from the banner (generated admin
  org + credentials) work for subsequent `hzn exchange` calls.
- [ ] Bench reset to shared-hub state afterwards — later chapters must not depend
  on the self-hosted hub.

## CH04 — Deployment Policies

- [ ] `hzn exchange service list -o IBM | jq '.[] | select(test("helloworld"))'`
  lists a usable multi-arch sample (e.g. `ibm.helloworld`) in every exchange.
- [ ] `hzn exchange deployment addpolicy -f deployment.policy.json
  "$HZN_ORG_ID/policy-edge-ai"` publishes; `listpolicy` reads back exactly what
  was sent.
- [ ] `hzn deploycheck deployment -b "$HZN_ORG_ID/policy-edge-ai"` — confirm the
  output shape (compatibility result for service + deployment policy + matching
  node policies) and that it forms no agreement.
- [ ] A fresh node registered with only `purpose=edge-ai` auto-forms an
  agreement with `policy-edge-ai` — no node named anywhere.
- [ ] `hzn agreement list | jq '.[] | {service: .workload_to_run.url, state:
  .agreement_finalized_time}'` shows a populated `agreement_finalized_time`
  within a few minutes (the V5 dramatized moment: plug in a Pi, walk away).

## CH05 — Node Policies

- [ ] `hzn policy update -f node.policy.json` replaces the live policy in place —
  no unregister / re-register needed (contrast CH02).
- [ ] `hzn policy list | jq '.properties'` reads back all four properties
  (`purpose`, `model`, `camera`, `ram_gb` with `"type": "int"`). **Check nesting:**
  on newer anax the properties may sit under a nested key — confirm the `jq` path
  in the chapter is right for the anax version on the bench.
- [ ] `ram_gb` compares as a number (int), not a string.
- [ ] `hzn exchange deployment addpolicy -f deployment.policy.json
  "$HZN_ORG_ID/policy-camera"` creates `policy-camera` beside `policy-edge-ai`
  without disturbing the original.
- [ ] `hzn deploycheck all -b "$HZN_ORG_ID/policy-camera"` — confirm the output
  shape and that it does fold in user-input + secret-binding checks on top of
  deployment-policy / service / node-policy evaluation (the "wider dry-run"
  claim added to the chapter).
- [ ] Camera Pi passes the dry-run; the bare Pi fails on `camera == true`.
- [ ] Confirm the CH04 `policy-edge-ai` agreement is torn down (or excluded)
  before reading the camera-service agreement count —
  `hzn exchange deployment removepolicy "$HZN_ORG_ID/policy-edge-ai"` — else both
  Pis read `1` (it has no `camera` term, so it holds an agreement on every
  `purpose == edge-ai` node).
- [ ] After the agbot runs: `hzn agreement list | jq 'length'` → `1` on the
  camera Pi, `0` on the other (the V6 dramatized moment).

## CH06 — Secrets Management

- [ ] **Confirm exact subcommands + flags** for `hzn secretsmanager secret
  add` / `list` / `read` against the bench's hub version — the chapter uses
  `--secretName` and `--secretFile -` (stdin). Correct if the CLI differs.
- [ ] `printf '{ "auth": "%s:%s" }' … | hzn secretsmanager secret add
  --secretName registry-pull --secretFile -` stores an org-scoped secret with no
  on-disk file and no shell-history leak.
- [ ] `hzn secretsmanager secret list` shows `registry-pull`.
- [ ] `hzn secretsmanager secret read --secretName registry-pull` returns
  **metadata only** (name, creation time, version) — never the value.
- [ ] `secretBinding` block on the service (or deployment policy) with key
  `registry-auth` → `<org>/registry-pull` causes the agent to mount the secret at
  `/open-horizon-secrets/registry-auth` on the node that won the agreement.
- [ ] The mount path `/open-horizon-secrets/registry-auth` is real; `cat` inside
  the container shows the `{ "auth": "…" }` object exactly as stored, delivered
  as a file (not an env var — absent from `ps` and `/proc/*/environ`).
- [ ] `hzn service configstate list` confirms the service runs under an
  agreement.
- [ ] Rotation: a second `secret add` against the existing name writes a new
  version; on the agent's next poll the mounted file updates in place.
- [ ] **Open question:** does a rotation keep the **same container ID** (file
  swapped in place, no restart), or does the service restart? The screenshot
  comment in the chapter assumes "same container ID" — confirm or reword.

## CH07 — Deploying Local AI

- [ ] The two-container `edge-ai-chat` service (Ollama `11434` + Open WebUI
  `3000`) deploys on a **Pi 5 / 8 GB** via one `hzn exchange service publish` +
  the reused CH04 deployment policy pointed at `edge-ai-chat`.
- [ ] `hzn deploycheck all -b "$HZN_ORG_ID/policy-edge-ai"` dry-runs the whole
  match before any agreement exists.
- [ ] Agbot forms the agreement on the `purpose=edge-ai` Pi; agent pulls both
  images, then Ollama pulls the model. **Time the first `llama3.2:3b` pull** on a
  Pi and record it.
- [ ] **Open question:** does `llama3.2:3b` (4-bit, ~2 GB + runtime) fit
  alongside the CH08 monitor + its analysis model on 8 GB, or is `llama3.2:1b`
  required? Record the memory ceiling and fix the chapter's guidance.
- [ ] `open http://<pi-ip>:3000` creates a local Open WebUI account (stays on the
  Pi) and lists the pulled model.
- [ ] `curl -s http://<pi-ip>:11434/api/generate -d '{"model":"llama3.2:3b",
  "prompt":"one-sentence hello","stream":false}' | jq -r .response` returns
  generated text with the UI out of the loop.
- [ ] **Offline demo:** pull the router's WAN uplink (Pi + laptop stay on the
  same switch); the chat UI on `:3000` still answers a fresh prompt — the CH07
  "aha" / V8 dramatized moment. (Screenshot comment reworded to "internet uplink
  disconnected".)
- [ ] Record per-prompt inference latency on the Pi (seconds-to-minutes,
  per the chapter warning).

## CH08 — Detecting Problems

- [ ] `git clone https://github.com/joewxboy/service-edge-ai`; `make deploy-check`
  dry-runs policy compatibility; `make publish` publishes the service + policies
  and runs `hzn register`.
- [ ] `curl -sS http://<pi-ip>:8080/health | jq` reports `workloads_discovered`,
  `workloads_monitored` (0 straight after publish), `proposals_written`.
- [ ] The `MONITOR_LLM_HOST` / `MONITOR_LLM_MODEL` env vars point the monitor at
  the CH07 Ollama (`:11434`) so one 3B model serves both chat and analysis;
  `MONITOR_LLM_AUTO_PULL=true` pulls the analysis model if CH07 has not cached it.
- [ ] `export MONITOR_LLM_TIMEOUT=600` in the deploy block lets an analysis run
  to completion (the 30 s default cancels every one on a Pi). **Open question:**
  is `MONITOR_LLM_TIMEOUT` per-request or overall (whole analysis)? Time a real
  analysis and tune the value; record the answer here and reconcile the CH08
  prose.
- [ ] **Open question:** do the `MONITORING_*` vars placed inside the
  `deployment.services.open-webui` section actually reach the node? Confirm the
  exchange does *not* strip them (the `*Why?*` claim) — and that a top-level
  custom block *would* be stripped.
- [ ] Shared `/var/log/workloads:/var/log/workloads:rw` bind + `privileged: true`
  on `open-webui` work: the workload writes `app.log` where the monitor can read
  it, and `workloads_monitored` goes `0 → 1` on the next discovery poll.
- [ ] **Open question:** does `docker kill` of `open-webui` actually write an
  `ERROR` / `FATAL` / `Traceback` line to
  `/var/log/workloads/edge-ai-chat/app.log` that trips the pattern match, or does
  something else need to log for the monitor to fire? If nothing logs on a bare
  `kill`, adjust the "break it on purpose" step.
- [ ] A proposal file appears at
  `/var/lib/monitor/proposals/edge-ai-chat/<problem-key>.json` within a poll
  cycle or two.
- [ ] The proposal JSON carries `error_summary`, `root_cause`, `severity`,
  `remediation_steps`, `confidence`, `requires_human_review: true`, and
  `metadata.{timestamp,workload_id,service_name,log_path,line_number,occurrences,
  analysis_duration_ms}`.
- [ ] Recurrence updates the same file in place (`occurrences` climbs,
  `metadata.timestamp` moves) — no new file per hit.
- [ ] Confirm (not repair): CH08's opt-in fragment already carries CH07's
  `"ports": [ { "HostPort": "3000", "HostIP": "0.0.0.0" } ]` entry, so
  republishing the edited service def does not drop the chat UI on `3000`.
- [ ] Record analysis latency on a Pi (the verification fixture is ~136 s).

## CH09 — Autonomous Remediation

- [ ] `remediate.sh` run from a shell against a real CH08 proposal: the
  `IFS=$'\t' read -r sev conf review cause svc` split keeps the multi-word
  `root_cause` sentence whole, and the `case` matches it to the RESTART arm
  (globs `*exited*` / `*OOM*` / `*not running*` / `*crash*`).
- [ ] The gate: `severity` in `{high,critical}` **and** `confidence >= 0.9` via
  `bc -l`; below either → `HOLD` line; matched severity/confidence but unknown
  cause → `SKIP` line.
- [ ] First-run cursor guard: with `/var/log/workloads/remediator/.cursor`
  absent, `touch -t 197001020000` is created and the first `find … -newer` pass
  sees every existing proposal without erroring. The cursor lives on the
  persistent `:rw` mount, not `/tmp`, so it survives a post-remediation restart.
- [ ] **Open question:** does `docker ps -a --filter name=edge-ai-chat -q` find
  the container (so `docker restart` works directly), or is it empty (container
  named `open-webui` / agreement-id prefix) so the
  `|| { hzn unregister -f && hzn register --policy "$NODE_POLICY"; } || true`
  fallback fires? Record which path does the real work on the bench, and confirm
  the CH02 `node.policy.json` is readable at `$NODE_POLICY`
  (default `/var/horizon/node.policy.json`) inside the container.
- [ ] Build-time (not a bench check): the `edge-ai-remediator` image is built to
  bundle `jq`, `bc`, and a container CLI (`docker` or `podman`), per the CH09
  deploy section.
- [ ] The service deploys with the three binds:
  `/var/lib/monitor/proposals:ro`, `/var/log/workloads:rw`,
  `/var/run/docker.sock:rw` (or the Podman socket
  `/run/podman/podman.sock` / rootless `$XDG_RUNTIME_DIR/podman/podman.sock`).
- [ ] Its own deployment policy `"$HZN_ORG_ID/policy-edge-ai-remediator"`
  (constraint `purpose == edge-ai`) places it on the same nodes as `edge-ai-chat`
  and the monitor; `hzn deploycheck all -b …` passes.
- [ ] **End to end:** `docker kill` of `open-webui` → CH08 writes a
  `severity: critical` proposal → `remediate.sh` logs `RESTART edge-ai-chat` in
  `/var/log/workloads/remediator/actions.log` → agent brings the container back →
  `curl -sS http://<pi-ip>:8080/health | jq '.healthy'` → `true`, hands off the
  keyboard (the V10 capstone moment).
- [ ] Record total loop wall-clock: kill → proposal → RESTART → healthy.
