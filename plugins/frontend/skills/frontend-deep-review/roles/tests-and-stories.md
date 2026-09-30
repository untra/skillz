# Tests and Stories (TS)

Expands: FE1, FE9, FE10

## Reading order

1. The diff, noting every changed component, hook, and page.
2. For each: its existing `.test.tsx` and `.stories.tsx` siblings, whether or not the diff touches them.
3. The shared fixtures folder (for example `testHelpers/`) before judging any inline entity literal.

## Checkpoints

### TS1 Behavior coverage (`should-fix`)
Flag when: the diff changes behavior (a callback, request, state transition, or validation) and no new or existing Vitest test covers it.
Not a finding: pure styling or copy changes, or behavior already covered by an unchanged test.

### TS2 Visual coverage (`should-fix`)
Flag when: a new or changed reusable component has no story, or its stories skip meaningful visual branches (error, empty, disabled, loading, mobile, dark mode).
Not a finding: page-level one-off layout already covered by a page story.

### TS3 Assertions in `play` (`should-fix`)
Flag when: a story's `play` function contains `expect` or other assertions, or drives more than the state the screenshot needs.
Not a finding: `play` functions that only click, type, or focus to reach a visual state.

### TS4 Visual assertions in tests (`should-fix`)
Flag when: a test's outcome assertion is `toBeVisible`, `toBeInTheDocument`, geometry, or attribute presence rather than a callback, request, or state change.
Not a finding: queries used to locate an element before interacting with it.

### TS5 Over-mocking (`should-fix`)
Flag when: a test mocks the repo's own modules instead of the network boundary, mocks more than it asserts on, or replaces browser globals with `Object.defineProperty`.
Not a finding: mocking a third-party module with side effects (analytics, clipboard) through the framework's mocking API.

### TS6 Fixtures (`nit`)
Flag when: an inline entity literal duplicates or drifts from a shared `Mock*` fixture, or stories share a pre-wired query object instead of inline `{ key, data }` wiring.
Not a finding: a named local variant built by spreading the shared fixture.

### TS7 Brittle queries (`should-fix`)
Flag when: `querySelector`, class-name substring selectors, DOM geometry, or `data-testid` on an element that has a role and accessible name.
Not a finding: `data-testid` on an element with no semantic role.

### TS8 Nondeterminism (`should-fix`)
Flag when: tests or stories depend on `new Date()`/`Date.now()` without a fixed time, `behavior: "smooth"` scrolling, locale-less `toLocaleString()`, real timers with sleeps, or random data.
Not a finding: time passed in as a prop, context, or fake timer.

### TS9 Coverage hygiene (`nit`)
Flag when: a test only pads coverage for behavior already tested, or a story is excluded from screenshots without stating why and where its behavior is covered.
Not a finding: a regression test that pins a specific past bug.
