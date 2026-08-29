# Chapter Seven - Deploying Local AI

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

**This chapter needs a Raspberry Pi 4 or 5 with 8 GB RAM. A 3B model quantised to 4-bit needs ~2 GB plus runtime; inference is seconds-to-minutes per prompt on a Pi, not instant. On 8 GB that is tight alongside the monitor from CH08 — use `llama3.2:1b` if you hit the memory ceiling.**

Chapter six put a registry credential in the hub's secrets manager and bound it to a service without ever committing it to git. Everything since chapter four has been machinery — deployment policies, node properties, secrets — pointed at a workload we deliberately kept generic. This chapter makes the workload real: a language model running on the Pi itself, answering prompts with the network cable pulled out.

## What you're deploying

Two containers, shipped as **one** Open Horizon service:

- **Ollama** (`ollama/ollama`) — the model runtime. It serves the model over HTTP on port `11434` and pulls the model weights on first start.
- **Open WebUI** (`ghcr.io/open-webui/open-webui`) — a browser chat front-end, pointed at Ollama over the service's internal network and published on port `3000`.

One `hzn` deploy brings up both. The reader never runs a container by hand; the service definition names the images and the agent on the Pi starts them through its container engine, exactly as it did for the sample service in chapter four.

*Why?*

Every cloud AI tutorial ends at "and now you call the API" — your prompts leave the building, you pay per token, and no connectivity means no AI. Local inference fixes all three at once: the weights sit on hardware you control, there is no per-token meter running, and the model answers whether or not the Pi can see the internet.

## The service definition

```json
{
  "org": "<org>",
  "url": "edge-ai-chat",
  "version": "1.0.0",
  "arch": "arm64",
  "deployment": {
    "services": {
      "ollama": {
        "image": "ollama/ollama:latest",
        "environment": [ "OLLAMA_HOST=0.0.0.0" ],
        "ports": [ { "HostPort": "11434", "HostIP": "0.0.0.0" } ]
      },
      "open-webui": {
        "image": "ghcr.io/open-webui/open-webui:main",
        "environment": [ "OLLAMA_BASE_URL=http://ollama:11434" ],
        "ports": [ { "HostPort": "3000", "HostIP": "0.0.0.0" } ]
      }
    }
  },
  "userInput": [
    { "name": "OLLAMA_MODEL", "label": "model to pull", "type": "string", "defaultValue": "llama3.2:3b" }
  ]
}
```

Both `services` run on the same Docker network, so Open WebUI reaches the runtime at `http://ollama:11434` by service name — that is the `OLLAMA_BASE_URL` value. `OLLAMA_HOST=0.0.0.0` makes the runtime listen on all interfaces so the published `11434` port is reachable from the LAN, not just from inside the container. `userInput` exposes one knob, `OLLAMA_MODEL`, defaulting to `llama3.2:3b`; a node that needs the smaller model overrides it at registration time without touching this file.

If either image lives in a private registry, add the `secretBinding` block from chapter six referencing `<org>/registry-pull` — same shape, mounted at `/open-horizon-secrets/registry-auth`. The two images above are both public, so the binding is optional here, but the same pattern applies the moment you swap in a private model image.

*Why?*

Bundling the runtime and the UI into a single service means one agreement, one lifecycle, one thing to opt in to monitoring later. Split them into two services and you would be managing two deployments and the network plumbing between them by hand.

## Publish and deploy it

Chapter four's `deployment.policy.json` pointed at a published sample. Open that same file and change the `service` block to name this one:

```json
"service": {
  "name": "edge-ai-chat",
  "org": "<org>",
  "arch": "arm64",
  "serviceVersions": [{ "version": "1.0.0" }]
}
```

Leave the `constraints` line as `purpose == edge-ai` — the node from chapter five already advertises that property. Then publish the service and re-publish the policy under its existing name:

```bash
hzn exchange service publish -f service.definition.json
# reuse the CH04 deployment policy — point it at edge-ai-chat:
hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-edge-ai"
hzn deploycheck all -b "$HZN_ORG_ID/policy-edge-ai"
# on the Pi (purpose=edge-ai from CH02): agreement forms, images pull, model pulls
hzn agreement list | jq '.[].workload_to_run.url'
```

`deploycheck all` dry-runs the whole match — service, deployment policy, node policy — before any agreement exists. Once the agbot forms the agreement, the agent pulls both images and then Ollama pulls the model; the first model pull takes a while on a Pi.

<!-- screenshot: ollama pull progress in hzn service log -->

*Why?*

The policy, the constraint and the node property are all unchanged from chapter four — only the service name moved. The same agbot match that placed a one-container sample now places a two-container LLM stack, on every `edge-ai` node at once. Nothing about the placement mechanism had to be told the workload got heavier.

## Talk to it — offline

```bash
# from a laptop on the same LAN:
open http://<pi-ip>:3000        # create the local account, pick the model
# sanity-check the raw API:
curl -s http://<pi-ip>:11434/api/generate -d '{"model":"llama3.2:3b","prompt":"one-sentence hello","stream":false}' | jq -r .response
```

The first call creates a local Open WebUI account (it stays on the Pi) and lets you pick the model that was pulled. The `curl` hits Ollama's HTTP API directly and prints just the generated text — proof the runtime is answering without the UI in the loop.

Now disconnect the internet — pull your router's WAN cable, or otherwise cut the LAN's uplink; leave the Pi and your laptop on the same switch, so the browser still reaches `http://<pi-ip>:3000` but the Pi can no longer phone home. Ask it another question through the chat UI. It answers.

<!-- screenshot: chat answering with the Wi-Fi indicator off -->

*Why?*

The model, the weights and the inference all live on the Pi; the network was only ever carrying your keystrokes.

## Next

On to [chapter eight](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH08%20-%20Detecting%20Problems#chapter-eight---detecting-problems) — what happens when this crashes at 3 a.m. and nobody is watching?
