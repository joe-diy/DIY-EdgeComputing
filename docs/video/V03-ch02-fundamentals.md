# V3 — CH02 Open Horizon Fundamentals

**Date:** 2026-08-29
**Pairs with:** `CH02 - Open Horizon Fundamentals` (*Chapter Two - Open Horizon Fundamentals*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V3*

**Dramatized moment:** One `hzn register` and the Pi appears in a cloud hub dashboard from across the internet.

This is the first episode with Open Horizon on the bench, so beat 2 names an
actual OH feature — the agent plus `hzn register` — rather than a standalone
tool. Everything else inherits [`00-template.md`](00-template.md) unchanged:
vertical 1080×1920, 2:30 target, cold-open sting, burned-in captions, fixed end
card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on a terminal already SSH'd into `pi-1`. On-screen line within 2 s: *"one Pi, done. now do it 40 more times."* You've got a Pi with a container engine. Now multiply by 40, across 5 buildings. SSH into each one? Forever? |
| 2 | **The fix** | 0:20–0:40 | Face enters. Install the Open Horizon agent (anax) once, then `hzn register` the node against a management hub — the LF Edge Community Lab's free hub. The node phones home; the hub drives it from there. No more per-node SSH. |
| 3 | **Punchline** | 0:40–0:50 | "Forty Pis. One command. Zero road trips." Clear the lower-thirds for the line; hold on the "×40 across 5 buildings" motion-graphic card. |
| 4 | **Demo** | 0:50–2:00 | Run `agent-install.sh` on the Pi with the four `HZN_*` vars exported — installer ends on *"Horizon node is registered."* Then `hzn unregister -f -r` (the installer already registered the node) and `hzn register --policy node.policy.json` (policy advertises `purpose=edge-ai`, `model=rpi5-8gb`). `hzn node list` shows `state: "configured"`. Cut to a laptop browser on the hub dashboard — refresh — the node row flips to green **online**, from across the internet, nobody having touched the Pi's keyboard. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "The hub can see the node — but it's not running anything useful yet. Next: tell it what to deploy, without naming names." |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): agent install, hub credentials, exchange URL → CH02. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Terminal on `pi-1`: `export HZN_ORG_ID=… / HZN_EXCHANGE_URL=… / HZN_FSS_CSSURL=… / HZN_EXCHANGE_USER_AUTH=…` | Values pre-filled off-camera; blur/redact the credential. Lower-third shows the four var names. |
| 2 | Terminal: `sudo -E ./agent-install.sh -O "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH" -i 'anax:'` | Command as typed before output. Let it run to the final line *"Horizon node is registered. Workload agreement negotiation should begin shortly."* — hold on that line. |
| 3 | Terminal: `hzn unregister -f -r` then `hzn register --policy node.policy.json` | The installer already registered the node, so unregister first (matches V4 shot 4). Show the `node.policy.json` contents first (2 s) — `purpose=edge-ai`, `model=rpi5-8gb`. |
| 4 | Terminal: `hzn node list \| jq '{id, org, state}'` | On-screen callout on `state: "configured"`. |
| 5 | Laptop browser: hub dashboard, node list | Refresh on camera; the new node row appears and flips green **online**. Caption overlay: "from across the internet." Machine labels: `pi-1` top-left of terminal shots, none on the browser shot. |
| 6 | (optional B-roll) wide of a single Pi on the bench next to the "×40 across 5 buildings" card | For beat 1 / beat 3 only. |

Recording state: one Raspberry Pi (`pi-1`) on the bench with a container engine
from V2, now getting the Open Horizon agent installed and registered against the
**LF Edge Community Lab** shared hub. Four `HZN_*` environment variables and a
`node.policy.json` from CH02. No services deployed yet — that is V5.

---

## Asset checklist

- [ ] Pi terminal screen-capture — `pi-1`, fixed font/size, cropped to vertical safe area, covering shots 1–4.
- [ ] Hub-UI screen-capture — laptop browser on the community-lab hub dashboard, the node row going from absent → green **online** on refresh (`V03-shot-5.png` for the still).
- [ ] "×40 across 5 buildings" motion-graphic card — one Pi multiplying out to a grid of 40 across five building outlines; used under beats 1 and 3.
- [ ] Cold-open on-screen problem line: "one Pi, done. now do it 40 more times."
- [ ] Lower-third command cards for shots 1–4 (monospace, high contrast), credential redacted.
- [ ] "from across the internet" caption overlay for shot 5.

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
Forty Pis. One command. Zero road trips.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH02
https://github.com/joe-diy/DIY-EdgeComputing
```
