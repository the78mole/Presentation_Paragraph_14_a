#!/bin/bash
set -e

show_help() {
  cat <<EOF
Usage: $(basename "$0") [release_notes_file] [current_tag]

Generates release notes based on GitHub Releases or Git tags.

Arguments:
  release_notes_file   Optional file to write to. If omitted, output goes to stdout.
  current_tag          Optional tag to generate notes for. If omitted, tag on HEAD is used.

Examples:
  $(basename "$0")
  $(basename "$0") release.md
  $(basename "$0") release.md v2025.4
EOF
}

[[ "$1" == "-h" || "$1" == "--help" ]] && show_help && exit 0

RELEASE_NOTES_FILE="$1"
CURRENT_TAG="$2"

# Wenn nur ein Argument übergeben wurde und es wie ein Tag aussieht:
if [[ "$RELEASE_NOTES_FILE" =~ ^v[0-9]{4}\.[0-9]+$ ]] && [ -z "$CURRENT_TAG" ]; then
  CURRENT_TAG="$RELEASE_NOTES_FILE"
  RELEASE_NOTES_FILE=""
fi

# Tag auf HEAD suchen, wenn nicht angegeben
if [ -z "$CURRENT_TAG" ]; then
  CURRENT_TAG=$(git tag --points-at HEAD | grep -E '^v[0-9]{4}\.[0-9]+$' | head -n 1)
  if [ -z "$CURRENT_TAG" ]; then
    echo "⚠️  Kein Tag auf HEAD, verwende letzten bekannten Tag..."
    CURRENT_TAG=$(git tag --sort=-creatordate | grep -E '^v[0-9]{4}\.[0-9]+$' | head -n 1)
    if [ -z "$CURRENT_TAG" ]; then
      echo "❌ Kein passender Tag gefunden."
      exit 1
    fi
  fi
fi

echo "📌 Verwende aktuellen Tag: $CURRENT_TAG"

# 💡 Versuche, nur GitHub-Releases zu verwenden
if command -v gh >/dev/null 2>&1; then
  echo "📦 Lade veröffentlichte Release-Tags von GitHub..."
  TAGS=($(gh release list --limit 100 --json tagName,createdAt \
  --jq 'sort_by(.createdAt) | reverse | .[].tagName' | grep -E '^v[0-9]{4}\.[0-9]+$'))
else
  echo "⚠️  GitHub CLI (gh) nicht verfügbar – verwende lokale Git-Tags."
  TAGS=($(git tag --sort=-v:refname | grep -E '^v[0-9]{4}\.[0-9]+$'))
fi

# 🔙 Vorherigen Tag ermitteln
PREV_TAG=""
for ((i=0; i<${#TAGS[@]}; i++)); do
  if [[ "${TAGS[$i]}" == "$CURRENT_TAG" ]]; then
    PREV_TAG=${TAGS[$((i+1))]}
    break
  fi
done

echo "🔙 Vorheriger Tag: ${PREV_TAG:-(keiner)}"

# Commit-Log erzeugen
HEADER="## Änderungen seit ${PREV_TAG:-dem Anfang}"
if [ -z "$PREV_TAG" ]; then
  BODY=$(git log --pretty=format:"- %s")
else
  BODY=$(git log "$PREV_TAG..$CURRENT_TAG" --pretty=format:"- %s")
fi

# Ausgabe
if [ -n "$RELEASE_NOTES_FILE" ]; then
  {
    echo "$HEADER"
    echo ""
    echo "$BODY"
  } > "$RELEASE_NOTES_FILE"
  echo "✅ Release Notes geschrieben nach $RELEASE_NOTES_FILE"
else
  echo "$HEADER"
  echo ""
  echo "$BODY"
fi
