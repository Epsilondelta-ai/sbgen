# sbgen

OpenCode plugin that automatically sets up Storybook, generates stories for all components/pages, verifies them with Playwright, and builds.

## Supported Frameworks

- React
- Next.js
- Vue 3
- Nuxt
- Svelte
- SvelteKit
- Angular

## Install

```bash
git clone https://github.com/epsilondelta/sbgen.git
cd sbgen
bash install.sh
```

This copies the skill and command to your global OpenCode config (`~/.config/opencode/`).

## Uninstall

```bash
bash uninstall.sh
```

## Usage

Open any frontend project in OpenCode and run:

```
/sbgen
```

Or mention `sbgen` in your prompt — the skill will auto-load.

### What it does

1. **Detects** your framework, package manager, and language
2. **Sets up** Storybook if not already installed
3. **Discovers** all components and pages in your project
4. **Generates** CSF 3.0 stories for every component
5. **Verifies** each story renders without errors (Playwright)
6. **Builds** Storybook and reports results

### With arguments

```
/sbgen --force
```

Pass `--force` to regenerate stories even for components that already have them.

## Project Structure

```
sbgen/
├── skills/
│   └── sbgen/
│       └── SKILL.md        # Storybook automation knowledge base
├── command/
│   └── sbgen.md            # /sbgen command workflow
├── install.sh              # Global installer
├── uninstall.sh            # Uninstaller
└── README.md
```

## How It Works

**Skill** (`SKILL.md`): Contains comprehensive Storybook automation knowledge — framework detection, CSF 3.0 story templates, verification patterns, and troubleshooting guides. Auto-loaded when "sbgen" is mentioned in conversation.

**Command** (`sbgen.md`): The `/sbgen` slash command. Collects project info via inline shell, loads the skill, and orchestrates the 6-phase workflow.

## License

MIT
