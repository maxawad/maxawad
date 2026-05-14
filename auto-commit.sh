#!/usr/bin/env bash
set -euo pipefail

cd /tmp/maxawad-profile

CHANGES=(
  # Bio tweaks
  's/I build native apps, AI tools, and infra/I build native apps, AI tools, and infrastructure/'
  's/I build native apps, AI tools, and infrastructure/I design and build native apps, AI tools, and infrastructure/'
  's/I design and build native apps, AI tools, and infrastructure/I design and ship native apps, AI tools, and infrastructure/'
  's/I design and ship native apps, AI tools, and infrastructure/I design and ship native apps, AI agents, and infrastructure/'
  's/I design and ship native apps, AI agents, and infrastructure/I design and ship native apps, AI agents, and cloud infrastructure/'
  's/I design and ship native apps, AI agents, and cloud infrastructure/I build and ship native apps, AI agents, and cloud infrastructure/'
  's/I build and ship native apps, AI agents, and cloud infrastructure/I build and ship native apps, AI agents, cloud infrastructure, and dev tools/'
  's/I build and ship native apps, AI agents, cloud infrastructure, and dev tools/I ship native apps, AI agents, cloud infra, and dev tools/'
  's/I ship native apps, AI agents, cloud infra, and dev tools/I ship native apps, AI tools, cloud infra, and dev tools/'
  's/I ship native apps, AI tools, cloud infra, and dev tools/I build native apps, AI tools, and infra/'

  # Location / tagline tweaks
  's/Currently based in \*\*San Francisco, CA\*\*/Currently based in \*\*SF, California\*\*/'
  's/Currently based in \*\*SF, California\*\*/Currently shipping from \*\*SF, California\*\*/'
  's/Currently shipping from \*\*SF, California\*\*/Currently shipping from \*\*San Francisco\*\*/'
  's/Currently shipping from \*\*San Francisco\*\*/Currently based in \*\*San Francisco, CA\*\*/'

  # Product description micro-edits
  's/ChatGPT voice chat for macOS/ChatGPT voice assistant for macOS/'
  's/ChatGPT voice assistant for macOS/ChatGPT voice chat for macOS/'
  's/System dictation replacement for macOS/On-device dictation for macOS/'
  's/On-device dictation for macOS/System dictation replacement for macOS/'
  's/Screen OCR for macOS/Instant screen OCR for macOS/'
  's/Instant screen OCR for macOS/Screen OCR for macOS/'
  's/Per-window Cmd+Tab for macOS/True per-window Cmd+Tab for macOS/'
  's/True per-window Cmd+Tab for macOS/Per-window Cmd+Tab for macOS/'
  's/Push MacBook Pro beyond max brightness/Push your MacBook beyond max brightness/'
  's/Push your MacBook beyond max brightness/Push MacBook Pro beyond max brightness/'
  's/AI-native snack ordering via MCP/AI-powered snack ordering via MCP/'
  's/AI-powered snack ordering via MCP/AI-native snack ordering via MCP/'

  # Tech stack badge additions/removals (cycle Docker in/out)
  's|!\[OpenAI\]|![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square\&logo=docker\&logoColor=white)\n![OpenAI]|'
  's|!\[Docker\].*\n||'

  # Footer text tweaks
  's/this profile highlights recent shipped products/this profile highlights shipped products/'
  's/this profile highlights shipped products/this profile highlights recent shipped products/'
)

COMMIT_MSGS=(
  "bio: expand infra to infrastructure"
  "bio: add design verb"
  "bio: design and ship"
  "bio: AI tools -> AI agents"
  "bio: cloud infrastructure"
  "bio: build and ship"
  "bio: add dev tools"
  "bio: shorten to cloud infra"
  "bio: AI tools phrasing"
  "bio: revert to original phrasing"
  "location: SF California"
  "location: shipping from"
  "location: drop state"
  "location: revert to original"
  "jarvis: voice assistant"
  "jarvis: revert to voice chat"
  "lowercase: on-device dictation"
  "lowercase: revert description"
  "textgrab: instant screen OCR"
  "textgrab: revert description"
  "windowswitch: true per-window"
  "windowswitch: revert description"
  "brightenup: your MacBook"
  "brightenup: revert description"
  "perico: AI-powered"
  "perico: revert to AI-native"
  "stack: add Docker badge"
  "stack: remove Docker badge"
  "footer: drop recent"
  "footer: restore recent"
)

NUM_CHANGES=${#CHANGES[@]}
IDX=0

echo "=== Auto-commit service started ==="
echo "=== Cycling through $NUM_CHANGES changes, one per minute ==="
echo ""

while true; do
  i=$((IDX % NUM_CHANGES))
  PATTERN="${CHANGES[$i]}"
  MSG="${COMMIT_MSGS[$i]}"

  if perl -i -0pe "$PATTERN" README.md; then
    if ! git diff --quiet README.md; then
      git add README.md
      git commit -m "$MSG"
      git push origin main
      echo "[$(date '+%H:%M:%S')] Commit #$((IDX+1)): $MSG — pushed!"
    else
      echo "[$(date '+%H:%M:%S')] Skipped #$((IDX+1)): no diff from '$MSG'"
    fi
  else
    echo "[$(date '+%H:%M:%S')] Skipped #$((IDX+1)): pattern didn't match"
  fi

  IDX=$((IDX + 1))
  echo "[$(date '+%H:%M:%S')] Next commit in 60 seconds..."
  sleep 60
done
