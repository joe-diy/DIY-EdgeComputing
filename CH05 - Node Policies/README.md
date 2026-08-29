# Chapter Five - Node Policies

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

Chapter four gave the hub a deployment policy — `$HZN_ORG_ID/policy-edge-ai`, one constraint, `purpose == edge-ai` — and any node that advertised that property picked up the workload on its own. That policy was the *service* side of the match. This chapter works the other side, and it needs a second Pi: one with a camera module attached, one without. Same deployment mechanics as chapter four; the difference is that the node now gets to refuse work its hardware cannot do.

## Two halves of the match

Chapter four was the service side of the agreement: a **deployment policy** attached to a service, saying *which nodes that service belongs on* by property constraint.

The node side is a **node policy**. The node advertises properties about *itself* — `camera == true`, `arch == arm64`, `ram_gb == 8` — and a service that declares a constraint only lands where that constraint holds against those properties. The agbot forms an agreement only when both are satisfied at once: the service's deployment policy has to want the node, and the node's own policy has to allow the service. Both sides opt in.

*Why?*

An image classifier on a camera-less Pi just logs errors forever — it deployed because it matched `purpose == edge-ai`, and nothing said it also needed a camera. Let the hardware declare what it is, and a service can ask for exactly the box it needs instead of any box that will take it.

## Set node properties

Chapter two wrote a `node.policy.json` with `purpose` and `model`. Extend that same file — keep those two lines exactly as they were, add `camera` and `ram_gb`:

```bash
cat > node.policy.json <<'EOF'
{
  "properties": [
    { "name": "purpose", "value": "edge-ai" },
    { "name": "model",   "value": "rpi5-8gb" },
    { "name": "camera",  "value": true },
    { "name": "ram_gb",  "value": 8, "type": "int" }
  ],
  "constraints": []
}
EOF
hzn policy update -f node.policy.json
hzn policy list | jq '.properties'
```

Do this on the camera Pi only; leave the second Pi with the chapter-two file, so `camera` is absent there.

`hzn policy update` replaces the node's live policy in place — no unregister / re-register like chapter two needed. `hzn policy list | jq '.properties'` reads it back so you can confirm all four are set. `purpose` and `model` are unchanged from chapter two; `camera` and `ram_gb` are new, and `ram_gb` carries an explicit `"type": "int"` so the hub compares it as a number rather than a string.

*Why?*

The node is the only thing that knows what is physically plugged into it. Writing that down as properties turns "which Pi has the camera" from something you keep in your head into something the agbot can evaluate — and it does so for every node at once, forever, without you maintaining a list.

## Constrain a service to it

Now the service side. Change the `constraints` line in the `deployment.policy.json` you made in CH04 to:

```json
"constraints": [ "purpose == edge-ai", "camera == true" ]
```

Then publish it under a new name so the chapter-four policy stays intact:

```bash
hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-camera"
hzn deploycheck all -b "$HZN_ORG_ID/policy-camera"
```

`addpolicy` creates `policy-camera` beside `policy-edge-ai` — the original still deploys wherever `purpose == edge-ai`. `hzn deploycheck all` is the wider dry-run: it evaluates the deployment policy, the service, *and* every node policy, and also folds in the user-input and secret-binding checks, then reports which nodes come out compatible. Expect the camera Pi to pass and the other to fail on `camera == true`, before any agreement exists.

*Why?*

The two constraints are `AND`-joined, so a node now needs *both* `purpose == edge-ai` and `camera == true`. The camera Pi advertises both; the bare Pi advertises only the first, so the expression is false there and the agbot never offers it an agreement. It is the chapter-four match with one more term — and that one term is enough to keep a camera workload off hardware that has no camera.

## Only the right Pi picks it up

Give the agbot a few minutes, then check both Pis:

```bash
# on the camera Pi:
hzn agreement list | jq 'length'   # -> 1
# on the other Pi:
hzn agreement list | jq 'length'   # -> 0
```

<!-- screenshot: agreements on the camera Pi only; the other stays clean -->

*Why?*

No manual placement; the fleet sorts itself. You did not pick the camera Pi by name — you described the hardware a camera service needs, both Pis reported what they actually have, and the one that matched got the workload. Add a third Pi with a camera and it joins the same agreement on its own; add ten without one and they stay clean.

## Next

On to [chapter six](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH06%20-%20Secrets%20Management#chapter-six---secrets-management) — because that service is pulling from a private registry with a credential you should not hardcode.
