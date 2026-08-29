# Chapter Two - Open Horizon Fundamentals

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

## What Open Horizon is

By the end of chapter one you had a container engine (Docker or Podman) on a single Raspberry Pi. That is fine for one Pi. It does not survive contact with forty Pis in five buildings.

Open Horizon is two pieces that solve that:

- A **management hub**, running in the cloud or on your own hardware — an *exchange* that holds the catalog of nodes, services, and policies; an *agbot* (agreement bot) that continuously matches services to nodes; and a *CSS* (the model-management / file-sync service) that ships large files and models out to nodes.
- A lightweight **agent** called *anax* that runs on every edge node. It registers the node with the hub, negotiates agreements on the node's behalf, and starts, stops, and updates workloads through your container engine.

You never SSH into an edge node to deploy to it. You describe *what should run where* as policy in the hub, and every agent makes its own node match that description. Add a node and it converges on its own. Change a policy and the whole fleet follows.

*Why?*

SSH-per-node is a script you run by hand, once per box, every time anything changes. It works for three nodes and quietly falls apart somewhere around thirty — a node is powered off during the rollout, another has a slightly different OS image, a third fails half way through and nobody notices for a week. Open Horizon inverts it: the node pulls its desired state and keeps itself there, so the effort is flat in the number of nodes instead of growing with it.

## What you need

This book does not host a hub for you. You need four values from a hub provider — the **LF Edge Community Lab** runs a free hub that is fine for learning, or your company may run its own for production. Chapter three covers standing up your own; for now, get these from whoever runs your hub and export them in the shell on the Pi:

```bash
# From your hub provider (LF Edge Community Lab free hub, or your company hub):
export HZN_ORG_ID=<your-org>
export HZN_EXCHANGE_URL=<https://.../v1>
export HZN_FSS_CSSURL=<https://.../>
export HZN_EXCHANGE_USER_AUTH=<user>:<apikey-or-password>
```

- `HZN_ORG_ID` — the organization you were given in the hub's exchange. Every node, service, and policy lives inside an org.
- `HZN_EXCHANGE_URL` — the exchange API endpoint, ending in `/v1`.
- `HZN_FSS_CSSURL` — the CSS / model-management endpoint. The installer refuses to run without it.
- `HZN_EXCHANGE_USER_AUTH` — your credentials as `user:password` or `user:apikey`, used to authenticate the node's self-registration.

*Why?*

The hub is shared infrastructure with its own lifecycle — TLS certificates, backups, upgrades, an on-call. Off-loading that to the community lab hub while you learn keeps the moving parts down to the one you are actually studying: the agent on the Pi. When you move to production you point these same four variables at a company hub and nothing else in this chapter changes.

## Install the agent

The Open Horizon project ships an installer that detects the Pi's architecture, installs the `horizon` and `horizon-cli` packages, writes the agent configuration, and registers the node — all in one pass. Run it on the Pi, in the same shell where you exported the four variables above:

```bash
# On the Raspberry Pi:
curl -sSL https://raw.githubusercontent.com/open-horizon/anax/master/agent-install/agent-install.sh -o agent-install.sh
chmod +x agent-install.sh
sudo -E ./agent-install.sh -O "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH" -i 'anax:'
```

The flags:

- `-E` is a `sudo` flag, not a script flag — it preserves your environment (the `HZN_*` variables) into the root process. Without it, `sudo` scrubs the environment and the script stops almost immediately asking for `HZN_FSS_CSSURL`.
- `-i 'anax:'` tells the installer where to get the agent packages: the trailing colon with no version after it means "the latest packages from the official open-horizon repository."
- `-O "$HZN_ORG_ID"` is the org to register the node into.
- `-u "$HZN_EXCHANGE_USER_AUTH"` is the credential the installer uses to create the node in the exchange.

When it finishes, the last line should read:

> *Horizon node is registered. Workload agreement negotiation should begin shortly.*

<!-- screenshot: agent-install.sh success output on the Pi -->

*Why?*

The installer is doing three separable jobs — package install, agent configuration, node registration — in one command, because for a first node you want all three. Later chapters split them apart: a fleet-wide node-management policy handles package upgrades, and you re-run just the registration step with different policy files as you tune what the node advertises.

## Verify and register with a node policy

Check that the agent is installed and the node reached the hub:

```bash
hzn version
hzn node list | jq '.configstate.state'   # -> "configured"
```

`"configured"` means the agent registered and is in contact with the exchange. The installer usually registers the node for you with a default policy; unregister and re-register to attach an explicit **node policy** so the node advertises properties the hub can match against:

```bash
cat > node.policy.json <<'EOF'
{
  "properties": [
    { "name": "purpose", "value": "edge-ai" },
    { "name": "model", "value": "rpi5-8gb" }
  ],
  "constraints": []
}
EOF
# The installer may have already registered the node with a default policy.
# Unregister first so you can re-register with your own:
hzn unregister -f -r
hzn register --policy node.policy.json
hzn node list | jq '{id: .id, org: .organization, state: .configstate.state}'
```

<!-- screenshot: the node appearing online in the hub web UI -->

*Why?*

`properties` are how the node describes itself to the hub — `purpose` is `edge-ai` here, and `model` records the board. `constraints` is empty for now, so this node will accept any service aimed at it. Later chapters work the other side of the match: chapter four publishes a deployment policy that targets `purpose == edge-ai`, and chapter five adds constraints here so the node itself gets a say in what lands on it. Nobody ever names this node; the hub finds it by its properties.

## Troubleshooting

- **`Error: HZN_FSS_CSSURL must be specified`** right after you start the installer — you dropped the `-E` from `sudo -E`, so `sudo` cleared the `HZN_*` variables. Re-run with `sudo -E`.
- **`packages not found`, or the installer cannot locate an install package** — the `-i 'anax:'` argument is missing or mistyped. The trailing colon is required.
- **The node never reaches `configured`, or you want to re-register from a clean state** — run the registration by hand:

  ```bash
  hzn register -o "$HZN_ORG_ID" -u "$HZN_EXCHANGE_USER_AUTH"
  ```

## Next

On to [chapter three](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH03%20-%20Hosting%20Your%20Own%20Hub#chapter-three---hosting-your-own-hub) if you want to run the hub yourself — **optional**. To stay on the shared hub, skip straight to [chapter four](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH04%20-%20Deployment%20Policies#chapter-four---deployment-policies).
