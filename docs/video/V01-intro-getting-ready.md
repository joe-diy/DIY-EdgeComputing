# V1 — Introduction - Getting Ready

**Date:** 2026-08-29
**Pairs with:** `Introduction - Getting Ready` (*the book's Introduction chapter*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V1*

**Dramatized moment:** Headless Pi boots; you SSH in having never plugged in a screen or keyboard.

This episode predates Open Horizon, so beat 2 names the relevant tool (Raspberry
Pi Imager's pre-configure step) rather than an OH feature — the same *"V1–V2
predate OH"* carve-out V2 uses. The Introduction chapter README is **not**
changed by this plan; V1 dramatizes the headless first-boot and mDNS SSH that its
"Connecting to the Raspberry Pi" section is about, baking the SSH + Wi-Fi
credentials onto the card up front so no screen is ever connected. Everything
else inherits [`00-template.md`](00-template.md) unchanged: vertical 1080×1920,
2:30 target, cold-open sting, burned-in captions, fixed end card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on hands digging through a tangled cable drawer — HDMI leads, old adapters, a keyboard with a bent USB plug. On-screen line within 2 s: *"you bought a Pi. now find a monitor, a keyboard, and that HDMI cable you 'definitely own'."* You just want the Pi on the network; instead you are staging a whole desk for a machine you will never look at again. |
| 2 | **The fix** | 0:20–0:40 | Face enters. Raspberry Pi Imager's pre-configure ("edit settings" / the gear): set the hostname, **enable SSH**, and enter the Wi-Fi SSID + password + country **before** the card is written. The credentials are baked onto the SD card, so the Pi joins Wi-Fi and accepts SSH on its very first boot. No screen, no keyboard, ever. *(V1 predates Open Horizon — this beat names the tool, per template.)* |
| 3 | **Punchline** | 0:40–0:50 | "The monitor stays in the closet. Where it belongs." Clear the lower-thirds for the line; hold on a card of a monitor shut in a closet. |
| 4 | **Demo** | 0:50–2:00 | In Raspberry Pi Imager: choose the OS + storage, open the settings pane, set hostname `raspberrypi`, tick **Enable SSH** (password auth), fill in Wi-Fi SSID / password / country, write the card. Pull the card, seat it in the Pi, connect **only the power lead** — wide shot, HDMI and USB ports visibly empty. Jump-cut the ~30–60 s first boot. On the `laptop`: `ping raspberrypi.local` resolves → `ssh pi@raspberrypi.local` → accept the host key → password → the shell prompt appears. Pan the bench: still no screen, no keyboard. `passwd` on camera to change the default password, per the chapter. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "It's alive — but it can't run anything yet. Next: we give it an engine." |
| 6 | **Call to action** | 2:12–2:22 | "Episode 1 of building a self-healing edge AI box. Subscribe or miss the rest." Framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): OS options and troubleshooting → the Introduction chapter. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Cable-drawer dig — hands rummaging a tangle of HDMI / USB cables and adapters | Beat 1 only. On-screen problem line burned in. No machine label. |
| 2 | Talking head | Beat 2. Face enters on the fix, not before. |
| 3 | Screen-capture: Raspberry Pi Imager — OS + storage chosen, the settings pane open, hostname / **Enable SSH** / Wi-Fi fields filled | Beats 2, 4. Redact the real Wi-Fi SSID + password — blur, or use a throwaway network. |
| 4 | Imager "Write" progress bar to completion, then the card pulled from the reader | Beat 4. Sells that the credentials were committed to the card, not typed in later. |
| 5 | Bench wide: the SD card goes into the Pi, **only** the power lead connected — HDMI and USB ports empty in frame | Beat 4. This is the "no screen ever" proof shot; hold it wide. No machine label. |
| 6 | Jump-cut / timelapse of the first boot — a clock, or the Pi's ACT LED blinking | Beat 4. Do not fake the wait; ~30–60 s of first boot. Caption overlay: "no screen. no keyboard." |
| 7 | `laptop` terminal: `ping raspberrypi.local` resolving, then `ssh pi@raspberrypi.local` → host-key prompt → password → shell prompt | Beat 4. Lower-third shows each command as typed before output. Machine label `laptop`. Still: `V01-shot-7.png`. |
| 8 | `laptop` terminal: `passwd` — change the default password on camera | Beat 4. Matches the chapter's "change the password right away". Password entry off-screen. |
| 9 | (optional B-roll) slow pan across the bench — the Pi running, HDMI ports empty, the monitor shut in a closet | Beats 3 / 5 only. |

Recording state: a bare Raspberry Pi (a Pi 3 B+ or Pi 4, per the Introduction
chapter), a blank microSD card + reader, and a `laptop` on the same LAN with
Raspberry Pi Imager installed and mDNS working (`raspberrypi.local` resolves). No
container engine, no Open Horizon agent — this is the first episode; the bench
starts empty. Use a throwaway or redacted Wi-Fi network on the pre-configure
screen so no real SSID / password is captured.

---

## Asset checklist

- [ ] Cable-drawer B-roll for the cold open (shot 1) — a genuine tangle, hands searching.
- [ ] Raspberry Pi Imager screen-capture — OS / storage select and the pre-configure settings pane (shots 3, 4); Wi-Fi SSID + password redacted or a throwaway network.
- [ ] Bench wide shot — SD card into the Pi, only the power lead connected, HDMI / USB ports empty (shot 5).
- [ ] First-boot jump-cut / timelapse plate (shot 6) — real elapsed time, not faked.
- [ ] `laptop` terminal screen-capture — `ping` + `ssh` + `passwd` (shots 7, 8); host key and prompt visible, the password itself off-screen. `V01-shot-7.png` pulled from the prompt appearing.
- [ ] Cold-open on-screen problem line: "you bought a Pi. now find a monitor, a keyboard, and that HDMI cable you 'definitely own'."
- [ ] Lower-third command cards for shots 7–8 (monospace, high contrast).
- [ ] Caption overlay: "no screen. no keyboard." (shot 6).
- [ ] Punchline motion-graphic card — a monitor shut in a closet (beat 3; V4 calls back to it).
- [ ] Cold-open sting cued to the first frame of the cable-drawer dig (shot 1).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
The monitor stays in the closet. Where it belongs.
```

**Demo caption (beat 4, over shot 6):**

```
no screen. no keyboard.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, Introduction - Getting Ready
https://github.com/joe-diy/DIY-EdgeComputing
```
