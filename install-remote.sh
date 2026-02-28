#!/usr/bin/env bash
set -euo pipefail

# sbgen remote installer — downloads and installs from GitHub
# Usage: curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/sbgen/main/install-remote.sh | bash

REPO="Epsilondelta-ai/sbgen"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
OPENCODE_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"

echo "=== sbgen installer ==="
echo ""

# Check OpenCode config dir exists
if [ ! -d "$OPENCODE_CONFIG_DIR" ]; then
  echo "Error: OpenCode config directory not found at $OPENCODE_CONFIG_DIR"
  echo "Is OpenCode installed?"
  exit 1
fi

# Download and install skill
SKILL_DIR="$OPENCODE_CONFIG_DIR/skills/sbgen"
echo "Downloading skill..."
mkdir -p "$SKILL_DIR"
curl -fsSL "${BASE_URL}/skills/sbgen/SKILL.md" -o "$SKILL_DIR/SKILL.md"
echo "  → $SKILL_DIR/SKILL.md"

# Download and install command
COMMAND_DIR="$OPENCODE_CONFIG_DIR/command"
echo "Downloading command..."
mkdir -p "$COMMAND_DIR"
curl -fsSL "${BASE_URL}/command/sbgen.md" -o "$COMMAND_DIR/sbgen.md"
echo "  → $COMMAND_DIR/sbgen.md"

echo ""
echo "✓ sbgen installed successfully!"
echo ""
echo "Usage:"
echo "  1. Open any frontend project in OpenCode"
echo "  2. Type: /sbgen"
echo ""
echo "To uninstall:"
echo "  rm -rf $SKILL_DIR $COMMAND_DIR/sbgen.md"
