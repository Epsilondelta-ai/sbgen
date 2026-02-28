#!/usr/bin/env bash
set -euo pipefail

# sbgen installer — copies skill + command to global OpenCode config
# Usage: bash install.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

echo "=== sbgen installer ==="
echo ""

# Check OpenCode config dir exists
if [ ! -d "$OPENCODE_CONFIG_DIR" ]; then
  echo "Error: OpenCode config directory not found at $OPENCODE_CONFIG_DIR"
  echo "Is OpenCode installed? Run: npm install -g opencode"
  exit 1
fi

# Install skill
SKILL_DIR="$OPENCODE_CONFIG_DIR/skills/sbgen"
echo "Installing skill → $SKILL_DIR/SKILL.md"
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/skills/sbgen/SKILL.md" "$SKILL_DIR/SKILL.md"

# Install command
COMMAND_DIR="$OPENCODE_CONFIG_DIR/command"
echo "Installing command → $COMMAND_DIR/sbgen.md"
mkdir -p "$COMMAND_DIR"
cp "$SCRIPT_DIR/command/sbgen.md" "$COMMAND_DIR/sbgen.md"

echo ""
echo "✓ sbgen installed successfully!"
echo ""
echo "Usage:"
echo "  1. Open any frontend project in OpenCode"
echo "  2. Type: /sbgen"
echo "  3. Storybook will be set up, stories generated, and verified"
echo ""
echo "Or mention 'sbgen' in your prompt and the skill will auto-load."
