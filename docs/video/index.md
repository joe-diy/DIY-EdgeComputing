# Video Production Tracker — DIY Edge Computing series

**Date:** 2026-08-29
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md)
**Conventions:** [`00-template.md`](00-template.md)

Status board for the 11-video companion series — 1 trailer + 10 chapter videos.
One row per video, seeded from the video-series spec's Section 1. `Dramatized
moment` is the single "aha" each episode dramatizes, copied verbatim from the
spec except where noted below. Each `Ep` cell links to that episode's beat sheet.

All 11 beat sheets now exist, so every `Beat sheet` cell is `☑`. `Recorded`,
`Edited`, and `Published` still start `☐`; later tasks flip them as each episode
moves through the pipeline (record → edit → publish).

**Build order:** `Ep0(last) → V1 → V2 → V3 → (V4 bonus) → V5 → V6 → V7 → V8 → V9 → V10`

| Ep | Pairs with | Dramatized moment | Beat sheet | Recorded | Edited | Published |
|----|-----------|-------------------|------------|----------|--------|-----------|
| [Ep 0](Ep0-trailer.md) | — (trailer) | "A $75 Pi running a self-healing AI cluster — the whole journey, fast." | ☑ | ☐ | ☐ | ☐ |
| [V1](V01-intro-getting-ready.md) | Introduction - Getting Ready | Headless Pi boots; you SSH in having never plugged in a screen or keyboard. | ☑ | ☐ | ☐ | ☐ |
| [V2](V02-ch01-docker-podman.md) | CH01 Docker & Podman | The exact same `container run` works on Docker and Podman — swap engines, nothing breaks. | ☑ | ☐ | ☐ | ☐ |
| [V3](V03-ch02-fundamentals.md) | CH02 Open Horizon Fundamentals | One `hzn register` and the Pi appears in a cloud hub dashboard from across the internet. | ☑ | ☐ | ☐ | ☐ |
| [V4](V04-ch03-selfhost.md) *(bonus)* | CH03 Hosting Your Own Hub | `compose up` and you own a full edge control plane on a NUC. | ☑ | ☐ | ☐ | ☐ |
| [V5](V05-ch04-deployment-policies.md) | CH04 Deployment Policies | Plug in a new Pi, walk away, the service auto-deploys — you never named the node. | ☑ | ☐ | ☐ | ☐ |
| [V6](V06-ch05-node-policies.md) | CH05 Node Policies | Two Pis; the camera service lands only on the one with a camera, automatically. | ☑ | ☐ | ☐ | ☐ |
| [V7](V07-ch06-secrets.md) | CH06 Secrets Management | Rotate a private registry credential in the hub; the fleet re-pulls, nothing hardcoded, no manual redeploy. | ☑ | ☐ | ☐ | ☐ |
| [V8](V08-ch07-local-ai.md) | CH07 Deploying Local AI | Ask a local LLM a question with the internet unplugged. | ☑ | ☐ | ☐ | ☐ |
| [V9](V09-ch08-detecting.md) | CH08 Detecting Problems | Kill the AI container on purpose; the dashboard goes red and says exactly what broke. | ☑ | ☐ | ☐ | ☐ |
| [V10](V10-ch09-remediation.md) | CH09 Autonomous Remediation | Break it again — the local AI diagnoses and restarts it while you watch, hands off keyboard. | ☑ | ☐ | ☐ | ☐ |

*V7's moment revised per the 2026-08-29 addendum to the video-series spec (was "rotate an API key").*

## Notes

- **V4 is the bonus / off-critical-path episode** — it mirrors the optional CH03,
  slots in or holds to the end, and must not leave bench state that later videos
  depend on.
- **The trailer (Ep 0) is produced last and published first** — its best footage
  is clips from V8–V10, so it is assembled after the capstone is shot, then it
  opens the season.
