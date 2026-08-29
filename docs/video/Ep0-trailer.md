# Ep 0 — Trailer

**Date:** 2026-08-29
**Pairs with:** — (series trailer; **produced last, published first**)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *Ep 0*

**Dramatized moment:** A $75 Pi running a self-healing AI cluster — the whole journey, fast.

The trailer runs to a compressed **~0:50** budget (per [`00-template.md`](00-template.md)),
not the 2:30 episode clock, and uses a shortened version of the 7-beat
structure: problem → what the series is → punchline → montage → hook → CTA →
book pointer. It is **produced last and published first** — its montage is cut
from the finished V1 / V3 / V5 and V8–V10 episode footage, so it is assembled
after the capstone is shot and then opens the season. Asset prefix is `V00` per
the template's asset-naming rule. Everything else inherits
[`00-template.md`](00-template.md) unchanged: vertical 1080×1920, cold-open
sting, burned-in captions.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Problem** | 0:00–0:08 | Cold open inside the pain. On-screen line within 2 s: *"you want to run AI at the edge. every tutorial assumes a data center."* Stock-style server racks, then a hard cut to one small Pi on a desk. Sting on the cut. No "hey guys." |
| 2 | **What this is** | 0:08–0:16 | Fast: a Raspberry Pi, Open Horizon, and a local LLM that fixes itself — built step by step. Quick flashes of the bench (two Pis, a camera, a NUC). |
| 3 | **Punchline** | 0:16–0:22 | "No cloud bill. No PhD. One Pi." Lower-thirds cleared; hold the line over the single Pi. |
| 4 | **Montage** | 0:22–0:40 | Six ~3 s cuts: headless boot and a shell prompt appears → node appears in the hub dashboard → service auto-deploys onto a Pi nobody named → LLM answers offline with the Wi-Fi unplugged → container dies red and the monitor writes it up → the AI restarts it and health goes back to green. Sources in the table below. |
| 5 | **Hook** | 0:40–0:45 | "Ten videos. One build. Starts now." |
| 6 | **CTA** | 0:45–0:48 | "Subscribe so you don't miss episode one." Framed as following the build, per template. |
| 7 | **Book pointer** | 0:48–0:50 | End card (fixed, compressed): every step is written up in *DIY Edge Computing* — link in the description. |

---

## Montage source (beat 4)

The trailer is an **edit, not a shoot** — every montage cut is lifted from a
finished episode. Because Ep 0 is assembled after V10, the real cuts exist; the
fallback column is only for the launch-before-capstone case (see below).

| # | Montage cut (~3 s) | Primary source | Fallback source |
|---|--------------------|----------------|-----------------|
| 1 | Headless Pi boots; `ssh pi@raspberrypi.local` → shell prompt | V1 shot 7 (`V01-shot-7.png`) | screen-recorded Imager + SSH mockup |
| 2 | Node row flips green **online** in the hub dashboard | V3 shot 5 (`V03-shot-5.png`) | V3 rough-cut footage |
| 3 | Service auto-deploys — `hzn agreement list` shows it running on an unnamed Pi | V5 shot 8 (`V05-shot-8.png`) | screen-recorded `hzn agreement list` mockup |
| 4 | Local LLM answers with the router unplugged | V8 shot 9 (`V08-shot-6.png`) | screen-recorded Open WebUI mockup |
| 5 | Container dies; the monitor writes a red root-cause proposal | V9 shot 9 (`V09-shot-5.png`) | screen-recorded proposal-JSON mockup |
| 6 | Executor restarts it; `.healthy` → `true` | V10 shot 8 (`V10-shot-6.png`) | screen-recorded `actions.log` + health mockup |

---

## Shot list

Everything outside the montage — the trailer's only original footage.

| # | Shot | Notes |
|---|------|-------|
| 1 | Stock-style data-center racks, hard cut to one Pi on a desk | Beat 1. On-screen problem line burned in. Sting on the cut. No machine label. |
| 2 | Bench flashes — two Pis, camera, NUC — fast cuts | Beat 2. Reused B-roll from V3–V6. No machine labels. |
| 3 | Talking head — one line to camera | Beats 2–3. The only piece shot for the trailer itself. |
| 4 | Punchline card: the single Pi, caption "No cloud bill. No PhD. One Pi." | Beat 3. Lower-thirds cleared. |
| 5 | Montage — the six cuts from the table above | Beat 4. ~18 s total. |
| 6 | End-card sequence: "Ten videos. One build. Starts now." → subscribe prompt → the *DIY Edge Computing* book card | Beats 5–7. Fixed end-card type / position; compressed to ~10 s. |

---

## Fallback cut — launch before the capstone

If the V8–V10 capstone is not shot by launch, assemble the trailer from V1–V3
footage plus screen-recorded mockups of the offline-LLM, red-proposal, and
self-restart moments (the montage table's fallback column), then re-cut it with
real capstone footage once V10 is edited (video-series spec, Section 2 and
week 11). The trailer still publishes on launch day — it is never the blocker.

---

## Recording state

None of its own. The trailer is cut entirely from finished episode footage plus
one talking-head line and the opening rack→Pi cut. Schedule it as the last
pre-production task, after V10 is edited. Keep the six montage stills
(`V0N-shot-*.png`) exported and named per [`00-template.md`](00-template.md) so
the cut can be rebuilt quickly for the week-11 re-cut.

---

## Asset checklist

- [ ] Data-center-rack B-roll (stock or shot) and the hard cut to a single Pi (shot 1).
- [ ] Bench-flash B-roll — two Pis, camera, NUC — reused from V3–V6 (shot 2).
- [ ] One talking-head line to camera (shot 3).
- [ ] Six montage clips pulled from the finished V1 / V3 / V5 / V8 / V9 / V10 cuts — or their fallback mockups (montage-source table).
- [ ] Cold-open on-screen problem line: "you want to run AI at the edge. every tutorial assumes a data center."
- [ ] Punchline caption card: "No cloud bill. No PhD. One Pi."
- [ ] Hook / CTA / book-pointer end-card sequence: "Ten videos. One build. Starts now." → "Subscribe so you don't miss episode one." → the *DIY Edge Computing* book card.
- [ ] Cold-open sting cued to the rack→Pi cut (shot 1).
- [ ] `V00-*` asset names per the template (`<NN>` = `00` for the trailer).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
No cloud bill. No PhD. One Pi.
```

**Hook caption (beat 5):**

```
Ten videos. One build. Starts now.
```

**End card (beats 6–7, compressed — the book as a whole, per template):**

```
Every step is written up in DIY Edge Computing
https://github.com/joe-diy/DIY-EdgeComputing
```
