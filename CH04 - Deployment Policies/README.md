# Chapter Four - Deployment Policies

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

Chapter two registered a Pi with the hub and gave it a `purpose` property. Chapter three, if you took it, moved that same Pi onto a hub you run. Either way you now have a node the hub can see, the four `HZN_*` variables exported in your shell, and nothing running on the Pi yet. This chapter gives the hub something to deploy — and never names the node it lands on.

## What a deployment policy is

A **deployment policy** attaches to a *service* and says *which nodes that service belongs on*. It says so by **property constraint** — "any node whose `purpose` is `edge-ai`" — never by hostname. You do not list nodes; you describe them.

The hub's **agbot** does the rest. It continuously matches every published service against every node's advertised properties, and wherever a policy's constraints are satisfied it forms an **agreement** with that node automatically. The agent on the node sees the agreement and starts the workload through its container engine.

*Why?*

You stop deploying to nodes. Nodes that match the description pull the workload themselves. Adding the 41st Pi is then zero extra work: register it with `purpose=edge-ai` and the agbot hands it the same agreement every other matching node already has. Nothing to edit, no list to append to, no rollout to babysit.

## A service to deploy

The policy needs a service to point at. So the chapter stands on its own, use a **published sample** rather than something you build here — the IBM `helloworld` service is tiny, multi-arch, and already in every exchange. List what is available:

```bash
hzn exchange service list -o IBM | jq '.[] | select(test("helloworld"))'
```

That prints the fully-qualified service names in the `IBM` org that contain `helloworld` — pick one (for example `ibm.helloworld`) and note its org (`IBM`). You will drop those two values into the policy below.

*Why?*

A published sample keeps this chapter about the *policy mechanics* and nothing else — there is no image to build, push, or version before the interesting part. Chapter seven swaps this sample for the real workload, an Ollama + Open WebUI service, and the policy it writes is the same shape as this one.

## Author and publish the policy

Write the policy as JSON, then push it into the exchange. Substitute the service name and org you chose above for `<service-name>` and `<service-org>` (for the IBM sample, `ibm.helloworld` and `IBM`):

```bash
cat > deployment.policy.json <<'EOF'
{
  "label": "edge-ai services",
  "description": "Runs on any node whose purpose is edge-ai",
  "service": {
    "name": "<service-name>",
    "org": "<service-org>",
    "arch": "*",
    "serviceVersions": [{ "version": "*" }]
  },
  "constraints": [ "purpose == edge-ai" ],
  "userInput": []
}
EOF
hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-edge-ai"
hzn exchange deployment listpolicy "$HZN_ORG_ID/policy-edge-ai"
```

`addpolicy` creates the policy in your org under the name `policy-edge-ai`; `listpolicy` reads it back so you can confirm the exchange stored what you sent. `arch` and `version` are both `*` here, so the policy is happy with any architecture and any published version of the service.

*Why?*

`constraints` is the whole point of the file. It is a boolean expression evaluated against a node's properties, and `purpose == edge-ai` matches the property set in chapter two's `node.policy.json`. The name has to line up exactly: the node advertises `purpose` with value `edge-ai`, the policy requires `purpose == edge-ai`, and the agbot only forms an agreement when the expression is true. Change either side and the match silently stops happening.

## Watch it deploy itself

Before waiting on the agbot, dry-run the match:

```bash
hzn deploycheck deployment -b "$HZN_ORG_ID/policy-edge-ai"   # dry-run compatibility
```

`deploycheck` asks the exchange "would this policy actually deploy anywhere, and if not, why not?" without forming an agreement — it reports the compatibility result for the service, the deployment policy, and any matching node policies. Fix whatever mismatch it reports before moving on.

Then register a node with `purpose=edge-ai` (the chapter-two node already has it; a fresh Pi just needs the same `node.policy.json`) and leave it alone. The agbot runs on its own schedule. Come back a few minutes later and list the node's agreements:

```bash
hzn agreement list | jq '.[] | {service: .workload_to_run.url, state: .agreement_finalized_time}'
```

An entry with a populated `agreement_finalized_time` is the service running on the node — placed there by the agbot, started by the agent, with nobody having touched the Pi.

<!-- screenshot: hzn agreement list showing the service running on a node that was never named -->

*Why?*

The node was selected by property. There was no target list, no `ssh`, no per-node command — you published a description and a node that fit it picked up the work. That is the pattern the rest of the book builds on: chapter seven uses this exact flow to push the AI stack onto every `edge-ai` node at once.

## Next

On to [chapter five](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH05%20-%20Node%20Policies#chapter-five---node-policies) — where the node itself gets a say in what lands on it.
