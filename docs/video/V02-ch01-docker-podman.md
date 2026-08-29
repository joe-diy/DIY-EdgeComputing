# V2 — CH01 Docker & Podman

**Date:** 2026-08-29
**Pairs with:** `CH01 - Docker` (*Chapter One - Containers with Docker and Podman*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V2*

**Dramatized moment:** The exact same `container run` works on Docker and Podman — swap engines, nothing breaks.

This episode predates Open Horizon, so beat 2 names the relevant tool (the two
container engines) rather than an OH feature. Everything else inherits
[`00-template.md`](00-template.md) unchanged: vertical 1080×1920, 2:30 target,
cold-open sting, burned-in captions, fixed end card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on a terminal. On-screen line within 2 s: *"the tutorial says `docker`. my distro shipped `podman`."* You followed a tutorial. It says `docker`. Your distro shipped Podman. Now every command is a coin flip. |
| 2 | **The fix** | 0:20–0:40 | Face enters. Both engines speak the same CLI and run the same OCI images — write the command once, run it on either. Docker or Podman is a choice you make once, not per command. |
| 3 | **Punchline** | 0:40–0:50 | "Two engines, one muscle memory." Clear the lower-thirds for the line. |
| 4 | **Demo** | 0:50–2:00 | Split-screen terminal. `docker run hello-world` on the left; the identical command as `podman run hello-world` on the right. `diff` the two outputs on screen — byte-identical, same image digest, no rebuild. Then `docker images` / `podman images` side by side showing the same image pulled once per engine. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "One container engine is great. Fifty Pis running it by hand is not. Next: something has to manage the fleet." |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): install both, when to pick which → CH01. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Terminal: `docker run hello-world` | Lower-third shows the command as typed, before output. Capture full output. |
| 2 | Terminal: `podman run hello-world` | Same node, same shell. Identical flags. |
| 3 | `diff <(docker run hello-world) <(podman run hello-world)` | On-screen: no output = identical. Byte-diff overlay lands here. |
| 4 | `docker images` and `podman images` side by side | Same repo/tag, same image ID, pulled once per engine store. |
| 5 | (optional B-roll) the tutorial page that says `docker` next to the distro that ships `podman` | For beat 1 only. |

Recording state: one Raspberry Pi on the bench with **both** Docker and Podman
installed (per the revised Introduction "Installing Software" section). No Open
Horizon agent yet.

---

## Asset checklist

- [ ] Split-screen terminal recording — Docker left, Podman right, same font/size, aligned prompts.
- [ ] Byte-diff overlay — graphic that shows the two `hello-world` outputs collapsing to a single identical stream (or the empty `diff` result), reinforcing "nothing breaks."
- [ ] `docker images` / `podman images` side-by-side still (`V02-shot-4.png`).
- [ ] Cold-open on-screen problem line: "the tutorial says `docker`. my distro shipped `podman`."
- [ ] Lower-third command cards for shots 1–4 (monospace, high contrast).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
Two engines, one muscle memory.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH01
https://github.com/joe-diy/DIY-EdgeComputing
```
