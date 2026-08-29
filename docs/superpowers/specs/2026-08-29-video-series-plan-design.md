# Video Series Plan: DIY Edge Computing (Open Horizon + Local AI)

**Date:** 2026-08-29
**Status:** Approved
**Companion to:** `2026-08-27-book-outline-design.md` (the book outline defers all video-series detail to this spec)

## Goal

Define the companion YouTube series for the book: how many videos, what each
covers, the order they are built in, and a week-by-week creation timeline on a
one-video-per-week publishing cadence. The series is short, humorous, and Gen
Z-oriented; each video dramatizes one chapter's single "aha" moment rather than
summarizing the chapter.

## Locked decisions

These were settled during brainstorming and constrain everything below:

- **Format:** vertical YouTube Shorts, up to ~3 minutes, targeting a 2:30 cut.
- **Sequencing:** parallel shared-prep — the chapter README section and its
  video are built together in one week from a single round of hands-on testing
  on real hardware.
- **Production:** solo creator, part-time (~8 hrs/week).
- **Spec depth:** plan plus a 7-beat sheet per video. No full scripts.
- **Cadence model:** buffer-first (Approach A) — a ~4-week pre-production block
  builds a backlog before any public posting, then publish weekly while
  producing weekly, staying ~3 videos ahead.

---

## Section 1 — Series shape & video list

**Count: 11 videos** — 1 trailer + 10 chapter videos (Introduction + CH01–CH09).
The CH03 video is a **bonus**, mirroring the optional chapter: off the critical
path, slots in or holds to the end without blocking anything.

Each video dramatizes one moment — the "aha" — and nothing else.

| # | Pairs with | The one dramatized moment |
|---|-----------|---------------------------|
| Ep 0 | — (trailer) | "A $75 Pi running a self-healing AI cluster — the whole journey, fast." |
| V1 | Introduction - Getting Ready | Headless Pi boots; you SSH in having never plugged in a screen or keyboard. |
| V2 | CH01 Docker & Podman | The exact same `container run` works on Docker and Podman — swap engines, nothing breaks. |
| V3 | CH02 Open Horizon Fundamentals | One `hzn register` and the Pi appears in a cloud hub dashboard from across the internet. |
| V4 *(bonus)* | CH03 Hosting Your Own Hub | `compose up` and you own a full edge control plane on a NUC. |
| V5 | CH04 Deployment Policies | Plug in a new Pi, walk away, the service auto-deploys — you never named the node. |
| V6 | CH05 Node Policies | Two Pis; the camera service lands only on the one with a camera, automatically. |
| V7 | CH06 Secrets Management | Rotate an API key in the hub; the fleet picks it up, nothing hardcoded, no manual redeploy. |
| V8 | CH07 Deploying Local AI | Ask a local LLM a question with the Wi-Fi switched off. |
| V9 | CH08 Detecting Problems | Kill the AI container on purpose; the dashboard goes red and says exactly what broke. |
| V10 | CH09 Autonomous Remediation | Break it again — the local AI diagnoses and restarts it while you watch, hands off keyboard. |

---

## Section 2 — Build sequence & dependencies

**Core rule: build in chapter order.** Every video's demo runs on the
accumulated bench state of the prior topics, so V_n's demo cannot be recorded
until V_1…V_{n-1} work on real hardware. The sequence is fixed:

```
Ep0 → V1 → V2 → V3 → (V4 bonus) → V5 → V6 → V7 → V8 → V9 → V10
```

### Hard dependencies

- **V8–V10 (the AI capstone) are blocked on verifying `service-edge-ai`** —
  which model/runtime, which secret, resource fit on a Pi. Carried over from the
  book outline's open questions. Must be resolved during pre-production
  (weeks 1–2), because it can invalidate CH06's secret example and the CH07–09
  demos.
- **V7 depends on V3 and V2** — the secret binds to a service deployed via a
  registered node on a container engine.
- **V5–V6 need a second Pi** on the bench; **V6** needs a camera (or similar
  distinguishing peripheral) on exactly one of the two Pis.
- **V4 (bonus) needs a NUC / second host** for the self-hosted hub. Readers who
  skip CH03 stay on the shared hub, so V4 must not leave bench state that later
  videos depend on — record it against a throwaway hub config, then switch back
  to the shared hub.

### Reusable assets — built once, in pre-production

- **The hardware bench:** 2 Pis + camera + (optional) NUC, stood up once and
  grown chapter by chapter, never torn down.
- **Video template:** cold-open sting, lower-thirds, the "→ full walkthrough in
  the book" end card, caption style. Every video inherits it.
- **Recording rig:** standing screen-capture + talking-head setup so recording
  is start/stop, not a re-rig each week.

### Trailer produced last, published first

Ep 0's best footage is clips from V8–V10. Assembling it after the capstone is
shot is far cheaper than staging those shots twice, so in the buffer-first model
the trailer is the final pre-production task before launch. If waiting on the
capstone pushes launch too late, the fallback is a rough trailer cut from V1–V3
plus screen-recorded mockups, re-cut later (see week 11).

---

## Section 3 — Week-by-week timeline

Assumes ~8 hrs/week, buffer-first, staying ~3 videos ahead of the publish line.
"Draft chapter" = the README section validated on real hardware. "Produce
video" = beat sheet → record → edit → captioned, ready to publish.

### Pre-production (Weeks 1–4) — no public posting

| Week | Bench / chapter work | Video work | Gate |
|------|----------------------|------------|------|
| 1 | Stand up bench (2 Pis). Revise CH01 for Docker+Podman neutrality. **Start `service-edge-ai` verification.** | Build video template. Beat sheet V1, V2. | — |
| 2 | Draft CH02 (agent install + register to community-lab hub). **Finish `service-edge-ai` verification** — lock model/runtime/secret. | Record + edit V1, V2. | `service-edge-ai` confirmed, or capstone scope revised |
| 3 | Draft CH03 (self-hosted hub on NUC) + CH04 (deployment policies). | Beat sheet V3, V5. Record + edit V3. | — |
| 4 | Draft CH05 (node policies). Reset bench to shared-hub state after CH03 work. | Record + edit V5. Rough-cut trailer from available footage. | 4 videos in the can (V1, V2, V3, V5) + trailer draft |

### Public season (Weeks 5–14) — one video every week

| Week | Publish | Produce this week | Buffer ahead |
|------|---------|-------------------|--------------|
| 5 | **Ep 0 (trailer) + V1** — launch | Draft CH06. Beat sheet + record V6. | V2, V3, V5, V6 |
| 6 | V2 (CH01) | Beat sheet + record V7. | V3, V5, V6, V7 |
| 7 | V3 (CH02) | Draft CH07. Record V4 (bonus). | V5, V6, V7, (V4) |
| 8 | V4 (CH03 bonus) | Beat sheet + record V8. | V5, V6, V7, V8 |
| 9 | V5 (CH04) | Draft CH08. Record V9. | V6, V7, V8, V9 |
| 10 | V6 (CH05) | Draft CH09. Beat sheet V10. | V7, V8, V9 |
| 11 | V7 (CH06) | Record + edit V10. Optionally re-cut trailer with capstone footage. | V8, V9, V10 |
| 12 | V8 (CH07) | Edit polish / backlog catch-up. | V9, V10 |
| 13 | V9 (CH08) | Backlog catch-up. | V10 |
| 14 | V10 (CH09) — season finale | Retrospective; plan any follow-up. | — |

**Total: 14 calendar weeks; a clean 10-week public run.**

### Critical dates

- `service-edge-ai` model/runtime/secret **locked by end of week 2**.
- Bench reaches CH07 state (LLM running on a Pi) **by week 8** to record V8 on
  schedule.

### Degrade path

If the buffer hits zero (bench failure, lost week), drop to **bi-weekly
publishing** from that point — the season stretches but never goes dark. Do not
claw the buffer back by skipping chapter validation; an unvalidated demo that
fails on camera costs more than a slipped week.

---

## Section 4 — Beat sheets

### Format

Bullets, not prose. The book outline's 7 beats, with a rough time budget for a
**2:30 target** (headroom under the 3:00 Shorts cap):

| # | Beat | Budget | Purpose |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open *inside* the pain. No intro, no "hey guys." |
| 2 | **The fix** | 0:20–0:40 | Name the Open Horizon feature that kills the problem. *(V1–V2 predate OH, so they name the relevant tool instead.)* |
| 3 | **Punchline** | 0:40–0:50 | One joke on the turn. Gen Z register, dry. |
| 4 | **Demo** | 0:50–2:00 | The real thing on real hardware — the "aha" moment from Section 1, nothing else. ~70s. |
| 5 | **Hook** | 2:00–2:12 | The unanswered problem the next video solves. |
| 6 | **Call to action** | 2:12–2:22 | Subscribe / like, framed as "follow the build." |
| 7 | **Book pointer** | 2:22–2:30 | End card: "full walkthrough → [chapter]." |

The **trailer (Ep 0)** runs to a shorter ~0:50 budget and uses a compressed
version of the structure (problem → what the series is → punchline → montage →
hook → CTA → book pointer).

---

### Ep 0 — Trailer

1. **Problem:** You want to run AI at the edge. Every tutorial assumes a data center.
2. **What this is:** A Raspberry Pi, Open Horizon, and a local LLM that fixes itself — built step by step.
3. **Punchline:** "No cloud bill. No PhD. One Pi."
4. **Montage:** headless boot → node appears in the hub dashboard → service auto-deploys → LLM answers offline → container dies red → the AI restarts it.
5. **Hook:** "Ten videos. One build. Starts now."
6. **CTA:** "Subscribe so you don't miss episode one."
7. **Book pointer:** "Every step is written up in *DIY Edge Computing* — link in the description."

### V1 — Introduction - Getting Ready

1. **Problem:** You bought a Pi. Now you need a spare monitor, a USB keyboard, and the HDMI cable you definitely own. Montage: digging through the cable drawer.
2. **The fix:** Raspberry Pi Imager's pre-configure — bake SSH + Wi-Fi credentials onto the SD card before first boot.
3. **Punchline:** "The monitor stays in the closet. Where it belongs."
4. **Demo:** Flash SD with SSH+Wi-Fi preset → boot the Pi with *only* a power cable → `ssh pi@raspberrypi.local` from the laptop → shell prompt appears. No screen was ever connected.
5. **Hook:** "It's alive — but it can't run anything yet. Next: we give it an engine."
6. **CTA:** "Episode 1 of building a self-healing edge AI box. Subscribe or miss the rest."
7. **Book pointer:** "OS options and troubleshooting → the Introduction chapter."

### V2 — CH01 Docker & Podman

1. **Problem:** You followed a tutorial. It says `docker`. Your distro shipped Podman. Now every command is a coin flip.
2. **The fix:** Both engines speak the same CLI and run the same OCI images — write the command once, run it on either.
3. **Punchline:** "Two engines, one muscle memory."
4. **Demo:** `docker run` a container → run the identical command as `podman run` → byte-identical output, same image, no rebuild.
5. **Hook:** "One container engine is great. Fifty Pis running it by hand is not. Next: something has to manage the fleet."
6. **CTA:** "Follow the build."
7. **Book pointer:** "Install both, when to pick which → CH01."

### V3 — CH02 Open Horizon Fundamentals

1. **Problem:** You've got a Pi with a container engine. Now multiply by 40, across 5 buildings. SSH into each one? Forever?
2. **The fix:** Install the Open Horizon agent, then `hzn register` against a management hub (the LF Edge Community Lab's free hub) — the node phones home.
3. **Punchline:** "Forty Pis. One command. Zero road trips."
4. **Demo:** agent install script → `hzn register` with hub credentials + a node policy → refresh the hub web UI → the node shows up online, from across the internet.
5. **Hook:** "The hub can see the node — but it's not running anything useful yet. Next: tell it what to deploy, without naming names."
6. **CTA:** "Follow the build."
7. **Book pointer:** "Agent install, hub credentials, exchange URL → CH02."

### V4 — CH03 Hosting Your Own Hub *(bonus)*

1. **Problem:** You love the free community hub. Legal does not. "Where does the data actually live?"
2. **The fix:** The whole Open Horizon control plane — exchange, agbot, CSS — is containers. `compose up` on a NUC.
3. **Punchline:** "Built my own cloud. It's in the closet. Next to the monitor."
4. **Demo:** clone the deploy repo → bring the stack up on a NUC → `hzn exchange version` against `localhost` → register a Pi to *your* hub → the node appears in your own dashboard.
5. **Hook:** "Your hub, your rules — and everything from here works the same whether it's yours or the community's. Next: deployment policies."
6. **CTA:** "Follow the build."
7. **Book pointer:** "Sizing, TLS, backups → CH03. Optional — skip it and stay on the shared hub."

### V5 — CH04 Deployment Policies

1. **Problem:** A new Pi joins the fleet. You SSH in, copy the service definition, start it. Then the next Pi. And the next.
2. **The fix:** A deployment policy describes *what runs where* by properties, not hostnames. Matching nodes pull it automatically.
3. **Punchline:** "I don't deploy to nodes anymore. They deploy to themselves."
4. **Demo:** publish a deployment policy (constraint: `purpose == edge-ai`) → plug in a fresh Pi, register it with that property → walk away → return, `hzn agreement list` shows the service running. The node was never named.
5. **Hook:** "It deploys everywhere that matches. But some services only belong on some hardware. Next: the node gets a say."
6. **CTA:** "Follow the build."
7. **Book pointer:** "Writing and publishing deployment policies → CH04."

### V6 — CH05 Node Policies

1. **Problem:** Your image classifier landed on the Pi with no camera. It's just sitting there, throwing errors.
2. **The fix:** A node policy — the node advertises its own properties (`camera == true`, arch, RAM). Services whose constraints match land; others don't.
3. **Punchline:** "The Pi finally knows what it is."
4. **Demo:** two Pis registered, one with `camera=true` → publish a camera service constrained to `camera == true` → an agreement forms only on the camera Pi; the other stays clean.
5. **Hook:** "Right service, right box. But it's using an API key you hardcoded. Next: fix that before anyone reads the repo."
6. **CTA:** "Follow the build."
7. **Book pointer:** "Node properties and constraints → CH05."

### V7 — CH06 Secrets Management

1. **Problem:** Your API key is in the service definition. Which is in git. Which is public. *(record scratch)*
2. **The fix:** Open Horizon's secrets manager — store the key in the hub vault, bind it to the service at deploy time. Never in the image, never in git.
3. **Punchline:** "Rotated my key. Told nobody. Everything kept working."
4. **Demo:** add a secret to the secrets manager → reference it from the service → deploy → exec into the container, the key is present → rotate the secret in the hub → the container picks up the new value, no rebuild, no manual redeploy.
5. **Hook:** "Secrets sorted. Now the payoff: an actual AI model running on this thing. Next."
6. **CTA:** "Follow the build."
7. **Book pointer:** "Storing and binding secrets → CH06."

### V8 — CH07 Deploying Local AI

1. **Problem:** Every AI demo is "and now we call the API…" — your data leaves the building, you pay per token, and no Wi-Fi means no AI.
2. **The fix:** Open Horizon pushes an LLM inference service (the `service-edge-ai` pattern) straight onto the Pi, pulling its access token from the secret set up in V7.
3. **Punchline:** "OpenAI called. I sent it to voicemail."
4. **Demo:** `hzn agreement list` shows the AI service running on the Pi → open the chat UI → on camera, unplug the router → ask it a question → it answers. Offline.
5. **Hook:** "But what happens when it crashes at 3 a.m.? Next: teaching it to notice."
6. **CTA:** "Follow the build."
7. **Book pointer:** "Model choice, runtime, and resource limits → CH07."

> Beat 2 is provisional pending `service-edge-ai` verification (see Open
> Questions). If the real repo uses a different secret or a runtime that does
> not fit a Pi, this beat sheet and CH06's example both need revising.

### V9 — CH08 Detecting Problems

1. **Problem:** The AI worked yesterday. A user says it's down. You have vibes. No dashboard, no logs, no idea.
2. **The fix:** Open Horizon surfaces node and agreement health; add a health check to the service so failure states are visible, not guessed.
3. **Punchline:** "It broke, and for once it admitted it."
4. **Demo:** AI service green → `docker kill` the container on the Pi → the hub UI / `hzn eventlog list` flips to red with the reason → the health endpoint reports unhealthy.
5. **Hook:** "Now you can *see* it break. Final episode: what if it fixed itself?"
6. **CTA:** "Follow the build."
7. **Book pointer:** "Monitoring and failure states → CH08."

### V10 — CH09 Autonomous Remediation *(capstone)*

1. **Problem:** It's 3 a.m. The inference container OOM-crashed. You are asleep. The fleet is down.
2. **The fix:** A remediation loop — the local AI reads the failure signal from CH08, decides the fix, and acts (restart / roll back / re-request agreement) with no human in the loop.
3. **Punchline:** "I automated my own on-call. I'm basically retired."
4. **Demo:** everything green → break the workload (kill / bad config) → detection fires (CH08) → the local AI diagnoses from the event log → it issues the fix → the service returns to green. Hands visibly off the keyboard throughout.
5. **Hook:** "That's the build: a Pi that runs AI and heals itself. Where should it go next? Comment."
6. **CTA:** "Subscribe for the next series. Full book in the description."
7. **Book pointer:** "The complete remediation logic → CH09."

---

## Risks & open questions

- **`service-edge-ai` unverified.** Same open question as the book outline. The
  V8–V10 beat sheets and CH06's secret example assume a token-authenticated
  model pull and a runtime that fits a Pi. Must be confirmed against the repo by
  end of week 2; if wrong, revise CH06–CH09 content and V7–V10 beat sheets
  before recording.
- **Part-time throughput is tight.** ~8 hrs/week is the estimated per-topic
  cost of parallel shared-prep. The buffer-first model and the bi-weekly
  degrade path exist because a single bad week otherwise breaks the streak.
- **Capstone bench time.** V8–V10 need the most hands-on time (LLM on a Pi,
  induced failures, a working remediation loop) and land in weeks 8–11 when the
  buffer is thinnest. Front-load any capstone experimentation into
  pre-production if week 2 verification finishes early.
- **Trailer timing.** Launch (week 5) wants capstone footage in the trailer,
  but the capstone is not shot until week 8. Launch with the rough trailer cut
  from V1–V3; the week-11 re-cut with real capstone footage is optional polish,
  not a blocker.
- **Chapter numbering is provisional** (inherited from the book outline). If
  chapters split or merge once content volume is known, the video list moves
  with them 1:1 — the "one chapter, one short" rule holds.
- **Platform specifics deferred:** channel branding, thumbnail style, exact
  publish day/time, and whether any video also gets a long-form cut are left to
  execution, not this plan.
