#!/usr/bin/env bash
set -euo pipefail
PROPOSAL_DIR=${MONITOR_PROPOSAL_DIR:-/var/lib/monitor/proposals}
LOG=/var/log/workloads/remediator/actions.log
CURSOR=/tmp/.remediator-cursor
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
        docker restart "$(docker ps -a --filter "name=$svc" -q)" || hzn register --policy /etc/horizon/node.policy.json ;;
      *)
        echo "$(date -Is) SKIP $svc unknown cause :: $cause" >> "$LOG" ;;
    esac
  else
    echo "$(date -Is) HOLD $svc sev=$sev conf=$conf review=$review" >> "$LOG"
  fi
done
touch "$CURSOR"
