# sbgen

Agent skill that automatically sets up Storybook, generates stories for all components/pages, verifies them with Playwright, and builds.

Uses the open [SKILL.md](https://www.mdskills.ai/specs/skill-md) standard — works with **27+ AI coding tools**.

## Compatible Tools

| Tool | Skill | `/sbgen` Command |
|------|:-----:|:----------------:|
| **OpenCode + oh-my-opencode** | ✅ Auto-loads | ✅ |
| **OpenCode** | ✅ | ✅ |
| **Claude Code** | ✅ | — |
| **Cursor** | ✅ | — |
| **Codex CLI** | ✅ | — |
| **ChatGPT** | ✅ | — |
| **Gemini CLI** | ✅ | — |
| **VS Code (Copilot)** | ✅ | — |

> The `/sbgen` slash command is OpenCode-specific. Other tools use the skill via prompt (mention `sbgen` or `storybook setup`).

## Supported Frameworks

React · Next.js · Vue 3 · Nuxt · Svelte · SvelteKit · Angular

## Install

### One-liner (recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/sbgen/main/install-remote.sh | bash
```

Auto-detects installed tools (OpenCode, Claude Code) and installs to the right location.

### From source

```bash
git clone https://github.com/Epsilondelta-ai/sbgen.git
cd sbgen
bash install.sh
```

### Manual (any SKILL.md-compatible tool)

Copy `SKILL.md` to your tool's skills directory:

```bash
# OpenCode
mkdir -p ~/.config/opencode/skills/sbgen
curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/sbgen/main/skills/sbgen/SKILL.md \
  -o ~/.config/opencode/skills/sbgen/SKILL.md

# Claude Code
mkdir -p ~/.claude/skills/sbgen
curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/sbgen/main/skills/sbgen/SKILL.md \
  -o ~/.claude/skills/sbgen/SKILL.md

# Project-level (works with Cursor, Codex, etc.)
mkdir -p .claude/skills/sbgen
curl -fsSL https://raw.githubusercontent.com/Epsilondelta-ai/sbgen/main/skills/sbgen/SKILL.md \
  -o .claude/skills/sbgen/SKILL.md
```

## Uninstall

```bash
bash uninstall.sh
```

Or manually:

```bash
rm -rf ~/.config/opencode/skills/sbgen ~/.config/opencode/command/sbgen.md ~/.claude/skills/sbgen
```

## Usage

**OpenCode:**

```
/sbgen
```

**Other tools (Claude Code, Cursor, etc.):**

Mention `sbgen` or ask to "set up Storybook and generate stories" — the skill auto-loads.

### What it does

1. **Detects** your framework, package manager, and language
2. **Sets up** Storybook if not already installed
3. **Discovers** all components and pages in your project
4. **Generates** CSF 3.0 stories for every component
5. **Verifies** each story renders without errors (Playwright)
6. **Builds** Storybook and reports results

## Project Structure

```
sbgen/
├── skills/
│   └── sbgen/
│       └── SKILL.md            # Storybook automation knowledge base (primary)
├── .claude/
│   └── skills/
│       └── sbgen/
│           └── SKILL.md        # Claude Code native path (copy)
├── command/
│   └── sbgen.md                # /sbgen slash command (OpenCode only)
├── install.sh                  # Local installer
├── install-remote.sh           # Remote installer (curl one-liner)
├── uninstall.sh                # Uninstaller
└── README.md
```

## How It Works

**Skill** (`SKILL.md`): Contains comprehensive Storybook automation knowledge — framework detection, CSF 3.0 story templates per framework, verification patterns, and troubleshooting guides. Follows the open SKILL.md standard.

**Command** (`sbgen.md`): OpenCode-specific `/sbgen` slash command. Collects project info via inline shell, loads the skill, and orchestrates the 6-phase workflow.

## Requirements

- An AI coding tool that supports [SKILL.md](https://www.mdskills.ai/specs/skill-md) (see Compatible Tools above)
- Node.js 18+
- A frontend project (React, Vue, Svelte, Angular, or their meta-frameworks)

## License

MIT
