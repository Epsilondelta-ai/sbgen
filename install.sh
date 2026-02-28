#!/usr/bin/env bash
set -euo pipefail

# sbgen installer — copies skill + command to OpenCode and Claude Code
# Usage: bash install.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
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
  cp "$SCRIPT_DIR/skills/sbgen/SKILL.md" "$SKILL_DIR/SKILL.md"
  echo "  skill   → $SKILL_DIR/SKILL.md"

  mkdir -p "$COMMAND_DIR"
  cp "$SCRIPT_DIR/command/sbgen.md" "$COMMAND_DIR/sbgen.md"
  echo "  command → $COMMAND_DIR/sbgen.md"
  echo ""
  INSTALLED=true
fi

# Install to Claude Code (if installed)
if [ -d "$CLAUDE_CONFIG_DIR" ] || command -v claude &>/dev/null; then
  SKILL_DIR="$CLAUDE_CONFIG_DIR/skills/sbgen"

  echo "[Claude Code]"
  mkdir -p "$SKILL_DIR"
  cp "$SCRIPT_DIR/skills/sbgen/SKILL.md" "$SKILL_DIR/SKILL.md"
  echo "  skill   → $SKILL_DIR/SKILL.md"
  echo ""
  INSTALLED=true
fi

if [ "$INSTALLED" = false ]; then
  echo "Error: Neither OpenCode nor Claude Code found."
  echo "Install OpenCode or Claude Code first."
  exit 1
fi

echo "✓ sbgen installed successfully!"
echo ""
echo "Usage:"
echo "  OpenCode:   /sbgen"
echo "  Claude Code: mention 'sbgen' in your prompt"
