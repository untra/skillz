# Comments and Docs (CD)

Expands: FE4

## Reading order

1. Every comment line the diff adds or edits, including JSDoc and story descriptions.
2. The code directly below each comment, to verify it is still accurate.
3. For shared components: the props interface and any sibling component docs.

## Checkpoints

### CD1 Restating comments (`should-fix`)
Flag when: a comment repeats the identifier, the assertion, the type, or the control flow directly below it.
Not a finding: a comment that states why, an invariant, or an external constraint.

### CD2 Comments inside function bodies (`nit`)
Flag when: a comment sits inside a function or component body to narrate steps.
Not a finding: a 1 to 3 line comment above a genuinely non-obvious line (a browser quirk, a race, a library workaround).

### CD3 Stale or wrong comments (`blocking`)
Flag when: a comment contradicts the code it describes, references a removed identifier, or describes behavior the diff changed.
Not a finding: a comment on untouched code the diff does not affect.

### CD4 Missing explanation (`should-fix`)
Flag when: the diff adds a `@ts-ignore`, `@ts-expect-error`, `biome-ignore`, `eslint-disable`, a timeout or delay constant, a workaround, or an intentionally surprising branch with no reason given.
Not a finding: a suppression whose reason is on the same line.

### CD5 Untracked TODOs (`nit`)
Flag when: a new `TODO`, `FIXME`, or `HACK` has no issue link or owner.
Not a finding: a TODO that links an issue.

### CD6 Shared component docs (`nit`)
Flag when: a new prop on a shared or reusable component has a non-obvious contract (units, format, controlled vs uncontrolled, callback timing) and no JSDoc.
Not a finding: self-explanatory props (`disabled`, `children`, `className`).
