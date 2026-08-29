# Chapter Three - Hosting Your Own Hub

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

**Optional. Skip this and stay on the shared hub from CH02 — you rejoin the main path at CH04 either way. Take it if you need full control over where fleet data lives.**

## What you're standing up

Chapter two pointed the Pi's agent at a hub that somebody else runs. This chapter runs that hub yourself, on your own hardware.

A management hub is three container workloads plus a database:

- **exchange** — the API and the policy store. Every node, service, and deployment policy you create lives here.
- **agbot** — the agreement bot that continuously matches services to nodes.
- **CSS** — the Cloud Sync Service, which distributes files and models out to the nodes.
- a **database** behind the exchange that holds all of that state.

You need one thing this book has not asked for yet: a second always-on 64-bit Linux host — a NUC, a spare server, a cloud VM — with your container engine and `docker compose` (or `podman compose`) installed. **Not** the Pi. The Pi stays an edge node; the hub is a separate machine that has to be reachable whenever any node might need it.

*Why?*

Four reasons to take this branch. **Data residency** — the exchange records every node you own and every policy you write, and on your own hub that inventory never leaves your premises. **Offline operation** — a hub on the same LAN as the fleet keeps working when the building's internet does not. **Cost predictability** — there is no per-node or per-call pricing to model as the fleet grows. **Independence** — nobody else's maintenance window, upgrade schedule, or policy change can touch your fleet. The trade is that TLS certificates, backups, sizing, and upgrades are now your job; this chapter gets the stack running and marks those as beyond its scope.

## Bring the stack up

Run these on the second host, not on the Pi. The Open Horizon project ships an all-in-one script that pulls the exchange, agbot, CSS, and database images and brings them up together:

```bash
curl -sSL https://raw.githubusercontent.com/open-horizon/devops/master/mgmt-hub/deploy-mgmt-hub.sh -o deploy-mgmt-hub.sh
chmod +x deploy-mgmt-hub.sh
./deploy-mgmt-hub.sh
```

The script starts the stack with `docker compose` (or `podman compose`) on this host. When it finishes it prints a completion banner with the generated admin credentials, the exchange root password, and the service URLs. Copy all of it somewhere safe. Then export the three URLs — substitute this host's IP address or hostname for `<this-host-ip>` — and check that the exchange answers:

```bash
export HZN_EXCHANGE_URL=http://<this-host-ip>:3090/v1
export HZN_FSS_CSSURL=http://<this-host-ip>:9443/
export HZN_AGBOT_URL=http://<this-host-ip>:3111
hzn exchange version
```

`hzn exchange version` printing a version number is the hub answering — the exchange is up and reachable at that URL. `HZN_ORG_ID` and `HZN_EXCHANGE_USER_AUTH` now come from this banner too (the generated admin org and credentials), not from the shared hub you used in chapter two.

<!-- screenshot: deploy-mgmt-hub.sh completion banner with URLs and credentials -->

*Why?*

One script, because this book is about running edge workloads, not operating a hub. `deploy-mgmt-hub.sh` is the Open Horizon project's own installer, and leaning on it keeps the chapter from turning into a hub-operations manual. Production sizing, TLS termination, off-host database backups, and version upgrades are all real work and all beyond this chapter — start from the project's deployment documentation when you take this past a bench.

## Point an agent at your hub

Your Pi from chapter two is registered against the shared hub. Move it to your own hub by unregistering it and re-running the chapter-two installer with the new `HZN_*` values in the environment:

```bash
hzn unregister -f -r
sudo -E ./agent-install.sh -O "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH" -i 'anax:'
hzn unregister -f -r
hzn register --policy node.policy.json   # re-attach the chapter-two node policy
hzn node list | jq '.configstate.state'
```

`hzn unregister -f -r` detaches the node from the old hub: `-f` forces it through even if agreements are active, and `-r` removes the node's record from that exchange. The `agent-install.sh` line is byte-for-byte the chapter-two command — the only things that changed are `HZN_EXCHANGE_URL`, `HZN_FSS_CSSURL`, and `HZN_AGBOT_URL` in the shell it inherits through `sudo -E`. The second `hzn unregister -f -r` / `hzn register --policy node.policy.json` pair is the same move chapter two made: the installer registers the node with its default policy, so you unregister and re-register against your `node.policy.json`. When `hzn node list` reports `"configured"`, the Pi is talking to your hub.

*Why?* re-registering against a new hub starts from the installer's default policy — re-attach the chapter-two node policy or nothing from chapter four on will match, with no error to tell you.

<!-- screenshot: the Pi registered in your own hub UI -->

*Why?*

Everything from chapter four on — deployment policies, node policies, secrets, the AI service — works identically whether the hub is yours or the community's. Only the `HZN_*` URLs differ. That is why standing your own hub up here is worth it rather than later: do it once, keep the same URLs exported from now on, and nothing else in the book changes.

## Next

On to [chapter four](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH04%20-%20Deployment%20Policies#chapter-four---deployment-policies) — deployment policies work identically against your hub or the shared one.
