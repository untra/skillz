---
name: frontend-deep-review
description: Use when reviewing a frontend diff or PR in depth (many .tsx files, a pre-merge audit, or someone else's frontend PR) and parallel role-based reviewers are wanted rather than a single-pass FE rule check.
---

# Frontend Deep Review

Reviews a frontend diff according to expected quality benchmarks.
Every checkpoint in the `roles/` directory is a maintainer-flagged pattern to identify in a frontend code review.
The goal is to find and fix findings before a human reviewer notices.

The review is split into reviewer roles that run in parallel sub-agents. Each role owns a set of similar checks:

| Role file | Prefix | Owns |
| --- | --- | --- |
|`roles/simplicity-and-dead-code.md`|SD|single-use constants, interface wrappers, dead code, readability|
|`roles/comments-and-docs.md`|CD|comment quality, effective docs, missing explanations|
|`roles/tests-and-stories.md`|TS|effective test writing, minimal mocks, test hygiene|
|`roles/react-patterns.md`|RP|effects, refs, hooks, memoization, render helpers, component size, forms|
|`roles/organized-code.md`|OC|reuse tooling, limit duplication, file placement, change scope|
|`roles/styling-and-a11y.md`|SA|css discipline, layout correctness, abstractions and accessibility|
|`roles/types-and-names.md`|TN|optionality, coercions, generated types and conventions, naming and copy|
|`roles/data-flow.md`|DF|fetching data, mutations, query keys, ui states, browser storage|

The roles expand the FE rules in `../frontend-review/references/FRONTEND_PATTERNS.md`.

## Severity

Every finding carries one severity, most severe first:

| Severity | Meaning |
| --- | --- |
| `blocking` | a bug, regression, data loss, broken accessibility, or a security issue |
| `should-fix` | violates an FE rule or checkpoint; a reviewer would request changes |
| `nit` | style or readability polish; optional |

Role files give each checkpoint a default severity. Raise or lower it when the evidence warrants and say why.

## When to run

Run this skill when asked to review code with frontend changes, or with abundant `.tsx` file changes.
This skill complements the `frontend-review` skill; their checks are complementary.

Run this skill within the `ui/` directory or where the frontend code is reviewed.

```sh
BASE=$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main)
git diff --stat "$BASE" -- ui/ | tail -1
git diff --name-only "$BASE" -- ui/
```

For a PR authored by someone else, use `gh pr diff <n> --name-only` instead.

Record for the reviewers:
- the review target (branch, commit range, PR number)
- the list of changed files
- the PR's stated purpose (title and description summary)

If a file diff is over 1000 added lines, note that. Identify any files that are in excess of 1000 lines.

### Spawn the reviewers

Spawn each role as its own parallel read-only sub-agent that shares this checkout and has access to the `ui/` directory of frontend changes.
Use the prompt in `reviewer-prompt.md`, filling in the role file, target, file list and purpose.
Every role runs on the diff; a role with nothing to flag reports "No findings." quickly.
If the harness cannot spawn sub-agents, or caps parallelism, work through the roles one at a time.
Each reviewer returns its findings in its last message. Reviewers have read-only file access.

### Collect and cross-check

Read each reviewer report one at a time, and build a list of findings.
Then:
- resolve conflicts between findings with overlapping blast radius.
- deduplicate findings that are symptoms of a shared root cause; keep the one owned by the most specific role.
- route each "Outside my role" note to its owning prefix and keep it only if that role missed it.
- drop any finding without sufficient evidence or a clear identification of the defect.

### Report and fix

Print one verdict table with every checkpoint, grouped by role.
Each FAIL line reports every finding with its severity and `file:line`, sorted most severe first.

- In self-review, on this branch: fix the `blocking` and `should-fix` findings in severity order. Stop when all findings have been addressed or explicitly justified.
- When reviewing someone else's PR: post findings as inline review comments. Use short, specific suggestions with the advised fix.
