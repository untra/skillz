---
name: frontend-review
description: Use when agent work touching .tsx files is finishing, before creating or updating a PR, or before pushing significant new commits to a frontend PR; a diff-scoped self-review against the FE1-FE10 frontend rules.
---

# Frontend Review

Audit the current branch diff against the frontend rule contract in `references/FRONTEND_PATTERNS.md` (in this skill directory) and fix every violation before the PR is created or updated.
This is a self-review gate: its purpose is to catch the findings reviewers would otherwise post, before they see the PR.

## When to run

Run this when concluding agent work that has touched .tsx code:

- Only perform the work in the directory containing the .tsx code.
- Before pushing significant new commits to an existing frontend PR.
- Skip only when the diff touches no .tsx code.

## Workflow

1. Collect the diff: `git diff --merge-base main -- ui/` (substitute the directory that holds the React .tsx code). Use `origin/main` instead when the checkout has an `origin` remote and the local `main` may be stale. List the changed files.
2. For each changed file, audit against each FE rule using the checklist below. Read the full file when the diff alone cannot answer a check (for example, whether a `.test.tsx` covers the changed behavior).
3. Report results as a per-rule verdict table (see Output format). Every FAIL must carry `file:line` and a one-line reason.
4. Fix all FAIL findings with the smallest safe diff. Re-run the audit until every rule passes or a remaining finding is explicitly justified.
5. Include unresolved justifications in the PR description so reviewers see them up front.

## Per-rule diff checklist

- **FE1 (behavior and visual coverage)**:
Does any changed component or page alter frontend behavior?
The behavior should be covered by an existing or new Vitest test, and reusable components should have Storybook stories.
Behavior tests should use Vitest, React Testing Library and `userEvent`.
A `play` function may only drive state setup the screenshot needs (open the menu, type the text);
flag assertions in a `play` function and behavior covered only by a story, and note that a valuable assertion belongs in a Vitest test.
In the test, queries locate the element to interact with; the assertion must be the non-visual outcome (callback, request, state).
An outcome assertion on what the DOM renders (`toBeVisible`, `toBeInTheDocument`, geometry, attribute presence) should be covered by a story.
Flag tests written only to expand coverage when equivalent coverage already exists.
An excluded story is never screenshotted, so it must justify why it is excluded and how its behavior is covered.
- **FE2 (types)**:
Search the diff for `any`, `as unknown as`, non-null assertions in any form (`x!.y`, `items[0]!`, `fn()!`, `value! as T`), and new `as` casts.
Check that API data uses the generated type bindings; it should only make new types for component interfaces, favor named component props.
- **FE3 (reuse/scope)**:
For each new component, hook, or helper, search the shared components folder and sibling feature folders for an existing equivalent.
Flag near-duplicates, hand-assembled versions of wrapped primitives, dead branches, and unrelated changes bundled into the diff.
Flag new React hooks that an existing hook, a plain function, or component state could replace.
Several new single-use hooks in one diff is a FAIL.
- **FE4 (comments)**:
Read every comment line the diff adds or edits.
Flag any comment that restates the identifier, assertion, or control flow.
Verify surviving comments are factually correct.
No comments in function bodies.
- **FE5 (UI states)**:
For each view rendering server data, confirm loading, error, empty, and refetch handling.
Flag form or selection state that a background refetch would reset.
Ensure Pagination on all listed tables, FAIL if identified API implementation cannot safely paginate when required.
- **FE6 (a11y)**:
Flag interactive elements that are keyboard-unreachable, `aria-label`s that replace visible label text, `aria-*` props that the underlying primitive overwrites, and visually-hidden elements still in the tab order.
- **FE7 (react-query)**:
Flag direct `API.*`/`fetch` calls in components, string-literal query keys (must import the constant from `api/queries/`), `isLoading || isFetching` patterns, missing invalidation on mutation paths (including partial failure), and `mutateAsync` in `try/catch` with an empty catch.
- **FE8 (effects)**:
For every added or modified `useEffect`, apply the decision tree in `references/FRONTEND_PATTERNS.md`.
Flag derived state via `setState`-in-effect, fetches triggered by effects, new dependencies on effects that own connections, and effects that only write refs nobody reads.
- **FE9 (fixtures)**:
Flag inline entity literals that duplicate or deviate from established fixtures, and shared pre-wired query objects instead of per-story inline `{ key, data }` wiring.
Flag any `Object.defineProperty` replacement of a browser global in tests or stories.
- **FE10 (test queries)**:
Flag `querySelector`, class-name substring matches, geometry assertions, `behavior: "smooth"` dependence, and locale-less `toLocaleString()` in changed tests and stories.

## Output format

```
FE1 PASS
FE2 FAIL  ui/pages/FooPage/FooPage.tsx:42  `as unknown as Workspace` cast
FE3 PASS
...
```

One line per rule.
FAIL lines carry every finding (repeat the rule ID for multiple findings).
After fixes, print the re-run table. The audit is done when all rules PASS or remaining FAILs have a written justification.

## Notes

- This audit does not replace `pnpm format lint check`, or tests; those should have been run anyways.
- Report findings in the current diff only. Do not refactor pre-existing violations in untouched code; note them at most.