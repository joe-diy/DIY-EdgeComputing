# V9 — CH08 Detecting Problems

**Date:** 2026-08-29
**Pairs with:** `CH08 - Detecting Problems` (*Chapter Eight - Detecting Problems*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V9*

**Dramatized moment:** Kill the AI container on purpose; the dashboard goes red and says exactly what broke.

> **Revised per the 2026-08-29 addendum to the video-series spec.** The original
> beat 2 had the fix be "add a health check to the service so failure states are
> visible." Verification of `service-edge-ai` (see
> [`00-verification-service-edge-ai.md`](00-verification-service-edge-ai.md))
> established that the repo is a **log-watching workload monitor** that writes an
> **advisory JSON proposal** — `error_summary`, `root_cause`, `severity`,
> `confidence`, `remediation_steps`, `requires_human_review: true` — to
> `/var/lib/monitor/proposals/<workload>/<key>.json`, using the **local Ollama**
> runtime from V8 for the analysis. Beats 2 and 4 below name that instead. Same
> punchline, same "kill it on camera" demo; the "red" is now a proposal file with
> a root-cause line, not a health-check dashboard.

Open Horizon has been on the bench since V3. Beat 2 names an OH feature — the
agent's own event log — and then the `service-edge-ai` monitor layered on top,
reusing the same `policy-edge-ai` placement from V5 and the same Ollama runtime
from V8. Everything else inherits [`00-template.md`](00-template.md) unchanged:
vertical 1080×1920, 2:30 target, cold-open sting, burned-in captions, fixed end
card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on a phone: a message that reads *"is the AI down??"*. Cut to a terminal with nothing useful on it. On-screen line within 2 s: *"it worked yesterday. a user says it's down. you have vibes — no dashboard, no logs, no idea."* Sting on the cut from phone to blank terminal. |
| 2 | **The fix** | 0:20–0:40 | Face enters. `hzn eventlog list` already records *that* a workload broke. On top of it, `service-edge-ai` — placed by the same `policy-edge-ai` from V5 — tails the broken workload's log, sends the error to the **local** Ollama from V8, and writes a structured proposal file: summary, root cause, severity, confidence. The failure becomes a file you can read, offline. |
| 3 | **Punchline** | 0:40–0:50 | "It broke, and for once it admitted it." Clear the lower-thirds for the line; hold on a card — a red log line resolving into a tidy JSON block. |
| 4 | **Demo** | 0:50–2:00 | `laptop`: dashboard / `hzn agreement list` shows `edge-ai-chat` green on `pi-1`. Cut to `pi-1`, **on camera**: `docker kill $(docker ps --filter name=open-webui -q)` (or `podman kill …`). Cut to `laptop`: `hzn eventlog list \| tail -n 20` flips red with the exec error. Then the wait — `watch -n 5 'ls -t /var/lib/monitor/proposals/edge-ai-chat/'` until a file appears. `cat` it through `jq`; box `root_cause` and `severity`. **The analysis wait is real** (minutes on a Pi) — cut straight to the proposal and timestamp-overlay the gap. Caption overlay: "it broke, and it wrote it down." Still: `V09-shot-5.png`. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "Now you can *see* it break. Final episode: what if it fixed itself?" |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): monitoring and failure states → CH08. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Phone message *"is the AI down??"*, then cut to a blank terminal | Beat 1. On-screen problem line burned in. No machine label — a phone, then a shell. |
| 2 | Talking head | Beat 2. Face enters on the fix, not before. |
| 3 | Motion-graphic card: `hzn eventlog` red line → arrow into the local Ollama box (from V8) → a JSON proposal card sliding out | Beat 2. Sells "event log says *that*; the monitor says *what*." No machine labels. |
| 4 | Motion-graphic card: a jagged red log line resolving into a clean JSON block | Beat 3. Punchline. No machine labels. |
| 5 | `laptop`: dashboard or `hzn agreement list \| jq '.[].workload_to_run.url'` → `edge-ai-chat` green | Machine label `laptop`. Box the `edge-ai-chat` line green. |
| 6 | `pi-1`, on camera: `docker kill $(docker ps --filter name=open-webui -q)` — show the `podman kill` variant as a lower-third alt | Beat 4. The kill has to read as deliberate and real — hand on the keyboard, container gone. Machine label `pi-1`. |
| 7 | `laptop`: `hzn eventlog list \| tail -n 20` — the exec/agreement error at the bottom, boxed red | Machine label `laptop`. Command as typed before output. |
| 8 | `pi-1`: `watch -n 5 'ls -t /var/lib/monitor/proposals/edge-ai-chat/'` — empty, then a filename appears | Beat 4. This is where the real wait lives; timestamp-overlay the gap, do not fake it. |
| 9 | `pi-1`: `cat /var/lib/monitor/proposals/edge-ai-chat/*.json \| jq '{error_summary, root_cause, severity, confidence, requires_human_review}'` | Beat 4. Box `root_cause` and `severity`. Caption overlay: "it broke, and it wrote it down." Still: `V09-shot-5.png`. |

---

## Latency is real — do not fake it

Analysis on a Pi takes **minutes, not seconds** (~136 s per error in the shipped
`service-edge-ai` fixture; expect longer with the chat model also resident). The
monitor also only polls every 60 s, so the proposal can be two or three minutes
behind the `docker kill`. **Do not** splice in a pre-baked proposal or a faster
machine — the whole point is that *this* Pi, offline, wrote *that* file. Record
the wait end to end, then in the edit cut from the kill straight to the proposal
with a **timestamp overlay** marking the elapsed gap (e.g. `03:14:02 killed` →
`03:16:24 proposal written`). If the wait overruns the beat budget, use
`llama3.2:1b` for `MONITOR_LLM_MODEL` on the take and say so in the caption.

---

## Recording state

The V8 bench carried forward — `pi-1` (a **Pi 4/5 with 8 GB RAM**) registered
against the **LF Edge Community Lab** shared hub with the four `HZN_*` variables,
`edge-ai-chat` v1.0.0 (`arch` `arm64`) running the `ollama` + `open-webui`
containers, and the `laptop` holding the CH04–CH05 deployment policy. For V9,
add `service-edge-ai`: cloned on `pi-1`, `MONITOR_LLM_HOST` pointed at the
existing Ollama on `http://<pi-ip>:11434`, published and registered via
`make deploy-check` then `make publish`, with `/var/log/workloads` created as the
shared mount. The `edge-ai-chat` `service.definition.json` is edited to add
`MONITORING_ENABLED=true`, `MONITORING_LOG_PATHS=/var/log/workloads/edge-ai-chat/app.log`,
`MONITORING_ERROR_PATTERNS=ERROR,FATAL,Traceback`, the `/var/log/workloads` bind
and `privileged: true` to its `open-webui` block, and re-published — so
`workloads_monitored` on `http://<pi-ip>:8080/health` reads `1` before recording.
The chat model is pre-pulled. `<pi-ip>` is a private-range address, redacted or
off-screen in every shot; org / `HZN_*` values redacted.

---

## Asset checklist

- [ ] Phone plate for the cold-open message *"is the AI down??"* (shot 1).
- [ ] `laptop` terminal screen-capture — shots 5, 7; org / `HZN_*` values redacted or off-screen.
- [ ] `pi-1` on-camera plate for the `docker kill` (shot 6) — the kill has to read as deliberate; `podman kill` variant as a lower-third alt.
- [ ] `pi-1` terminal screen-capture — shots 8, 9; `<pi-ip>` redacted.
- [ ] Proposal-wait capture, full length (shot 8) — the source for the timestamp-overlay gap; no pre-baked proposal, no faster machine.
- [ ] `V09-shot-5.png` pulled from shot 9 — the proposal JSON with `root_cause` and `severity` boxed.
- [ ] Cold-open on-screen problem line: "it worked yesterday. a user says it's down. you have vibes — no dashboard, no logs, no idea."
- [ ] Lower-third command cards for shots 5, 6, 7, 9 (monospace, high contrast); the `podman kill` alt for shot 6.
- [ ] Timestamp-overlay plate for the analysis gap (e.g. `killed` → `proposal written`).
- [ ] Caption overlay: "it broke, and it wrote it down." (shot 9).
- [ ] Motion-graphic cards — `hzn eventlog` red line into the Ollama box into a JSON proposal (beat 2); jagged red log line resolving into clean JSON (beat 3).
- [ ] Sting cued to the phone-to-terminal cut in the cold open (shot 1).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
It broke, and for once it admitted it.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH08
https://github.com/joe-diy/DIY-EdgeComputing
```
