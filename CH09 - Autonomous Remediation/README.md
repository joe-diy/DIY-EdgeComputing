# Chapter Nine - Autonomous Remediation

> ⚠️ **Not yet hardware-verified.** The commands and screenshots in this chapter were drafted from documentation and are pending a validation pass on a real Raspberry Pi bench. See `docs/video/HARDWARE-VERIFICATION.md`.

*`service-edge-ai` stops at advice on purpose — every proposal carries `requires_human_review: true` and it never touches your workloads. This chapter builds the missing piece: a small, auditable executor that reads those proposals and acts on the safe ones.*

Chapter eight turned a crash into a file on disk: a root-cause guess, a severity, a confidence score, written by a local model while you were asleep. Useful — but you still had to wake up, read it, and type the fix. The monitor is advisory by design; it will never be anything else. So the loop stays open until *you* close it. This chapter closes it, with maybe forty lines of shell and a deliberately narrow definition of "safe".

## The gate

You do not want a model with `sudo`. The whole risk of this chapter lives in one decision — *when is a proposal allowed to trigger an action* — so the gate is strict and it is the same three checks every time. The executor acts only when **all** of these hold:

- `severity` is `high` or `critical` — nothing else is urgent enough to act on unattended.
- `confidence >= 0.9` — the model has to be almost certain, not merely leaning.
- `root_cause` matches a known, **reversible** pattern — a container that exited, an OOM kill, a crash, a service that is "not running". These are the cases where the fix is a restart and a wrong call costs one restart.

A proposal that clears severity and confidence but describes something outside that pattern list — a disk filling up, a config typo, a bad upstream dependency — is **logged and left for a human**. So is every proposal that misses severity or confidence. The executor never guesses at a fix it does not have a canned, safe response for.

*Why?*

Bounded autonomy. The blast radius of a wrong call is one `docker restart`, not a fleet. Everything the executor is *allowed* to do, it can also undo — and everything it is not sure about, it hands back to you with the reasoning attached. That is the trade that makes running it unattended defensible: it is not "trust the model", it is "the model can only reach for the one lever that has no sharp edge".

## The executor: remediate.sh

The whole thing is one script. It reads the proposals CH08 writes under `/var/lib/monitor/proposals/<workload>/<key>.json`, applies the gate, and appends one line per proposal to an action log. Nothing it does is hidden — `actions.log` is the complete record of every decision it made and why.

```bash
#!/usr/bin/env bash
set -euo pipefail
PROPOSAL_DIR=${MONITOR_PROPOSAL_DIR:-/var/lib/monitor/proposals}
LOG=/var/log/workloads/remediator/actions.log
CURSOR=/var/log/workloads/remediator/.cursor
# The fallback re-registers the node from its chapter-two node policy. Make that
# file readable at this path inside the container, or set NODE_POLICY to where
# you mounted it — the CH02 policy is written to your working directory, not here.
NODE_POLICY=${NODE_POLICY:-/var/horizon/node.policy.json}
mkdir -p "$(dirname "$LOG")"

# First-run guard: if the cursor is missing, create it with a 1970 mtime so the
# first pass sees every existing proposal and `find -newer` does not error.
[[ -e "$CURSOR" ]] || touch -t 197001020000 "$CURSOR"

find "$PROPOSAL_DIR" -name '*.json' -newer "$CURSOR" 2>/dev/null | while read -r f; do
  IFS=$'\t' read -r sev conf review cause svc < <(jq -r '[.severity, .confidence, .requires_human_review, .root_cause, .metadata.service_name] | @tsv' "$f")
  if [[ "$sev" =~ ^(high|critical)$ ]] && (( $(echo "$conf >= 0.9" | bc -l) )); then
    case "$cause" in
      *"exited"*|*"OOM"*|*"not running"*|*"crash"*)
        echo "$(date -Is) RESTART $svc (conf=$conf) :: $cause" >> "$LOG"
        docker restart "$(docker ps -a --filter "name=$svc" -q)" || { hzn unregister -f && hzn register --policy "$NODE_POLICY"; } || true ;;
      *)
        echo "$(date -Is) SKIP $svc unknown cause :: $cause" >> "$LOG" ;;
    esac
  else
    echo "$(date -Is) HOLD $svc sev=$sev conf=$conf review=$review" >> "$LOG"
  fi
done
touch "$CURSOR"
```

Walking it branch by branch:

- **The cursor.** `find ... -newer "$CURSOR"` only picks up proposal files modified since the last run, so a proposal is acted on once, not on every pass. `touch "$CURSOR"` at the end advances the mark. The first-run guard above it creates the cursor with a 1970 timestamp when it is absent — without that, the very first run has nothing to compare against and `find -newer` errors out; with it, the first pass correctly sees every proposal already on disk. `CURSOR` sits under `/var/log/workloads/remediator/` — the same `:rw` mount as `actions.log`, created by the same `mkdir -p` — on purpose: it has to survive the container restart a remediation triggers. On the container's ephemeral `/tmp` every restart would lose the cursor, the first-run guard would re-seed it at 1970, and the executor would re-act on every proposal still on disk (CH08 rewrites proposals in place and never deletes them) — a restart loop.
- **The field read.** `jq -r '[.severity, .confidence, .requires_human_review, .root_cause, .metadata.service_name] | @tsv'` pulls **exactly** the five fields CH08's schema promises — `severity`, `confidence`, `requires_human_review`, `root_cause`, `metadata.service_name` — as one tab-separated line. `IFS=$'\t' read -r sev conf review cause svc` then splits that line on tabs *only*. This matters: CH08's `root_cause` is a full sentence with spaces in it ("The open-webui process received SIGKILL; the container was terminated externally…"), so a plain `read` under the default `IFS` would split it on the first space — `cause` would get just "The" and the reversible-pattern `case` below would never match. Pinning `IFS` to the tab keeps each field whole. Nothing else in the proposal is consulted. `review` is read only so it can be echoed into the HOLD line for you; the executor's own gate is stricter than `requires_human_review` alone, so it does not branch on it.
- **The gate.** `[[ "$sev" =~ ^(high|critical)$ ]] && (( $(echo "$conf >= 0.9" | bc -l) ))` is the severity-and-confidence check from the section above. `bc -l` does the floating-point compare that bash cannot; it prints `1` or `0`, and `(( ... ))` turns that into the branch. Fail this and you fall through to **HOLD**.
- **RESTART.** The `case` matches `root_cause` against the reversible-pattern globs (`*exited*`, `*OOM*`, `*not running*`, `*crash*`). On a match it writes a `RESTART` line, then tries two recovery paths in order. First, a best-effort direct restart: `docker ps -a --filter "name=$svc" -q` looks for a container whose name contains the Horizon *service* name. Often it finds nothing — the running container is named for the image or carries an agreement-id prefix (`edge-ai-chat`'s is `open-webui`), not the service — in which case `docker restart` gets an empty argument and fails. That failure is expected, and the `||` hands off to the path that does the real work on a Horizon node: `hzn unregister -f && hzn register --policy "$NODE_POLICY"` re-registers the node, the agbot re-forms the agreement, and the agent rebuilds the workload from the service definition — which also recovers cases a restart never could (a removed container, a cancelled agreement). `NODE_POLICY` defaults to `/var/horizon/node.policy.json`, but the CH02 node policy is written to *your working directory*, so you must copy it to that path — or point `NODE_POLICY` at wherever you mounted it — and make it readable inside the remediator container; otherwise the fallback re-registers with no policy and nothing from chapter four on will match. The trailing `|| true` on the whole compound is deliberate: under `set -euo pipefail`, if *both* the restart and the re-register fail, an unguarded compound would fail the `while` body, kill the subshell, and skip every remaining proposal in the pass — and `touch "$CURSOR"` would still run, so those proposals would never be re-seen. `|| true` keeps the loop alive for the next proposal.
- **SKIP.** The `*)` default arm of the `case`: severity and confidence cleared the gate, but `root_cause` is not one of the patterns the executor knows how to safely reverse. It writes a `SKIP ... unknown cause` line and does nothing else. This is the "urgent but not canned" bucket — it needs a human, now, but the executor will not improvise.
- **HOLD.** The `else` of the gate: severity is below `high`, or confidence is under `0.9`. It writes a `HOLD` line recording `sev`, `conf` and `review` so you can see at a glance why it stayed its hand, and moves on. The 2 a.m. low-confidence proposals pile up here for your morning.

### On a Podman host

The script is written with `docker`. On a Podman node, `docker restart` becomes `podman restart` and `docker ps` becomes `podman ps` — the flags and output are identical, so it is a straight substitution. The service that runs the script (next section) must then mount the **Podman** socket (`/run/podman/podman.sock`, or the rootless `$XDG_RUNTIME_DIR/podman/podman.sock`) in place of `/var/run/docker.sock`.

## Deploy it as a service

Running `remediate.sh` from your shell proves the logic. To actually close the loop it has to run on the node, on a timer, with no one logged in — so it ships as its own tiny Open Horizon service, `edge-ai-remediator`, placed by the same policy mechanics as everything since chapter four.

The service is one container whose entrypoint runs `remediate.sh` in a loop (`while true; do remediate.sh; sleep "${REMEDIATE_INTERVAL:-120}"; done`), with three binds:

```json
{
  "org": "<org>",
  "url": "edge-ai-remediator",
  "version": "1.0.0",
  "arch": "arm64",
  "deployment": {
    "services": {
      "remediator": {
        "image": "<org>/edge-ai-remediator:1.0.0",
        "privileged": true,
        "environment": [ "REMEDIATE_INTERVAL=120" ],
        "binds": [
          "/var/lib/monitor/proposals:/var/lib/monitor/proposals:ro",
          "/var/log/workloads:/var/log/workloads:rw",
          "/var/run/docker.sock:/var/run/docker.sock:rw"
        ]
      }
    }
  }
}
```

- `/var/lib/monitor/proposals:ro` — it reads CH08's proposals and must never be able to alter them. Read-only.
- `/var/log/workloads:rw` — it appends to `actions.log`. This is the same shared mount CH08 already uses.
- `/var/run/docker.sock` — how `docker restart` inside the container reaches the engine on the host.

`remediate.sh` shells out to `jq`, `bc`, and `docker` (or `podman`), so the `edge-ai-remediator` image you build has to bundle all three — a bare `busybox` base will not do. You build this image, so that is a build-time requirement, not a bench check.

Publish it and let the deployment policy place it:

```bash
hzn exchange service publish -f remediator.service.json
# a deployment policy binds to one service, so the remediator gets its own —
# same one constraint as the CH04 policy, so it lands on every edge-ai node:
hzn exchange deployment addpolicy -f deployment.policy.json "$HZN_ORG_ID/policy-edge-ai-remediator"
hzn deploycheck all -b "$HZN_ORG_ID/policy-edge-ai-remediator"
```

Reuse chapter four's `deployment.policy.json` unchanged except for the `service` block naming `edge-ai-remediator`; the constraint stays `purpose == edge-ai`, so the remediator deploys itself onto exactly the nodes already running `edge-ai-chat` and the monitor.

*Why?*

Mounting the container socket into a container is the sharp edge in this whole chapter. A process that can talk to `/var/run/docker.sock` can start, stop, and replace **any** container on the host, and mount host paths into new ones — it is root on the node in all but name. That is the price of letting the executor act at all, and it is why the executor is deliberately small enough to read in one sitting, why its only write mount is the log, and why every action it takes is an append-only line you can audit after the fact.

It is also why this is scoped to **one node**. The deployment policy places an independent copy of the executor on each matching node, and each copy only ever touches its *own* node's socket and its *own* node's proposals. There is no central service holding every node's socket; a compromised or misbehaving executor can wreck the node it runs on and no other. You roll this out one node at a time, having decided per node that the trade is worth it — not fleet-wide from a single policy without thinking about it.

## Watch it heal

```bash
# everything green:
hzn agreement list | jq 'length'
# break it:
docker kill $(docker ps --filter name=open-webui -q)   # or: podman kill $(podman ps --filter name=open-webui -q)
# hands off the keyboard. CH08 writes a proposal; the remediator reads it:
tail -f /var/log/workloads/remediator/actions.log
# -> RESTART edge-ai-chat ... ; service returns to green
curl -sS http://<pi-ip>:8080/health | jq '.healthy'
```

Kill the container, then do not touch the keyboard. On its next 60-second poll the monitor notices `open-webui` is gone, tails the log, and — after the minutes of local analysis CH08 warned you about — writes a proposal with `severity: critical` and a `root_cause` line about the container exiting. Within `REMEDIATE_INTERVAL` of that, `remediate.sh` reads it, the gate passes, the `case` matches, and a `RESTART edge-ai-chat` line appears in `actions.log`. The agent brings the container back; `hzn agreement list` and the health endpoint go green again.

<!-- screenshot: actions.log RESTART line + health back to true, no hands on keyboard -->

*Why?*

The 3 a.m. OOM crash is now a log line and a recovered service, and the low-confidence cases still wait for you. You did not lose the human judgement — you moved it off the critical path for the one class of failure where the right answer is always the same, and kept it for everything else.

## Next

That is the build: a Pi that runs AI and heals itself. From here — add nodes and let the policies place everything; wire `service-edge-ai`'s [northbound export](https://github.com/joewxboy/service-edge-ai) to your issue tracker; or raise the executor's confidence gate as you learn which fixes are safe. Join the [Open Horizon community](https://github.com/open-horizon) and tell us what you built.
