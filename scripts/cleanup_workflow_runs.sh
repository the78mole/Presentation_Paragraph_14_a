#!/bin/bash
set -e

# Standardwerte
WORKFLOW_NAME="Build LaTeX document"
KEEP=2
DRY_RUN=false

show_help() {
  cat <<EOF
Usage: $(basename "$0") [options]

Options:
  -w, --workflow NAME     Name des Workflows (default: "$WORKFLOW_NAME")
  -k, --keep N            Anzahl der zu behaltenden Runs (default: $KEEP)
  -n, --dry-run           Zeigt nur an, was gelöscht würde
  -h, --help              Zeigt diese Hilfe an

Beispiel:
  $(basename "$0") -w "Build LaTeX document" -k 3 -n
EOF
}

# Argumente parsen
while [[ $# -gt 0 ]]; do
  case "$1" in
    -w|--workflow)
      WORKFLOW_NAME="$2"
      shift 2
      ;;
    -k|--keep)
      KEEP="$2"
      shift 2
      ;;
    -n|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "❌ Unbekannte Option: $1"
      show_help
      exit 1
      ;;
  esac
done

# Tool-Checks
if ! command -v gh &> /dev/null; then
  echo "❌ GitHub CLI (gh) ist nicht installiert."
  exit 1
fi

if ! gh auth status &> /dev/null; then
  echo "❌ Nicht bei GitHub CLI angemeldet. Bitte führe 'gh auth login' aus."
  exit 1
fi

echo "🧹 Bereinige Workflow: '$WORKFLOW_NAME' | Behalte: $KEEP | Dry-Run: $DRY_RUN"

# Alle Runs holen (alle Triggerarten, alle Branches/Tags)
RUNS=$(gh run list --limit 100 --json databaseId,createdAt,workflowName \
  --jq 'sort_by(.createdAt) | reverse | .[] | select(.workflowName == "'"$WORKFLOW_NAME"'") | .databaseId')

COUNT=0
for RUN_ID in $RUNS; do
  COUNT=$((COUNT+1))
  if [ "$COUNT" -le "$KEEP" ]; then
    echo "✅ Behalte Run #$RUN_ID"
  else
    if $DRY_RUN; then
      echo "💡 [Dry-Run] Würde Run #$RUN_ID löschen"
    else
      echo "🗑️  Lösche Run #$RUN_ID"
      gh run delete "$RUN_ID"
    fi
  fi
done

if $DRY_RUN; then
  echo "✅ Dry-Run abgeschlossen. Keine Runs gelöscht."
else
  echo "✅ Fertig: $((COUNT - KEEP)) Run(s) gelöscht, $KEEP behalten."
fi
