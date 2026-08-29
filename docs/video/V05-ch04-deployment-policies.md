# V5 — CH04 Deployment Policies

**Date:** 2026-08-29
**Pairs with:** `CH04 - Deployment Policies` (*Chapter Four - Deployment Policies*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V5*

**Dramatized moment:** Plug in a new Pi, walk away, the service auto-deploys — you never named the node.

Open Horizon has been on the bench since V3, so beat 2 names an OH feature — the
deployment policy and the agbot that acts on it — rather than a standalone tool.
Everything else inherits [`00-template.md`](00-template.md) unchanged: vertical
1080×1920, 2:30 target, cold-open sting, burned-in captions, fixed end card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on a terminal SSH'd into a brand-new Pi. On-screen line within 2 s: *"new Pi. copy the service def. start it. again. again."* A new node joins the fleet and you hand-place the workload on it — then the next node, and the next. It does not scale past the first few. |
| 2 | **The fix** | 0:20–0:40 | Face enters. A **deployment policy** describes *what runs where* by node **properties**, not hostnames. Publish it once; the hub's **agbot** matches it against every node and forms agreements automatically. Matching nodes pull the workload themselves. |
| 3 | **Punchline** | 0:40–0:50 | "I don't deploy to nodes anymore. They deploy to themselves." Clear the lower-thirds for the line; hold on a card of a Pi with an arrow pulling the service *toward* it. |
| 4 | **Demo** | 0:50–2:00 | On the laptop: `hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-edge-ai"` — the policy's one constraint, `purpose == edge-ai`, on screen. `hzn deploycheck deployment -b "$HZN_ORG_ID/policy-edge-ai"` returns **compatible**. Cut to the bench: plug power into a fresh Pi (`pi-2`), `hzn register --policy node.policy.json` with `purpose=edge-ai`. Walk out of frame — timelapse / jump-cut the wait. Return, `hzn agreement list \| jq '.[] \| {service: .workload_to_run.url, state: .agreement_finalized_time}'` — an agreement with a finalized time, the sample service running. `pi-2` was never named anywhere. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "It deploys everywhere that matches. But some services only belong on some hardware. Next: the node gets a say." |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): writing and publishing deployment policies → CH04. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Terminal on `pi-2`: bare shell, operator hand-copying a service definition | Beat 1 only. Machine label `pi-2` top-left. On-screen problem line burned in. |
| 2 | Laptop: show `deployment.policy.json` for 2 s, then `hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-edge-ai"` | Highlight the single line `"constraints": [ "purpose == edge-ai" ]`. Command as typed before output. Machine label `laptop`. |
| 3 | Laptop: `hzn exchange deployment listpolicy "$HZN_ORG_ID/policy-edge-ai"` | The exchange echoing the stored policy — quick confirmation beat. |
| 4 | Laptop: `hzn deploycheck deployment -b "$HZN_ORG_ID/policy-edge-ai"` | On-screen callout on the **compatible** result — the match predicted before any agreement exists. |
| 5 | Bench: hand plugs the power lead into `pi-2` | The "new Pi joins the fleet" moment. Wide enough to show it is a second, physically separate Pi next to `pi-1`. |
| 6 | Terminal on `pi-2`: `hzn register --policy node.policy.json` | Show `node.policy.json` first (2 s) — `purpose=edge-ai`. Machine label flips to `pi-2`. |
| 7 | Timelapse / jump-cut: operator walks out of frame, clock or light-change to sell elapsed minutes, walks back | Do not fake real time — the agbot runs on its own schedule. Caption overlay: "walk away." |
| 8 | Terminal on `pi-2`: `hzn agreement list \| jq '.[] \| {service: .workload_to_run.url, state: .agreement_finalized_time}'` | On-screen callout on the populated `agreement_finalized_time` — service running. Caption overlay: "nobody named this node." Still: `V05-shot-8.png`. |

Recording state: the V3 bench reset to shared-hub state after V4 — `pi-1`
registered against the **LF Edge Community Lab** shared hub with the four `HZN_*`
variables and the `node.policy.json` from CH02 — plus a **second Raspberry Pi**
(`pi-2`), unregistered and powered off, holding the same `node.policy.json`. A
published sample service picked in CH04 (the IBM `helloworld` service). No
services deployed anywhere at the top of the episode.

---

## Asset checklist

- [ ] `pi-2` terminal screen-capture — fixed font/size, cropped to vertical safe area, covering shots 1, 6, 8.
- [ ] `laptop` terminal screen-capture — shots 2–4, `HZN_EXCHANGE_USER_AUTH` / org redacted where visible.
- [ ] `deployment.policy.json` on-screen still with `"constraints": [ "purpose == edge-ai" ]` highlighted.
- [ ] Bench wide shot — `pi-1` and `pi-2` side by side, power lead going into `pi-2` (shot 5).
- [ ] Timelapse / jump-cut plate for the "walk away" gap (shot 7) — no faked real-time.
- [ ] `hzn agreement list` still with a populated `agreement_finalized_time` (`V05-shot-8.png`).
- [ ] Cold-open on-screen problem line: "new Pi. copy the service def. start it. again. again."
- [ ] Lower-third command cards for shots 1–4, 6, 8 (monospace, high contrast).
- [ ] Caption overlays: "walk away." (shot 7), "nobody named this node." (shot 8).
- [ ] Punchline motion-graphic card — a Pi with the service arrow pulling toward it (beats 1 and 3).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
They deploy to themselves.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH04
https://github.com/joe-diy/DIY-EdgeComputing
```
