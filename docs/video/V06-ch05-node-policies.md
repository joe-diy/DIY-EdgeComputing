# V6 — CH05 Node Policies

**Date:** 2026-08-29
**Pairs with:** `CH05 - Node Policies` (*Chapter Five - Node Policies*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V6*

**Dramatized moment:** Two Pis; the camera service lands only on the one with a camera, automatically.

Open Horizon has been on the bench since V3, so beat 2 names an OH feature — the
node policy and its properties / constraints — rather than a standalone tool. V6
keeps two Pis in frame for most of the episode: label them `pi-1` (camera module
attached) and `pi-2` (no camera) top-left per the template whenever both are
visible; clear the labels for the punchline and the end card. Everything else
inherits [`00-template.md`](00-template.md) unchanged: vertical 1080×1920, 2:30
target, cold-open sting, burned-in captions, fixed end card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on `pi-2`'s terminal: a classifier container log scrolling the same line forever — `camera not found`, retry, `camera not found`. On-screen line within 2 s: *"the AI landed on the Pi with no camera."* The workload deployed by property (`purpose == edge-ai`, from V5) and nothing said it also needed hardware this box does not have. |
| 2 | **The fix** | 0:20–0:40 | Face enters. A **node policy** lets the node advertise its own properties — `camera == true`, `arch`, `ram_gb`. A service constrains itself to the hardware it needs; the agbot forms an agreement only where the node's properties satisfy that constraint. Both sides opt in. |
| 3 | **Punchline** | 0:40–0:50 | "The Pi finally knows what it is." Clear the lower-thirds and machine labels for the line. Hold on a card: two Pi silhouettes, a camera icon lighting up on one. |
| 4 | **Demo** | 0:50–2:00 | On `pi-1` (camera): show `node.policy.json` for 2 s — the CH02 file with `camera` and `ram_gb` added — then `hzn policy update -f node.policy.json` and `hzn policy list \| jq '.properties'`, all four properties on screen. `pi-2` is left untouched, `camera` absent. Cut to the laptop: the edited `deployment.policy.json`, `"constraints": [ "purpose == edge-ai", "camera == true" ]` highlighted, then `hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-camera"` and `hzn deploycheck all -b "$HZN_ORG_ID/policy-camera"` — callout: `pi-1` compatible, `pi-2` not. Jump-cut the wait. Return, split screen: `hzn agreement list \| jq 'length'` on both — `1` on `pi-1`, `0` on `pi-2`. Still: `V06-shot-9.png`. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "Right service, right box. But it's using an API key you hardcoded. Next: fix that before anyone reads the repo." |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): node properties and constraints → CH05. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Terminal on `pi-2`: classifier container log looping `camera not found` | Beat 1 only. Machine label `pi-2` top-left. On-screen problem line burned in. |
| 2 | Talking head | Beat 2. Face enters on the fix, not before. |
| 3 | Motion-graphic card: two Pi silhouettes, camera icon lighting on one | Beats 2 and 3. No machine labels. |
| 4 | Bench wide shot: `pi-1` and `pi-2` side by side, camera module visible on `pi-1` only | Establishes the two are physically separate and only one has the camera. Runs under beat 1 or the top of beat 4. Both machine labels shown. |
| 5 | Terminal on `pi-1`: show `node.policy.json` (2 s), then `hzn policy update -f node.policy.json` | Highlight the added `camera` and `ram_gb` lines against the CH02 file; `purpose` and `model` unchanged. Machine label `pi-1`. Command as typed before output. |
| 6 | Terminal on `pi-1`: `hzn policy list \| jq '.properties'` | Callout on all four properties — `purpose`, `model`, `camera`, `ram_gb`. |
| 7 | Laptop: show `deployment.policy.json` (2 s), then `hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-camera"` | Highlight `"constraints": [ "purpose == edge-ai", "camera == true" ]`. Machine label `laptop`. Command as typed before output. |
| 8 | Laptop: `hzn deploycheck all -b "$HZN_ORG_ID/policy-camera"` | On-screen callout: `pi-1` compatible, `pi-2` incompatible on `camera == true` — the match predicted before any agreement exists. |
| 9 | Split screen, `pi-1` left / `pi-2` right: `hzn agreement list \| jq 'length'` on each | `1` on `pi-1`, `0` on `pi-2`. Both machine labels shown. Caption overlay: "only the camera Pi." Still: `V06-shot-9.png`. |
| 10 | Timelapse / jump-cut: light-change to sell elapsed minutes between shots 8 and 9 | The agbot runs on its own schedule — do not fake real time. Caption overlay: "walk away." |

---

Recording state: the V5 bench carried forward — `pi-1` and `pi-2` both
registered against the **LF Edge Community Lab** shared hub with the four `HZN_*`
variables and the `node.policy.json` from CH02, and the CH04
`deployment.policy.json` on the laptop. For V6, `pi-1` gets a camera module
physically attached and its node policy extended with `camera` / `ram_gb`; `pi-2`
stays camera-less on the unmodified CH02 file. The camera service is the same
published sample used in CH04, now published behind a second deployment policy
(`$HZN_ORG_ID/policy-camera`) so `policy-edge-ai` is left untouched. The looping
`camera not found` log in beat 1 is a dramatization of the failure mode the
chapter describes. Any V5 sample-service agreement can be left in place or torn
down before recording — it does not affect the `policy-camera` match.

---

## Asset checklist

- [ ] `pi-1` terminal screen-capture — fixed font/size, cropped to vertical safe area, covering shots 5–6.
- [ ] `pi-2` terminal screen-capture — shot 1.
- [ ] `laptop` terminal screen-capture — shots 7–8, `HZN_EXCHANGE_USER_AUTH` / org redacted where visible.
- [ ] Split-screen `pi-1` / `pi-2` capture for `hzn agreement list \| jq 'length'` (shot 9, `V06-shot-9.png`) — `1` and `0` legible.
- [ ] `node.policy.json` on-screen still with the added `camera` and `ram_gb` lines highlighted against the CH02 version.
- [ ] `deployment.policy.json` on-screen still with `"constraints": [ "purpose == edge-ai", "camera == true" ]` highlighted.
- [ ] `hzn deploycheck all` still with the `pi-1` compatible / `pi-2` incompatible result.
- [ ] Bench wide shot — `pi-1` with a visible camera module, `pi-2` without, side by side (shot 4).
- [ ] Timelapse / jump-cut plate for the "walk away" gap (shot 10) — no faked real-time.
- [ ] Cold-open on-screen problem line: "the AI landed on the Pi with no camera."
- [ ] Lower-third command cards for shots 1, 5–9 (monospace, high contrast).
- [ ] Machine-label lower-thirds `pi-1` / `pi-2` / `laptop`, shown only while the machine is on screen; cleared for the punchline and end card.
- [ ] Caption overlays: "walk away." (shot 10), "only the camera Pi." (shot 9).
- [ ] Punchline motion-graphic card — two Pi silhouettes, a camera icon lighting on one (beats 2 and 3).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
The Pi finally knows what it is.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH05
https://github.com/joe-diy/DIY-EdgeComputing
```
