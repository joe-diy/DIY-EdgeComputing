# V4 — CH03 Hosting Your Own Hub *(bonus)*

**Date:** 2026-08-29
**Pairs with:** `CH03 - Hosting Your Own Hub` (*Chapter Three - Hosting Your Own Hub*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V4*

**Dramatized moment:** `compose up` on a NUC and you own a full Open Horizon control plane — exchange, agbot, CSS — with a Pi registered to it.

**Bonus — off the critical path.** This episode mirrors the optional chapter: it
slots in at week 8 or holds to the end of the season without blocking any other
video. Readers who skip CH03 stay on the shared LF Edge Community Lab hub, so the
demo is recorded against a **throwaway hub config on a second host**, and the
bench is switched **back to the shared hub** the moment recording wraps —
nothing in V5–V10 may depend on state this episode creates. Beat 2 names an Open
Horizon feature (the containerised control plane) since OH has been on the bench
since V3. Everything else inherits [`00-template.md`](00-template.md) unchanged:
vertical 1080×1920, 2:30 target, cold-open sting, burned-in captions, fixed end
card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on a terminal registered to the community hub. On-screen line within 2 s: *"where does the data actually live?"* You love the free community hub. Legal does not. They want to know exactly which building your fleet inventory sits in. |
| 2 | **The fix** | 0:20–0:40 | Face enters. The whole Open Horizon control plane — exchange, agbot, CSS, and its database — is just containers. One script does a `compose up` on a spare 64-bit Linux box (a NUC, a closet server, a VM). The hub is now yours. |
| 3 | **Punchline** | 0:40–0:50 | "Built my own cloud. It's in the closet." Callback to V1's closeted monitor. Clear the lower-thirds for the line; hold on a card of a NUC on a shelf. |
| 4 | **Demo** | 0:50–2:00 | On the NUC: `curl` the `deploy-mgmt-hub.sh` script, `chmod +x`, run it — images pull, the stack comes up, the completion banner prints URLs + credentials (redacted). Export `HZN_EXCHANGE_URL=http://localhost:3090/v1`; `hzn exchange version` returns a version — the hub answers on `localhost`. Cut to `pi-1`: `hzn unregister -f -r`, then the *same* `agent-install.sh` command from V3 with the new `HZN_*` URLs — ends on *"Horizon node is registered."* Then re-attach the CH02 node policy — `hzn unregister -f -r` then `hzn register --policy node.policy.json` — or nothing from CH04 on will match. `hzn node list` shows `state: "configured"`. Cut to a laptop browser on *your* hub's dashboard — refresh — the Pi's node row appears, in a hub you are running. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "Your hub, your rules — and everything from here works the same whether it's yours or the community's. Next: deployment policies." |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): sizing, TLS, backups → CH03. Optional — skip it and stay on the shared hub. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Terminal on `nuc`: `curl -sSL …/deploy-mgmt-hub.sh -o deploy-mgmt-hub.sh` then `chmod +x deploy-mgmt-hub.sh` | Command as typed before output. `nuc` machine label top-left. |
| 2 | Terminal on `nuc`: `./deploy-mgmt-hub.sh` | The `compose up` moment — exchange, agbot, CSS, and database images pull and start under `docker compose` / `podman compose`. Hold on the completion banner with the URLs and credentials; redact the credentials. |
| 3 | Terminal on `nuc`: `export HZN_EXCHANGE_URL=http://localhost:3090/v1` then `hzn exchange version` | On-screen callout: the version number = the hub answering on `localhost`. |
| 4 | Terminal on `pi-1`: `hzn unregister -f -r`, then `sudo -E ./agent-install.sh -O "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH" -i 'anax:'`, then `hzn unregister -f -r` + `hzn register --policy node.policy.json` | Byte-for-byte the V3 install command — only the `HZN_*` URLs changed. Machine label flips to `pi-1`. Run to *"Horizon node is registered. Workload agreement negotiation should begin shortly."*, then re-attach the CH02 node policy so `purpose=edge-ai` survives the re-point. |
| 5 | Terminal on `pi-1`: `hzn node list \| jq '.configstate.state'` | On-screen callout on `"configured"`. |
| 6 | Laptop browser: *your* hub dashboard at the NUC's address | Refresh on camera; the Pi's node row appears in a hub you are running. Caption overlay: "my hub. my closet." No machine label on the browser shot. |
| 7 | (optional B-roll) wide of the NUC on a shelf next to the closeted monitor from V1 | For beat 1 / beat 3 only. |

Recording state: the V3 bench (one Raspberry Pi, `pi-1`, registered to the LF
Edge Community Lab shared hub) plus a **second always-on 64-bit Linux host**
(`nuc`) with a container engine and `docker compose` / `podman compose`. Bring
the hub up with a **throwaway config**, record, then `hzn unregister` the Pi and
re-run `agent-install.sh` against the shared community-lab hub so the bench is
back to exact V3 state before V5 is recorded. Nothing in this episode persists
into later episodes.

---

## Asset checklist

- [ ] `nuc` terminal screen-capture — fixed font/size, cropped to vertical safe area, covering shots 1–3.
- [ ] `pi-1` terminal screen-capture — shots 4–5, credential redacted.
- [ ] Hub-UI screen-capture — laptop browser on *your* hub dashboard (the NUC's address), the Pi's node row appearing on refresh (`V04-shot-6.png` for the still).
- [ ] `deploy-mgmt-hub.sh` completion-banner still with the URLs and credentials, credentials redacted.
- [ ] Cold-open on-screen problem line: "where does the data actually live?"
- [ ] Lower-third command cards for shots 1–5 (monospace, high contrast).
- [ ] "my hub. my closet." caption overlay for shot 6.
- [ ] (optional) NUC-on-a-shelf B-roll next to the closeted monitor callback from V1.

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
Built my own cloud. It's in the closet.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH03 (optional)
https://github.com/joe-diy/DIY-EdgeComputing
```
