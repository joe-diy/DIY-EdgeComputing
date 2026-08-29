# Chapter Six - Secrets Management

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

Chapter five constrained a service to the hardware it needs, and left one thread hanging: that service pulls its image from a **private registry**, and a private registry wants a login. This chapter puts that login somewhere the fleet can reach it and git cannot — the Open Horizon secrets manager — binds it to the service, and then rotates it without touching a single node.

## The problem with the obvious approach

A private image needs a registry credential to pull it. There are two obvious places to put that credential, and both are wrong:

- **In the service definition.** The service definition and deployment policy are JSON files you keep in version control. The credential goes in with them, and now your registry token is in git history forever — including on every fork and every clone made before you noticed.
- **In the image.** Bake it into a layer and it ships, in the clear, to every node that pulls the image — sitting on disk on hardware you may not physically control.

*Why?*

Credentials committed to a repo get scraped within minutes of that repo going public — bots watch the push firehose for exactly this. And even when the repo stays private, both approaches tie the credential's lifetime to a rebuild or a re-registration: rotating it means editing a file, re-publishing, and re-deploying across the whole fleet. What you want instead is a credential that lives in one place, is readable only by the workloads entitled to it, and rotates without rebuilding or re-registering anything.

## Store the credential

The management hub runs a Vault-backed secrets manager, and `hzn secretsmanager` is the CLI front end to it. Store the registry login as an **org-scoped** secret, with the value shaped as a small JSON object the service can parse:

```bash
printf '{ "auth": "%s:%s" }' "$REGISTRY_USER" "$REGISTRY_TOKEN" \
  | hzn secretsmanager secret add --secretName registry-pull --secretFile -
hzn secretsmanager secret list
hzn secretsmanager secret read --secretName registry-pull   # metadata, not the value
```

`--secretFile -` reads the secret body from stdin, so the credential never lands in a file on disk or as a literal argument in your shell history. `secret list` shows `registry-pull` alongside any other secrets in the org; `secret read` returns the secret's *metadata* — name, creation time, version — and not the value. The value only ever leaves the hub to be mounted into a container that a binding authorises.

*Why?*

The secret is scoped to the **org**, not to your user. An org secret is bindable by any deployment policy in that org — which is what you need here, because the service is placed by a policy, not by you personally. A **user** secret is private to your account and cannot be bound by a policy that someone else's automation runs. Org scope is the sharing boundary that matches how the workload is actually deployed.

## Bind it to a service

Storing the secret does not, on its own, give anything access to it. A **secret binding** does that — it maps a name the container expects to a secret in the manager. Add a `secretBinding` block to the service definition (or to the deployment policy):

```json
"secretBinding": [
  {
    "serviceOrgid": "<org>",
    "serviceUrl": "<service-name>",
    "secrets": [ { "registry-auth": "<org>/registry-pull" } ]
  }
]
```

`serviceOrgid` and `serviceUrl` say *which service* this binding applies to; `secrets` is the map. The key `registry-auth` is the name the workload knows; the value `<org>/registry-pull` is the org-qualified secret it resolves to. When the agent forms an agreement for this service, it reads `$HZN_ORG_ID/registry-pull` from the manager and mounts it inside the container at:

```
/open-horizon-secrets/registry-auth
```

— the mount path is `/open-horizon-secrets/` plus the binding key. The agent uses that credential for the image pull directly; a service that then pulls further images of its own can read the same file and authenticate to the registry (`docker login` / `podman login`) at start-up. Verify the mount from the node:

```bash
hzn service configstate list
# exec into the running container:
cat /open-horizon-secrets/registry-auth
```

`configstate list` confirms the service is running under an agreement; the `cat` inside the container shows the `{ "auth": "..." }` object exactly as you stored it — delivered as a file rather than an environment variable, so it never turns up in `ps` output or a process's `/proc/*/environ`.

*Why?*

The binding is the only thing that connects a workload to a secret, and it is declared per service. A workload with no binding for `registry-pull` cannot read it even though the secret sits in the same org. The credential is delivered as a file mount, decrypted only on the node that won the agreement, and only for as long as that agreement holds.

## Rotate it, tell nobody

Rotation is the same command that created the secret — `secret add` against a name that already exists writes a new version:

```bash
printf '{ "auth": "%s:%s" }' "$REGISTRY_USER" "$NEW_REGISTRY_TOKEN" \
  | hzn secretsmanager secret add --secretName registry-pull --secretFile -
```

The agent polls the secrets manager on its regular cycle. On the next poll after the new version lands, it re-reads `registry-pull` and updates the mounted file in place — same container, same agreement, no `hzn register`, no image rebuild, no redeploy. A workload that reads the file on each pull picks up the new credential on its next pull; one that logged in once at start-up gets the new value the next time it is restarted.

<!-- screenshot: secret value inside the container changing after a rotate, same container ID -->

*Why?*

Rotating a credential the old way — baked into an image or a service definition — is a fleet-wide maintenance window: rebuild, re-publish, re-deploy, then confirm every node caught up. Here it is a one-liner against the hub, and the fleet reconciles itself. The blast radius of a leaked token drops from "whenever we next schedule a rollout" to "one command, now."

## Next

On to [chapter seven](https://github.com/joe-diy/DIY-EdgeComputing/tree/master/CH07%20-%20Deploying%20Local%20AI#chapter-seven---deploying-local-ai) — the payoff: a real LLM running on the Pi, its image pulled with the credential you just secured.
