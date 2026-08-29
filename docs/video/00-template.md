# Video Template — DIY Edge Computing series

**Date:** 2026-08-29
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md)
**Applies to:** every episode spec `docs/video/VNN-*.md` and the trailer (Ep 0)

Shared production conventions for all 11 videos. Each episode spec inherits
everything here; an episode overrides a convention only by saying so explicitly.
This file is the source of truth for the cold-open sting, lower-third style,
end-card wording, caption style, and the 2:30 beat budget.

---

## Format — vertical Shorts

- **Frame:** vertical 1080×1920.
- **Platform:** YouTube Shorts.
- **Length:** hard cap 3:00, target 2:30. The trailer (Ep 0) runs to ~0:50.
- No channel intro, no outro bumper — the end card (below) is the only fixed tail.

---

## Beat budget — verbatim from the video-series spec, Section 4

Times and beat names are fixed. Episode beat sheets fill in the content, not the
clock.

| # | Beat | Budget | Purpose |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open *inside* the pain. No intro, no "hey guys." |
| 2 | **The fix** | 0:20–0:40 | Name the Open Horizon feature that kills the problem. *(V1–V2 predate OH, so they name the relevant tool instead.)* |
| 3 | **Punchline** | 0:40–0:50 | One joke on the turn. Gen Z register, dry. |
| 4 | **Demo** | 0:50–2:00 | The real thing on real hardware — the "aha" moment from Section 1, nothing else. ~70s. |
| 5 | **Hook** | 2:00–2:12 | The unanswered problem the next video solves. |
| 6 | **Call to action** | 2:12–2:22 | Subscribe / like, framed as "follow the build." |
| 7 | **Book pointer** | 2:22–2:30 | End card: "full walkthrough → [chapter]." |

The trailer uses a compressed version of the same structure: problem → what the
series is → punchline → montage → hook → CTA → book pointer.

---

## Cold open — open inside the pain

- No intro, no "hey guys," no channel bumper.
- 0.5 s sting (hard audio + visual cut) on the first frame.
- On-screen problem statement within the first 2 s: one line, plain language,
  the thing that is broken.
- The creator's face enters on beat 2 (the fix), not before.

---

## Lower-thirds

- **Command being run:** bottom third, monospace, high contrast (light text on a
  solid or heavily dimmed backing). Show the command as typed, before its output.
- **Machine label:** node / host name top-left whenever more than one machine is
  on screen (e.g. `pi-1`, `pi-2`, `nuc`). Omit it when only one machine is in
  frame.
- Both are persistent only while relevant; clear them for the punchline and the
  end card.

---

## End card — last 8 s (2:22–2:30)

Identical across every episode — same type, same position, same duration. It is
the series' signature.

```
Full walkthrough → DIY Edge Computing, <Chapter>
https://github.com/joe-diy/DIY-EdgeComputing
```

- `<Chapter>` is the paired chapter from the tracker (e.g. `CH06 - Secrets Management`).
- The trailer's `<Chapter>` is the book as a whole ("every step is written up in *DIY Edge Computing*").

---

## Captions

- Burned-in, always on.
- Sentence case — no all-caps, no Title Case.
- ≤ 2 lines on screen at once.
- Gen-Z register but dry: reads like a person who is not trying too hard.
- No emoji spam. A single emoji occasionally is fine; a wall of them is not.

---

## Register

- Solo creator, talking to one person.
- Exactly one joke per video, landed on the turn from problem to fix (beat 3).
- Everywhere else: matter-of-fact. The hardware does the showing off.

---

## Recording rig checklist

Stood up once in pre-production, then start/stop each week — never re-rig:

- Standing screen-capture source, fixed resolution, cropped to the vertical safe area.
- Talking-head camera on a fixed frame and focus.
- Mic on a boom or stand, plus a lav as backup and for any away-from-desk shots.
- Editor project template with the sting, lower-third, and end-card presets
  already placed on the timeline.
- Bench powered and at the correct chapter state before recording (see the
  spec's build sequence, Section 2).

---

## Asset naming

- **Takes:** `V<NN>-<slug>-<take>.<ext>` — e.g. `V07-secret-rotation-03.mov`.
- **Proposal stills / screenshots:** `V<NN>-shot-<n>.png` — e.g. `V07-shot-2.png`.
- `<NN>` is two digits, zero-padded; the trailer uses `V00`.
- `<slug>` is short, lowercase, hyphenated, and stable across takes.
