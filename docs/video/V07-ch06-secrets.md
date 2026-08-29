# V7 — CH06 Secrets Management

**Date:** 2026-08-29
**Pairs with:** `CH06 - Secrets Management` (*Chapter Six - Secrets Management*)
**Conventions:** [`00-template.md`](00-template.md)
**Companion to:** [`2026-08-29-video-series-plan-design.md`](../superpowers/specs/2026-08-29-video-series-plan-design.md), Section 4 → *V7*

**Dramatized moment:** Rotate a private registry credential in the hub; the fleet re-pulls, nothing hardcoded, no manual redeploy.

> **Revised per the 2026-08-29 addendum to the video-series spec.** The original
> V7 rotated an AI API key. Verification of `service-edge-ai` (see
> [`00-verification-service-edge-ai.md`](00-verification-service-edge-ai.md))
> found the AI stack needs no secret of its own, so V7 now rotates a **private
> container-registry pull credential** — a generic Open Horizon secret every
> reader can use. Same secrets-manager mechanism, same punchline; only the
> example secret changed.

Open Horizon has been on the bench since V3, so beat 2 names an OH feature — the
secrets manager and the secret binding — rather than a standalone tool.
Everything else inherits [`00-template.md`](00-template.md) unchanged: vertical
1080×1920, 2:30 target, cold-open sting, burned-in captions, fixed end card.

---

## Beat sheet

| # | Beat | Budget | Content |
|---|------|--------|---------|
| 1 | **Relatable problem** | 0:00–0:20 | Cold open on an editor: a service definition with `"auth": "svc-acct:ghp_REALlookingToken…"` typed straight into it, then a cut to `git push` against a repo whose About panel reads **Public**. On-screen line within 2 s: *"the registry token is in the service def. the service def is in a public repo."* Record-scratch on the push. |
| 2 | **The fix** | 0:20–0:40 | Face enters. Open Horizon's **secrets manager**: the credential goes into the hub's Vault-backed store, and a **secret binding** in the service def points at it by name. Never in the image, never in git. The agent mounts it into the container at deploy time. |
| 3 | **Punchline** | 0:40–0:50 | "Rotated my token. Told nobody. Everything kept working." Clear the lower-thirds for the line; hold on a card — a key icon dropping into a vault, a container lighting up. |
| 4 | **Demo** | 0:50–2:00 | On the `laptop`: `printf '{ "auth": "%s:%s" }' "$REGISTRY_USER" "$REGISTRY_TOKEN" \| hzn secretsmanager secret add --secretName registry-pull --secretFile -`, then `hzn secretsmanager secret list` showing `registry-pull`. Show the `secretBinding` block in the service def for 2 s — `{ "registry-auth": "<org>/registry-pull" }` highlighted, plus the `/open-horizon-secrets/registry-auth` mount-path callout. Deploy. Cut to `pi-1`: `hzn service configstate list`, then exec into the container and `cat /open-horizon-secrets/registry-auth` — the `{ "auth": … }` object is present. Box the **container ID** on screen. Back on the `laptop`: the rotate one-liner — same command, `$NEW_REGISTRY_TOKEN`. Jump-cut the agent's next poll. Return to `pi-1`, **same container ID**, `cat` the file again — new token value. No `hzn register`, no rebuild, no redeploy. Still: `V07-shot-8.png`. ~70 s. |
| 5 | **Hook** | 2:00–2:12 | "Nothing hardcoded, nothing to redeploy. Next: the payoff — a real LLM running on the Pi, pulling its image with the credential you just secured." |
| 6 | **Call to action** | 2:12–2:22 | "Follow the build." Subscribe / like framed as following the build, per template. |
| 7 | **Book pointer** | 2:22–2:30 | End card (fixed): storing and binding secrets → CH06. |

---

## Shot list

| # | Shot | Notes |
|---|------|-------|
| 1 | Editor: service definition with a real-looking registry token pasted inline | Beat 1. On-screen problem line burned in. No machine label — an editor, not a shell. |
| 2 | Terminal: `git push`, then the repo's **Public** badge in frame | Beat 1. Record-scratch sting lands on the push. |
| 3 | Talking head | Beat 2. Face enters on the fix, not before. |
| 4 | Motion-graphic card: a key icon dropping into a vault, a container lighting up | Beats 2 and 3. No machine labels. |
| 5 | `laptop`: `printf … \| hzn secretsmanager secret add --secretName registry-pull --secretFile -`, then `hzn secretsmanager secret list` | Machine label `laptop`. Command as typed before output. `$REGISTRY_USER` / `$REGISTRY_TOKEN` come from the shell — never shown as literals. |
| 6 | `laptop`: the `secretBinding` block in the service def (2 s) | Highlight `"secrets": [ { "registry-auth": "<org>/registry-pull" } ]` and call out the `/open-horizon-secrets/registry-auth` mount path. |
| 7 | `pi-1`: `hzn service configstate list`, then exec into the container and `cat /open-horizon-secrets/registry-auth` | Machine label `pi-1`. Callout boxes the **container ID** and the `{ "auth": … }` value. |
| 8 | `pi-1`: **same container ID** on screen, `cat /open-horizon-secrets/registry-auth` again after the rotate | Token value changed; container ID unchanged. Caption overlay: "same container. new secret." Still: `V07-shot-8.png`. |
| 9 | `laptop`: the rotate one-liner — `printf … "$NEW_REGISTRY_TOKEN" … \| hzn secretsmanager secret add …` | Same command as shot 5; only the token variable differs. Machine label `laptop`. |
| 10 | Timelapse / jump-cut: light-change to sell the agent's poll interval between shot 9 and shot 8's second `cat` | The agent polls on its own schedule — do not fake real time. Caption overlay: "wait for the poll." |

---

Recording state: the V6 bench carried forward — `pi-1` registered against the
**LF Edge Community Lab** shared hub with the four `HZN_*` variables, and the
`laptop` holding the service definition and deployment policy from CH04–CH05. For
V7 the sample service is published from a **private registry** — a throwaway
registry namespace with a service account whose token can be rotated freely — and
the service definition gains a `secretBinding` for `registry-pull`.
`$REGISTRY_USER`, `$REGISTRY_TOKEN`, and `$NEW_REGISTRY_TOKEN` are exported in the
`laptop` shell before recording so no credential is ever typed as a literal on
camera. The "public repo" in beat 1 is a throwaway repo used only for the
dramatization; the pasted token is fake and is revoked before publish. No new
hardware over V6.

---

## Asset checklist

- [ ] `laptop` terminal screen-capture — shots 5, 6, 9; `HZN_EXCHANGE_USER_AUTH` / org and all `$REGISTRY_*` values redacted or off-screen.
- [ ] `pi-1` terminal screen-capture — shots 7, 8; container ID legible in both.
- [ ] Editor still — service def with an inline (fake) registry token, problem line burned in (shot 1).
- [ ] `git push` + **Public** repo badge capture (shot 2).
- [ ] `secretBinding` on-screen still with `"registry-auth": "<org>/registry-pull"` and the `/open-horizon-secrets/registry-auth` mount path highlighted.
- [ ] Before/after `cat /open-horizon-secrets/registry-auth` stills — same container ID, different token value (`V07-shot-8.png`).
- [ ] Timelapse / jump-cut plate for the "wait for the poll" gap (shot 10) — no faked real-time.
- [ ] Cold-open on-screen problem line: "the registry token is in the service def. the service def is in a public repo."
- [ ] Lower-third command cards for shots 2, 5–9 (monospace, high contrast).
- [ ] Caption overlays: "wait for the poll." (shot 10), "same container. new secret." (shot 8).
- [ ] Punchline motion-graphic card — a key icon into a vault, a container lighting up (beats 2 and 3).
- [ ] Record-scratch sting cued to the `git push` (shot 2).

---

## Caption / end-card copy

**Punchline caption (beat 3):**

```
Rotated my token. Told nobody. Everything kept working.
```

**End card (beats 7, last 8 s — fixed template wording):**

```
Full walkthrough → DIY Edge Computing, CH06
https://github.com/joe-diy/DIY-EdgeComputing
```
