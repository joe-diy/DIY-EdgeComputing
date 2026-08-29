# V8 — CH07 Deploying Local AI

**Date:** 2026-08-29
**Pairs with:** `CH07 - Deploying Local AI` (*Chapter Seven - Deploying Local AI*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V8*

**Dramatized moment:** Ask a local LLM a question with the internet unplugged — and it answers.

> **Revised per the 2026-08-29 addendum to the video-series spec.** The original
> beat 2 had Open Horizon push an inference service that *pulled its access token
> from the secret set up in V7*. Verification of `service-edge-ai` (see
> [`00-verification-service-edge-ai.md`](00-verification-service-edge-ai.md))
> established that a local chat stack needs **no secret and no API key** at all:
> CH07 deploys **Ollama + Open WebUI** as one Horizon service, and the model is
> auto-pulled on first run. Beat 2 below is rewritten to match. `service-edge-ai`
> itself is the CH08–CH09 monitoring capstone, not this episode. Same punchline,
> same offline demo; only the mechanism named in beat 2 changed.

Open Horizon has been on the bench since V3, so beat 2 names an OH feature — one
service carrying two containers, placed by the same deployment policy from V5 —
rather than a standalone tool. Everything else inherits
[`00-template.md`](00-template.md) unchanged: vertical 1080×1920, 2:30 target,
cold-open sting, burned-in captions, fixed end card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on a chat app mid-answer, then the connection drops and the reply just stops. On-screen line within 2 s: *"every AI demo is 'and now we call the API'. your data leaves the building, you pay per token, and no Wi-Fi means no AI."* Sting on the dropped connection. |
| 2 | **The fix** | 0:20–0:40 | Face enters. One Open Horizon service carries **two containers** — **Ollama** (the model runtime) and **Open WebUI** (the chat front-end). The same `policy-edge-ai` from V5 places it on the Pi; the model is **auto-pulled on first run**. No API key, no secret, nothing to call. The weights land on the Pi and stay there. |
| 3 | **Punchline** | 0:40–0:50 | "OpenAI called. I sent it to voicemail." Clear the lower-thirds for the line; hold on a card — a phone icon going to voicemail, a Pi lighting up. |
| 4 | **Demo** | 0:50–2:00 | On the `laptop`: `hzn agreement list \| jq '.[].workload_to_run.url'` → `edge-ai-chat` running on `pi-1`. Cut to the browser: `open http://<pi-ip>:3000`, the Open WebUI chat, model already pulled. Sanity-check on the `laptop`: `curl -s http://<pi-ip>:11434/api/generate -d '{"model":"llama3.2:3b","prompt":"one-sentence hello","stream":false}' \| jq -r .response` prints a line of text. Then, **on camera**, reach over and unplug the router's WAN cable (Pi and laptop stay on the same switch, so the browser still reaches `:3000`). Type a fresh question into the UI. Hold on the "thinking" state, then the answer fills in. Caption overlay: "still local. still answering." Still: `V08-shot-6.png`. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "But what happens when it crashes at 3 a.m. and nobody's watching? Next: teaching it to notice." |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): model choice, runtime, and resource limits → CH07. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Chat app answering, then the reply freezes as the connection drops | Beat 1. On-screen problem line burned in. No machine label — an app, not a shell. |
| 2 | Talking head | Beat 2. Face enters on the fix, not before. |
| 3 | Motion-graphic card: two containers snapping into one service box, then the box landing on a Pi; model-download bar fills | Beat 2. Sells "one service, two containers, model auto-pulled." No machine labels. |
| 4 | Motion-graphic card: a phone going to voicemail, a Pi lighting up | Beat 3. Punchline. No machine labels. |
| 5 | `laptop`: `hzn agreement list \| jq '.[].workload_to_run.url'` → `edge-ai-chat` | Machine label `laptop`. Command as typed before output. Box the `edge-ai-chat` line green. |
| 6 | Browser: `http://<pi-ip>:3000` Open WebUI chat, model selected | Beat 4. `<pi-ip>` redacted or a private-range address. |
| 7 | `laptop`: `curl -s http://<pi-ip>:11434/api/generate -d '{…"model":"llama3.2:3b"…}' \| jq -r .response` | Machine label `laptop`. One line of generated text in the output. |
| 8 | Router WAN cable unplugged **on camera** | Beat 4. The disconnect has to be visibly real — hand on the cable. Leave the Pi and laptop on the same switch so the browser still reaches `:3000`. No machine label — it's the router, not a shell. |
| 9 | Browser: new question typed into the UI, "thinking" state, then the answer fills in | Beat 4. Network is down for this whole shot. Caption overlay: "still local. still answering." Still: `V08-shot-6.png`. |

---

## Latency is real — do not fake it

A 3B model on a Pi answers in seconds-to-minutes, not instantly. **Record the real
answer end to end**, then speed-ramp the wait in the edit — a fast-forward on the
"thinking" state with the timer visible, landing at real speed as the text
resolves. Never cut to a pre-baked response or splice in a faster machine: the
whole point of the shot is that *this* Pi, offline, produced *that* answer. If the
wait is long enough to hurt the beat budget, use `llama3.2:1b` for the take and
say so in the caption.

---

## Recording state

The V7 bench carried forward — `pi-1` registered against the **LF Edge Community
Lab** shared hub with the four `HZN_*` variables, and the `laptop` holding the
deployment policy from CH04–CH05. For V8 the sample service is replaced by
`edge-ai-chat` v1.0.0 (`arch` `arm64`): the CH07 service definition with the
`ollama` + `open-webui` containers, and the CH04 `deployment.policy.json` with its
`service` block re-pointed at `edge-ai-chat` and re-published as
`$HZN_ORG_ID/policy-edge-ai`. `pi-1` is a **Pi 4/5 with 8 GB RAM**; the model is
pulled and cached **before** recording so the demo shows inference latency, not a
first-run download. The router used for the on-camera unplug is on its own
segment so pulling it does not kill the recording rig. `<pi-ip>` is a private-range
address, redacted or off-screen in every shot.

---

## Asset checklist

- [ ] `laptop` terminal screen-capture — shots 5, 7; org / `HZN_*` values redacted or off-screen.
- [ ] Browser capture of Open WebUI — shots 6, 9; `<pi-ip>` redacted, no real account email visible.
- [ ] On-camera plate for the network disconnect (shot 8) — hand on the router's WAN cable; the cut has to read as genuinely offline.
- [ ] Offline answer capture, full length (shot 9) — the source for the speed-ramp; `V08-shot-6.png` pulled from it.
- [ ] Speed-ramp / timer plate for the inference wait — no pre-baked responses, no faster machine.
- [ ] Cold-open on-screen problem line: "every AI demo is 'and now we call the API'. your data leaves the building, you pay per token, and no Wi-Fi means no AI."
- [ ] Lower-third command cards for shots 5, 7, 8 (monospace, high contrast).
- [ ] Caption overlay: "still local. still answering." (shot 9).
- [ ] Motion-graphic cards — two containers into one service box onto a Pi with a download bar (beat 2); phone-to-voicemail + Pi lighting up (beat 3).
- [ ] Sting cued to the dropped connection in the cold open (shot 1).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
OpenAI called. I sent it to voicemail.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH07
https://github.com/joe-diy/DIY-EdgeComputing
```
