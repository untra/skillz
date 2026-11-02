---
name: frontend-a11y
description: Use when a diff changes React .tsx components that have Storybook stories, before creating or updating a PR, or when reviewing someone else's frontend PR for accessibility (a11y, WCAG 2.2 AA, axe-core, ARIA, color contrast, keyboard and focus).
---

# Frontend accessibility

Audit changed components against the axe-core rules in `references/AXE_RULES.md` (in this skill directory), then confirm the result in Storybook's Accessibility panel, which runs axe-core through `@storybook/addon-a11y`.

## Modes

- **Self-review** (your own branch): fix every `blocking` and `should-fix` finding with the smallest change, then re-run this audit.
- **Report** (someone else's PR): list findings only. Change nothing.

## Setup

1. Find the Storybook config: the `.storybook/main.*` file nearest the changed `.tsx` files. Its directory's parent is the **UI root**.
2. Confirm `@storybook/addon-a11y` is in its `addons`. If it is not, skip the story audit and report `storybook-a11y-addon MISSING`; do not install it in report mode.
3. Read the installed `axe-core` version from the UI root's lockfile. A rule in `references/AXE_RULES.md` that the installed version lacks is checked in code only; its absence from the panel is not a pass.
4. **Base** is `git merge-base HEAD origin/main` (use `main` when there is no `origin` remote).

## Workflow

1. List changed `.tsx` files with `git diff --name-only <base> -- <UI root>`, and the stories (`*.stories.tsx`) that render them.
2. **Code audit.** For each changed component, check every rule in `references/AXE_RULES.md` that applies to the elements it renders. Read the shared primitive a component wraps when the diff alone cannot answer a check, for example whether `Button` forwards `aria-label`.
3. **Story audit.** Start Storybook from the UI root (`npm run storybook`, or the package manager the lockfile implies) and open each affected story in a browser, delegating to a browser-capable sub-agent if you cannot drive one yourself. Then:
   1. Open the **Accessibility** tab and record each violation and incomplete item: rule ID, impact, and target.
   2. Repeat in each state the change affects: keyboard focus, open menus or dialogs, hover content, light and dark themes, and 320px width.
   3. Check the same stories on base. A violation on both is pre-existing; one only on the branch is introduced.
   4. If no story covers a changed state, report that as a finding.
4. **Manual checks.** Run the checks under "What axe cannot check" for every behavior the diff touches.
5. Skip these page-level rules in isolated stories: `document-title`, `html-has-lang`, `html-lang-valid`, `bypass`, `landmark-one-main`, `page-has-heading-one`, `region`, `frame-tested`. Check them only when the diff touches page shells, layouts, or `index.html`.
6. Report (see Output). In self-review mode, fix and repeat from step 2 until no `blocking` or `should-fix` finding remains.
7. Stop Storybook.

## Severity

| axe impact | Introduced by the diff | Pre-existing in touched code |
|---|---|---|
| Critical, Serious | `blocking` | `should-fix` if the diff edits that element, otherwise a note |
| Moderate | `should-fix` | note |
| Minor | `nit` | note |

- Best-practice rules rank one level lower than this table.
- Manual-check failures rank as Serious.
- An "incomplete" (needs review) result is a finding only after you verify it by hand, for example `color-contrast` over a gradient or image.
- Notes are not findings. List them so a reviewer can file follow-up tickets.

## What axe cannot check

- **Keyboard:** every control is reachable with Tab and operable with Enter, Space, and the arrow keys its role expects. Focus order follows visual order; focus is never trapped except inside an open modal.
- **Focus visibility:** every focusable element shows an indicator with 3:1 contrast against its surroundings (WCAG 2.4.7, 1.4.11).
- **Focus management:** focus moves into dialogs and menus when they open, and returns to the trigger when they close.
- **Hover and focus content:** tooltips and popovers are dismissable, hoverable, and persistent (WCAG 1.4.13).
- **Reflow:** no content or function is lost at 320px width (WCAG 1.4.10).
- **Non-text contrast:** control borders, icons, and states have 3:1 contrast (WCAG 1.4.11).
- **Status messages:** toasts and async results are announced through a live region (WCAG 4.1.3).

## Output

One line per applicable rule, using the axe rule ID or `manual:<check>`:

```text
button-name     PASS
color-contrast  FAIL blocking    src/pages/Foo/Foo.tsx:42      muted text on surface-secondary is 3.9:1 (story Foo/Default, dark theme)
target-size     FAIL should-fix  src/components/Link.tsx:18    18px tall in text-xs callers
manual:focus    FAIL blocking    src/components/Menu.tsx:30    focus not returned to trigger on close
Notes (pre-existing): heading-order in src/pages/Bar.tsx:12
```

After fixes, print the table again. In self-review mode, the audit is done when no `blocking` or `should-fix` line remains.
