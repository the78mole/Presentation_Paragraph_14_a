#!/bin/bash
set -e

# Hole das Jahr des letzten Commits
commit_year=$(git log -1 --format=%cd --date=format:'%Y')

# Tag-Präfix
prefix="v$commit_year"

# Alle lokalen Tags für dieses Jahr
tags=$(git tag -l "${prefix}.*")

# Bestimme den höchsten .x-Wert
max=0
for tag in $tags; do
    number=${tag##*.}
    if [[ $number =~ ^[0-9]+$ && ${tag} =~ ^v$commit_year\.[0-9]+$ ]]; then
        if (( number > max )); then
            max=$number
        fi
    fi
done

# Neuer Tag
next=$((max + 1))
new_tag="$prefix.$next"

# Tag erzeugen
git tag "$new_tag"

echo "✅ Created tag: $new_tag"

# Optional direkt pushen:
# git push origin "$new_tag"
