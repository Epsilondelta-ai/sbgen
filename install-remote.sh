#!/usr/bin/env bash
set -euo pipefail

# sbgen remote installer — downloads and installs from GitHub
# Usage: curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/sbgen/main/install-remote.sh | bash

REPO="Epsilondelta-ai/sbgen"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
CLAUDE_CONFIG_DIR="$HOME/.claude"

echo "=== sbgen installer ==="
echo ""

INSTALLED=false

# Install to OpenCode (if installed)
if [ -d "$OPENCODE_CONFIG_DIR" ]; then
  SKILL_DIR="$OPENCODE_CONFIG_DIR/skills/sbgen"
  COMMAND_DIR="$OPENCODE_CONFIG_DIR/command"

  echo "[OpenCode]"
  mkdir -p "$SKILL_DIR"
  curl -fsSL "${BASE_URL}/skills/sbgen/SKILL.md" -o "$SKILL_DIR/SKILL.md"
  echo "  skill   → $SKILL_DIR/SKILL.md"

  mkdir -p "$COMMAND_DIR"
  curl -fsSL "${BASE_URL}/command/sbgen.md" -o "$COMMAND_DIR/sbgen.md"
  echo "  command → $COMMAND_DIR/sbgen.md"
  echo ""
  INSTALLED=true
fi

# Install to Claude Code (if installed)
if [ -d "$CLAUDE_CONFIG_DIR" ] || command -v claude &>/dev/null; then
  SKILL_DIR="$CLAUDE_CONFIG_DIR/skills/sbgen"

  echo "[Claude Code]"
  mkdir -p "$SKILL_DIR"
  curl -fsSL "${BASE_URL}/skills/sbgen/SKILL.md" -o "$SKILL_DIR/SKILL.md"
  echo "  skill   → $SKILL_DIR/SKILL.md"
  echo ""
  INSTALLED=true
fi

if [ "$INSTALLED" = false ]; then
  echo "Error: Neither OpenCode nor Claude Code found."
  echo "Install one of them first, or manually place SKILL.md in your tool's skills directory."
  exit 1
fi

echo "✓ sbgen installed successfully!"
echo ""
echo "Usage:"
echo "  OpenCode:    /sbgen"
echo "  Claude Code: mention 'sbgen' in your prompt"
echo ""
echo "To uninstall:"
echo "  rm -rf ${OPENCODE_CONFIG_DIR}/skills/sbgen ${OPENCODE_CONFIG_DIR}/command/sbgen.md ${CLAUDE_CONFIG_DIR}/skills/sbgen"
