---
name: sbgen
description: Automate Storybook setup, story generation, verification and build for frontend projects (React, Next.js, Vue, Nuxt, Svelte, SvelteKit, Angular). Use when 'sbgen' is mentioned, or when asked to set up Storybook, generate component stories, or create visual documentation. Triggers: 'sbgen', 'storybook setup', 'generate stories', 'story generation', 'component documentation'.
license: MIT
compatibility:
  - Claude Code
  - OpenCode
  - Cursor
  - Codex CLI
  - ChatGPT
  - Gemini CLI
  - VS Code
metadata:
  author: Epsilondelta
  version: "1.0.0"
  tags: storybook, testing, frontend, react, vue, svelte, angular, nextjs, nuxt, component-documentation, visual-testing
---

# sbgen — Storybook Generator

Comprehensive Storybook automation: detect framework → setup → generate stories → verify → build.

**Execute ALL phases in order. Do NOT skip phases. Do NOT generate only a few stories — generate for ALL components.**

---

## Phase 1: Project Analysis

### 1.1 Detect Framework

Read `package.json` and check `dependencies` + `devDependencies`:

| Dependency | Framework |
|------------|-----------|
| `next` | Next.js |
| `nuxt` | Nuxt |
| `@sveltejs/kit` | SvelteKit |
| `svelte` (no kit) | Svelte |
| `vue` (no nuxt) | Vue 3 |
| `@angular/core` | Angular |
| `react` (no next) | React |

### 1.2 Detect Package Manager

| Lockfile | PM | Install Command |
|----------|----|-----------------|
| `bun.lock` or `bun.lockb` | bun | `bun add -D` |
| `pnpm-lock.yaml` | pnpm | `pnpm add -D` |
| `yarn.lock` | yarn | `yarn add -D` |
| `package-lock.json` | npm | `npm install -D` |

### 1.3 Detect Language

- `tsconfig.json` exists → TypeScript (use `.ts`/`.tsx` extensions)
- Otherwise → JavaScript (use `.js`/`.jsx` extensions)

### 1.4 Check Storybook Existence

- `.storybook/main.{ts,js,mjs}` exists → Storybook already installed, skip Phase 2
- Otherwise → Proceed to Phase 2

### 1.5 Detect Component Locations

Scan for actual component directories in the project:

- **React/Next.js**: `src/components/`, `src/app/`, `app/`, `components/`, `src/pages/`, `pages/`
- **Vue/Nuxt**: `src/components/`, `components/`, `src/pages/`, `pages/`, `src/views/`, `views/`
- **Svelte/SvelteKit**: `src/lib/components/`, `src/lib/`, `src/routes/`
- **Angular**: `src/app/` (look for `*.component.ts`)

Only include directories that actually exist in the project.

---

## Phase 2: Storybook Setup

### 2.1 Install Storybook

```bash
npx storybook@latest init --yes
```

This auto-detects the framework. If it fails, use the `--type` flag:

```bash
npx storybook@latest init --yes --type react   # or vue, svelte, angular
```

### 2.2 Verify Framework Package

After init, verify the correct framework package is installed:

| Framework | Required Package |
|-----------|-----------------|
| React + Vite | `@storybook/react-vite` |
| React + Webpack | `@storybook/react-webpack5` |
| Next.js | `@storybook/nextjs` |
| Vue 3 + Vite | `@storybook/vue3-vite` |
| Svelte + Vite | `@storybook/svelte-vite` |
| SvelteKit | `@storybook/sveltekit` |
| Angular | `@storybook/angular` |

### 2.3 Install Verification Dependencies

```bash
{PM_INSTALL} @storybook/test-runner
npx playwright install --with-deps chromium
```

### 2.4 Configure Story Paths

Ensure `.storybook/main.{ts,js}` has correct story globs matching the component locations found in Phase 1.5:

```typescript
const config: StorybookConfig = {
  stories: [
    '../src/**/*.stories.@(js|jsx|mjs|ts|tsx)',
    // Add paths matching your actual component locations
  ],
  // ...
};
```

### 2.5 Delete Example Stories

Remove auto-generated boilerplate stories:

```bash
rm -rf src/stories/ stories/
```

These will be replaced by real component stories.

---

## Phase 3: Component Discovery

### 3.1 Find All Components

Search based on framework:

**React/Next.js:**
- Glob: `src/**/*.{tsx,jsx}`, `app/**/*.{tsx,jsx}`, `components/**/*.{tsx,jsx}`
- Include: Files that export a React component (function returning JSX, or class extending Component)
- Exclude: `*.stories.*`, `*.test.*`, `*.spec.*`, `*.d.ts`, `**/node_modules/**`, `**/.next/**`

**Vue:**
- Glob: `src/**/*.vue`, `components/**/*.vue`, `pages/**/*.vue`
- Exclude: `App.vue`, `*.stories.*`, `**/node_modules/**`, `**/.nuxt/**`

**Svelte:**
- Glob: `src/**/*.svelte`
- Exclude: `+layout.svelte`, `+error.svelte`, `*.stories.*`, `**/.svelte-kit/**`

**Angular:**
- Glob: `src/**/*.component.ts`
- Exclude: `*.spec.ts`, `app.component.ts` (root), `**/node_modules/**`

### 3.2 Classify Each Component

For each found component, determine:

1. **Category**: `Components/{path}` for UI components, `Pages/{path}` for pages/routes
2. **Props/Inputs**: Extract from TypeScript interfaces, PropTypes, or framework declarations
3. **Event handlers**: Functions like `onClick`, `onSubmit` — these need `fn()` mock
4. **Context dependencies**: Router, Theme, Store — these need decorators
5. **Has existing story**: Check if `*.stories.*` already exists next to the component

### 3.3 Skip Rules

Do NOT generate stories for:
- Components that already have `.stories.*` files
- Index/barrel files that only re-export
- Type definition files (`.d.ts`)
- Test files (`.test.*`, `.spec.*`)
- Pure utility/HOC wrappers with no visual output
- Next.js Server Components (they cannot render in Storybook)

---

## Phase 4: Story Generation

### 4.1 File Placement

Place stories **next to the component** (co-location pattern):

```
Button/
├── Button.tsx
├── Button.stories.tsx    ← HERE
└── Button.module.css
```

### 4.2 Title Convention

Use directory path as category:
- `src/components/ui/Button.tsx` → title: `'Components/UI/Button'`
- `src/pages/Home.tsx` → title: `'Pages/Home'`
- `src/components/forms/Input.tsx` → title: `'Components/Forms/Input'`

### 4.3 CSF 3.0 Story Templates

#### React / Next.js (TypeScript)

```tsx
import type { Meta, StoryObj } from '@storybook/react';
import { fn } from 'storybook/test';
import { ComponentName } from './ComponentName';

const meta = {
  title: 'Components/ComponentName',
  component: ComponentName,
  parameters: {
    layout: 'centered', // 'fullscreen' for pages
  },
  tags: ['autodocs'],
  argTypes: {
    // Only override when auto-inference is wrong
  },
  args: {
    // Default args shared across all stories
    // onClick: fn(),
  },
} satisfies Meta<typeof ComponentName>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {
    // Minimal required props
  },
};
```

#### React / Next.js (JavaScript)

```jsx
import { fn } from 'storybook/test';
import { ComponentName } from './ComponentName';

/** @type {import('@storybook/react').Meta<typeof ComponentName>} */
const meta = {
  title: 'Components/ComponentName',
  component: ComponentName,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  args: {},
};

export default meta;

/** @type {import('@storybook/react').StoryObj<typeof meta>} */
export const Default = {
  args: {},
};
```

#### Vue 3 (TypeScript)

```ts
import type { Meta, StoryObj } from '@storybook/vue3';
import { fn } from 'storybook/test';
import ComponentName from './ComponentName.vue';

const meta = {
  title: 'Components/ComponentName',
  component: ComponentName,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
  argTypes: {
    // size: { control: 'select', options: ['small', 'medium', 'large'] },
  },
  args: {},
} satisfies Meta<typeof ComponentName>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {},
};
```

#### Svelte (TypeScript)

```ts
import type { Meta, StoryObj } from '@storybook/svelte';
import ComponentName from './ComponentName.svelte';

const meta = {
  title: 'Components/ComponentName',
  component: ComponentName,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
} satisfies Meta<typeof ComponentName>;

export default meta;
type Story = StoryObj<typeof meta>;

export const Default: Story = {
  args: {},
};
```

#### Angular (TypeScript)

```ts
import type { Meta, StoryObj } from '@storybook/angular';
import { ComponentName } from './component-name.component';

const meta: Meta<ComponentName> = {
  title: 'Components/ComponentName',
  component: ComponentName,
  parameters: {
    layout: 'centered',
  },
  tags: ['autodocs'],
};

export default meta;
type Story = StoryObj<ComponentName>;

export const Default: Story = {
  args: {},
};
```

### 4.4 Story Variants

For each component, generate variant stories based on its props:

```tsx
// Boolean props → on/off variants
export const Disabled: Story = {
  args: { disabled: true },
};

// Enum/union props → one story per value
export const Small: Story = {
  args: { size: 'small' },
};
export const Large: Story = {
  args: { size: 'large' },
};

// Loading/error states
export const Loading: Story = {
  args: { isLoading: true },
};

export const Error: Story = {
  args: { error: 'Something went wrong' },
};

// Empty state
export const Empty: Story = {
  args: { items: [] },
};

// Event handlers → use fn()
export const WithClickHandler: Story = {
  args: { onClick: fn() },
};
```

**Rules for variants:**
- Always include `Default` story with minimal required props
- Add variant for each boolean prop that changes appearance
- Add variant for enum/union props showing key options
- Add Loading/Error/Empty if the component supports these states
- Use `fn()` from `storybook/test` for all callback props

### 4.5 Decorator Patterns

When components depend on external context, add decorators:

#### React Router

```tsx
import { MemoryRouter } from 'react-router-dom';

const meta = {
  decorators: [
    (Story) => (
      <MemoryRouter initialEntries={['/']}>
        <Story />
      </MemoryRouter>
    ),
  ],
};
```

#### Next.js Router

`@storybook/nextjs` auto-mocks `next/navigation`. For custom routes:

```tsx
const meta = {
  parameters: {
    nextjs: {
      navigation: {
        pathname: '/dashboard',
        query: { id: '1' },
      },
    },
  },
};
```

#### Theme Provider (styled-components, emotion, etc.)

```tsx
import { ThemeProvider } from 'styled-components';
import { theme } from '@/theme';

const meta = {
  decorators: [
    (Story) => (
      <ThemeProvider theme={theme}>
        <Story />
      </ThemeProvider>
    ),
  ],
};
```

**Tip:** If many components need the same decorator, add it to `.storybook/preview.{ts,js}` instead.

#### Vue Router

```ts
import { vueRouter } from 'storybook-vue3-router';

const meta = {
  decorators: [vueRouter()],
};
```

#### Pinia Store (Vue)

```ts
import { createPinia } from 'pinia';
import { setup } from '@storybook/vue3';

// In .storybook/preview.ts (global)
setup((app) => {
  app.use(createPinia());
});
```

### 4.6 Page Component Stories

Pages use `layout: 'fullscreen'` and typically need more decorators:

```tsx
const meta = {
  title: 'Pages/Dashboard',
  component: DashboardPage,
  parameters: {
    layout: 'fullscreen',
  },
  decorators: [
    // Router, auth context, store — whatever the page needs
  ],
};

export const Default: Story = {};

export const Loading: Story = {
  args: { isLoading: true },
};

export const WithData: Story = {
  args: {
    data: [
      // Mock data representing realistic content
    ],
  },
};

export const Empty: Story = {
  args: { data: [] },
};
```

---

## Phase 5: Verification (Build + Playwright)

### 5.1 Build Storybook

```bash
npx storybook build --test 2>&1
```

If build fails:
- Read error output carefully
- Fix the root cause (missing dependency, config error, component error)
- Retry build
- Do NOT proceed to Playwright verification until build succeeds

### 5.2 Serve Built Storybook

```bash
npx http-server storybook-static --port 6006 --silent &
SB_PID=$!
npx wait-on tcp:127.0.0.1:6006 --timeout 30000
```

### 5.3 Run Test Runner (if available)

```bash
npx test-storybook --url http://127.0.0.1:6006 2>&1
```

### 5.4 Playwright Verification

If test-runner is not available, or for additional verification, use Playwright directly.

Load the `playwright` skill, then:

1. Navigate to `http://localhost:6006`
2. Wait for Storybook UI to load (sidebar visible)
3. Get story list: fetch `http://localhost:6006/index.json` to get all story IDs
4. For each story:
   a. Navigate to `http://localhost:6006/iframe.html?id={storyId}&viewMode=story`
   b. Wait for render (check `#storybook-root` has content)
   c. Check for error overlay (`.sb-errordisplay` element)
   d. If error found: record story ID and error message
5. Report results

### 5.5 Cleanup

```bash
kill $SB_PID 2>/dev/null
rm -rf storybook-static/
```

### 5.6 Fix-and-Retry Loop

If errors are found:
1. Analyze each error
2. Fix the story or component issue
3. Re-run build + verification
4. Repeat until all stories pass or errors are clearly pre-existing component bugs

---

## Phase 6: Final Build & Report

### 6.1 Production Build

```bash
npx storybook build 2>&1
```

### 6.2 Verify Output

Check `storybook-static/` contains:
- `index.html`
- `iframe.html`
- `index.json`

### 6.3 Cleanup

```bash
rm -rf storybook-static/
```

### 6.4 Summary Report

Print a summary:

```
=== sbgen Report ===
Framework: {detected framework}
Package Manager: {detected PM}
Language: TypeScript / JavaScript

Components found: {N}
Stories generated: {N} (new)
Stories skipped: {N} (already existed)

Verification:
  Build: ✅ / ❌
  Stories tested: {N}
  Passed: {N}
  Failed: {N}
    - {ComponentName}: {error description}

Final build: ✅ / ❌
```

---

## Troubleshooting

### Storybook init fails
- **Node.js version**: Requires 18+ (recommended 20+)
- **Conflicting deps**: Delete `node_modules` and lockfile, reinstall
- **Manual type**: Use `--type react` (or vue, svelte, angular)

### Stories fail to render
- **Missing provider**: Add decorator (Router, Theme, Store)
- **Module alias not resolved**: Add path aliases to `.storybook/main.{ts,js}`:
  ```typescript
  // Vite-based
  viteFinal: (config) => {
    config.resolve.alias['@'] = path.resolve(__dirname, '../src');
    return config;
  }
  // Webpack-based
  webpackFinal: (config) => {
    config.resolve.alias['@'] = path.resolve(__dirname, '../src');
    return config;
  }
  ```
- **Image/asset imports**: Configure `staticDirs` in main config

### Build fails
- **Out of memory**: `NODE_OPTIONS=--max-old-space-size=4096 npx storybook build`
- **Version conflicts**: Ensure all `@storybook/*` packages are the same version
- **TypeScript errors**: Storybook build is stricter than dev mode — fix type errors

### Next.js specific
- **Server Components**: Cannot render in Storybook. Add `'use client'` or skip
- **next/image**: Auto-mocked by `@storybook/nextjs`
- **next/font**: Add mock in `.storybook/preview.ts` or use `@storybook/nextjs` built-in support

### Nuxt specific
- **Auto-imports**: Not available in Storybook. Explicitly import composables/components
- **Nitro/Server routes**: Not available. Mock API calls

### Angular specific
- **Module imports**: Declare required modules in story's `moduleMetadata`
- **Standalone components**: Use directly without module configuration
