---
description: Storybook 자동 세팅, 모든 컴포넌트/페이지 스토리 생성, Playwright 검증, 빌드까지 수행합니다. 프론트엔드 프로젝트 전용.
---

You are running the **sbgen** (Storybook Generator) workflow.

**FIRST**: Load the `sbgen` skill for detailed instructions and patterns.

## Project Info

!`cat package.json 2>/dev/null || echo "ERROR: No package.json found. This is not a frontend project."`

!`ls .storybook/main.* 2>/dev/null || echo "NO_STORYBOOK_CONFIG"`

!`ls bun.lock bun.lockb pnpm-lock.yaml yarn.lock package-lock.json 2>/dev/null || echo "NO_LOCKFILE"`

!`ls tsconfig.json tsconfig.app.json 2>/dev/null || echo "NO_TYPESCRIPT"`

!`ls -d src/components src/app src/pages src/views src/lib src/lib/components app components pages views 2>/dev/null || echo "NO_STANDARD_DIRS"`

## Guard: Frontend Project Check

If `package.json` does not exist OR does not contain any frontend framework dependency (react, vue, svelte, @angular/core, next, nuxt, @sveltejs/kit), **STOP** and inform the user:
> "This does not appear to be a frontend project. sbgen only works with React, Vue, Svelte, Angular, Next.js, Nuxt, or SvelteKit projects."

## Workflow

Follow the **sbgen skill** phases strictly in this order:

### Phase 1 — Project Analysis
Using the info above, detect:
- Framework (React / Next.js / Vue / Nuxt / Svelte / SvelteKit / Angular)
- Package manager (bun / pnpm / yarn / npm)
- Language (TypeScript / JavaScript)
- Existing Storybook (yes / no)
- Component directories

### Phase 2 — Storybook Setup
**Skip if Storybook already exists.**
- Run `npx storybook@latest init --yes`
- Verify framework package is correct
- Install `@storybook/test-runner` and Playwright
- Configure story paths in `.storybook/main`
- Delete example stories

### Phase 3 — Component Discovery
- Find ALL component files in the project
- Classify each (UI component / Page / Layout)
- Extract props and context dependencies
- Skip components that already have stories

### Phase 4 — Story Generation
- Generate CSF 3.0 stories for EVERY discovered component
- Place stories next to their components
- Include Default + variant stories per component
- Add decorators for context-dependent components
- Use `fn()` for all callback/event handler props

### Phase 5 — Verification
- Build Storybook with `npx storybook build --test`
- Serve and run test-runner OR use Playwright to visit each story
- Fix any errors found, then re-verify
- Use the `playwright` skill for browser-based verification

### Phase 6 — Final Build & Report
- Production build
- Print summary report with counts and status

## Critical Rules

1. **ALL components**: Generate stories for every component found, not just a few
2. **Co-location**: Stories go next to their component file, NOT in a separate directory
3. **No shortcuts**: Complete all 6 phases. If a phase fails, fix and retry before moving on
4. **Fix-and-verify loop**: If stories have errors, fix them and re-verify until clean
5. **Report at the end**: Always print the summary report

$ARGUMENTS
