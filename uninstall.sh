#!/usr/bin/env bash
set -euo pipefail

# sbgen uninstaller — removes skill + command from all locations

OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
CLAUDE_CONFIG_DIR="$HOME/.claude"

echo "=== sbgen uninstaller ==="
echo ""

# Remove from OpenCode
if [ -d "$OPENCODE_CONFIG_DIR/skills/sbgen" ] || [ -f "$OPENCODE_CONFIG_DIR/command/sbgen.md" ]; then
  echo "[OpenCode]"
  [ -d "$OPENCODE_CONFIG_DIR/skills/sbgen" ] && rm -rf "$OPENCODE_CONFIG_DIR/skills/sbgen" && echo "  removed skill"
  [ -f "$OPENCODE_CONFIG_DIR/command/sbgen.md" ] && rm "$OPENCODE_CONFIG_DIR/command/sbgen.md" && echo "  removed command"
  echo ""
else
  echo "[OpenCode] not installed"
fi

# Remove from Claude Code
if [ -d "$CLAUDE_CONFIG_DIR/skills/sbgen" ]; then
  echo "[Claude Code]"
  rm -rf "$CLAUDE_CONFIG_DIR/skills/sbgen"
  echo "  removed skill"
  echo ""
else
  echo "[Claude Code] not installed"
fi

echo "✓ sbgen uninstalled."
