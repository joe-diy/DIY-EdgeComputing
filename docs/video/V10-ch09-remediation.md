# V10 — CH09 Autonomous Remediation *(capstone / season finale)*

**Date:** 2026-08-29
**Pairs with:** `CH09 - Autonomous Remediation` (*Chapter Nine - Autonomous Remediation*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V10*

**Dramatized moment:** Break it again — the executor diagnoses and restarts it while you watch, hands off the keyboard.

> **Honest-framing note (carries the 2026-08-29 addendum forward).** The spec's
> V10 beat 2 reads "the local AI … decides the fix and acts … with no human in
> the loop." Verification of `service-edge-ai` (see
> [`00-verification-service-edge-ai.md`](00-verification-service-edge-ai.md))
> established it is **advisory only** — every proposal carries
> `requires_human_review: true` and the monitor never touches a workload. The
> autonomous layer is therefore a **reader-built executor** (`remediate.sh`, in
> CH09) that reads the proposal, gates hard on `severity` + `confidence` +
> a known reversible `root_cause`, and only then runs one `docker restart`.
> On camera that is the same punchline — "it fixed itself" — but the demo shows
> a **gate** and an **append-only `actions.log`**, not a model with `sudo`. Say
> "a small script the model's advice triggers," not "the AI decided."

This is the final episode. Open Horizon has been on the bench since V3; the chat
LLM since V8; the `service-edge-ai` monitor since V9. V10 adds the last piece —
the executor service `edge-ai-remediator`, placed by the same `policy-edge-ai`
constraint from V5. Everything else inherits [`00-template.md`](00-template.md)
unchanged: vertical 1080×1920, 2:30 target, cold-open sting, burned-in captions,
fixed end card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open in the dark: a clock reads **3:04 AM**, a phone lights up face-down on a nightstand, buzzing. On-screen line within 2 s: *"3 a.m. the inference container OOM-crashed. you're asleep. the fleet is down."* Sting on the phone lighting up. No face yet. |
| 2 | **The fix** | 0:20–0:40 | Face enters. CH08's monitor already writes the failure to disk — severity, confidence, root cause. V10 adds `edge-ai-remediator`: a ~40-line script, placed by the same `policy-edge-ai` from V5, that reads that proposal and — *only* when severity is high/critical, confidence ≥ 0.9, and the cause is a reversible one (exited / OOM / crash) — runs one `docker restart`. Everything else it logs and leaves. Show the three-line gate on screen. |
| 3 | **Punchline** | 0:40–0:50 | "I automated my own on-call. I'm basically retired." Clear the lower-thirds; hold on a card — a pager notification crossed out, replaced by a single tidy `actions.log` line. |
| 4 | **Demo** | 0:50–2:00 | `laptop`: `hzn agreement list \| jq 'length'` — everything green. Cut to `pi-1`, **on camera**: `docker kill $(docker ps --filter name=open-webui -q)` (`podman kill …` as a lower-third alt). **Hands then visibly lift off the keyboard and stay in frame, empty.** Cut to `tail -f /var/log/workloads/remediator/actions.log`. The analysis wait is real (minutes on a Pi) — B-roll the "asleep at 3 a.m." frame over it, timestamp-overlay the gap (`03:04 killed` → `03:07 RESTART`). A `RESTART edge-ai-chat` line prints. `curl -sS http://<pi-ip>:8080/health \| jq '.healthy'` → `true`. Caption overlay: "I automated my own on-call." Still: `V10-shot-6.png`. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "That's the build: a Pi that runs AI and heals itself. Where should it go next? Comment." |
| 6 | **Call to action** | 2:12–2:22 | "Subscribe for the next series. Full book in the description." Framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): the complete remediation logic → CH09. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Nightstand in the dark: clock at **3:04 AM**, phone face-down and buzzing, then lighting up | Beat 1. On-screen problem line burned in. No machine label — a bedroom, not a bench. Sting on the phone light. |
| 2 | Talking head | Beat 2. Face enters on the fix, not before. |
| 3 | Motion-graphic card: CH08 proposal JSON → arrow into a small `remediate.sh` box showing the 3-line gate (`severity ∈ {high,critical}` · `confidence ≥ 0.9` · `root_cause` reversible) → arrow out to `docker restart` | Beat 2. Sells "advice in, one safe lever out." No machine labels. |
| 4 | Motion-graphic card: a pager / PagerDuty-style alert struck through, replaced by one clean `actions.log` line `… RESTART edge-ai-chat …` | Beat 3. Punchline. No machine labels. |
| 5 | `laptop`: `hzn agreement list \| jq 'length'` → a number, all green | Machine label `laptop`. Command as typed before output. |
| 6 | `pi-1`, on camera: `docker kill $(docker ps --filter name=open-webui -q)`, then **hands lift off the keyboard and rest in frame, empty**, for a beat | Beat 4. The hands-off is the whole point — hold it long enough to read as deliberate. `podman kill` variant as a lower-third alt. Machine label `pi-1`. |
| 7 | `pi-1`: `tail -f /var/log/workloads/remediator/actions.log` — empty, the wait, then a `RESTART edge-ai-chat (conf=0.9x) :: … exited …` line appears | Beat 4. This is where the real wait lives; timestamp-overlay the gap, do not fake it. B-roll the "asleep at 3 a.m." frame over the wait. |
| 8 | `pi-1` or `laptop`: `curl -sS http://<pi-ip>:8080/health \| jq '.healthy'` → `true` | Beat 4. Health flips back. `<pi-ip>` redacted. Caption overlay: "I automated my own on-call." Still: `V10-shot-6.png`. |
| 9 | Optional: `actions.log` scrolled back to show a `HOLD` line from an earlier low-confidence proposal | Beat 4 tail / beat 5. Reinforces "the unsure cases still wait for you." Machine label `pi-1`. |

---

## Latency is real — do not fake it

Analysis on a Pi takes **minutes, not seconds** (~136 s per error in the shipped
`service-edge-ai` fixture; longer with the chat model also resident), the
monitor polls only every 60 s, and `remediate.sh` then runs on its own
`REMEDIATE_INTERVAL` (120 s default). Worst case the `RESTART` line is four or
five minutes behind the `docker kill`. **Do not** splice in a pre-baked
`actions.log` or a faster machine — the point of the finale is that *this* Pi,
unattended, wrote *that* line. Record the wait end to end, then in the edit cut
from the hands-off shot to the `RESTART` line with a **timestamp overlay**
marking the gap (e.g. `03:04:11 killed` → `03:08:39 RESTART`), and lay the
"asleep at 3 a.m." B-roll over it. If the wait overruns the beat budget, use
`llama3.2:1b` for `MONITOR_LLM_MODEL` on the take and say so in the caption.

---

## Recording state

The V9 bench carried forward — `pi-1` (a **Pi 4/5 with 8 GB RAM**) registered
against the **LF Edge Community Lab** shared hub, `edge-ai-chat` v1.0.0
(`arm64`) running `ollama` + `open-webui`, `service-edge-ai` cloned and
published with `MONITOR_LLM_HOST` pointed at the existing Ollama, the
`edge-ai-chat` definition already opted in to monitoring
(`workloads_monitored` reads `1` on `http://<pi-ip>:8080/health`), and the
`laptop` holding the CH04–CH05 deployment policy. For V10, add
`edge-ai-remediator`: the `remediate.sh` container image built and published
with `hzn exchange service publish -f remediator.service.json`, a sibling
deployment policy `policy-edge-ai-remediator` (same `purpose == edge-ai`
constraint as V5) added with `hzn exchange deployment addpolicy`, and the
agreement formed on `pi-1` so the executor is polling before recording. Confirm
the three binds are live: `/var/lib/monitor/proposals:ro`,
`/var/log/workloads:rw`, and `/var/run/docker.sock` (Podman socket on a Podman
host). Pre-seed one older low-confidence proposal so a `HOLD` line already sits
in `actions.log` for shot 9. `<pi-ip>` is a private-range address, redacted or
off-screen in every shot; org / `HZN_*` values redacted.

---

## Asset checklist

- [ ] Nightstand plate for the cold open — clock at 3:04 AM, phone buzzing then lighting up (shot 1).
- [ ] Cold-open on-screen problem line: "3 a.m. the inference container OOM-crashed. you're asleep. the fleet is down."
- [ ] `laptop` terminal screen-capture — shot 5; org / `HZN_*` values redacted or off-screen.
- [ ] `pi-1` on-camera plate for the `docker kill` **and the hands lifting off the keyboard** (shot 6) — the hands-off has to read as deliberate and hold; `podman kill` variant as a lower-third alt.
- [ ] `pi-1` terminal screen-capture — shots 7, 8, 9; `<pi-ip>` redacted.
- [ ] Remediation-wait capture, full length (shot 7) — the source for the timestamp-overlay gap; no pre-baked `actions.log`, no faster machine.
- [ ] "Asleep at 3 a.m." B-roll to lay over the analysis wait (shot 7).
- [ ] `V10-shot-6.png` pulled from shot 8 — `.healthy` → `true` with the `RESTART` line still visible above.
- [ ] Timestamp-overlay plate for the analysis gap (e.g. `killed` → `RESTART`).
- [ ] Caption overlay: "I automated my own on-call." (shot 8).
- [ ] Lower-third command cards for shots 5, 6, 7, 8 (monospace, high contrast); the `podman kill` alt for shot 6.
- [ ] Motion-graphic cards — CH08 proposal JSON into the `remediate.sh` gate box into `docker restart` (beat 2); struck-through pager alert into one clean `actions.log` line (beat 3).
- [ ] Sting cued to the phone lighting up in the cold open (shot 1).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
I automated my own on-call. I'm basically retired.
```

**Demo caption (beat 4, over shot 8):**

```
I automated my own on-call.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH09
https://github.com/joe-diy/DIY-EdgeComputing
```
