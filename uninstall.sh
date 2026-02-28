#!/usr/bin/env bash
set -euo pipefail

# sbgen uninstaller — removes skill + command from global OpenCode config

OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

echo "=== sbgen uninstaller ==="
echo ""

# Remove skill
if [ -d "$OPENCODE_CONFIG_DIR/skills/sbgen" ]; then
  echo "Removing skill → $OPENCODE_CONFIG_DIR/skills/sbgen/"
  rm -rf "$OPENCODE_CONFIG_DIR/skills/sbgen"
else
  echo "Skill not found (already removed)"
fi

# Remove command
if [ -f "$OPENCODE_CONFIG_DIR/command/sbgen.md" ]; then
  echo "Removing command → $OPENCODE_CONFIG_DIR/command/sbgen.md"
  rm "$OPENCODE_CONFIG_DIR/command/sbgen.md"
else
  echo "Command not found (already removed)"
fi

echo ""
echo "✓ sbgen uninstalled."
