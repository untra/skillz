# Types and Names (TN)

Expands: FE2, and the nullable-fallback rule in FE5

## Reading order

1. The diff, searching for `any`, ` as `, `!.`, `!)`, `!;`, `@ts-`, `biome-ignore`, `eslint-disable`, `??`, `||`, and `==`.
2. The generated API types file (for example `api/typesGenerated.ts`) before judging any new type that describes server data.
3. The props interface of every changed component, and its call sites.

## Checkpoints

### TN1 Loose types (`blocking`)
Flag when: `any`, `as unknown as X`, or a non-null assertion in any form (`x!.y`, `items[0]!`, `fn()!`, `value! as T`).
Not a finding: `unknown` narrowed with a type guard.

### TN2 New casts (`should-fix`)
Flag when: a new `as` cast where an annotation, narrowing, or a fix at the type's source would work.
Not a finding: `as const`, or a cast at a genuine boundary (parsed JSON) followed by validation.

### TN3 Generated types (`should-fix`)
Flag when: a type re-declares or hand-copies the shape of API data that a generated type already describes.
Not a finding: a component props type that picks from or composes generated types.

### TN4 Optionality (`should-fix`)
Flag when: a prop the component needs to function is optional, a required prop has a silent default that hides a bug, or optional chaining guards a value the type says is always present.
Not a finding: optional props with meaningful defaults.

### TN5 Coercions (`should-fix`)
Flag when: `||` defaults a value where `0`, `""`, or `false` are valid (use `??`), loose `==`, implicit string/number coercion, or `!!` hiding a nullability bug.
Not a finding: `== null` used deliberately to match `null` and `undefined` if the repo allows it.

### TN6 Suppressions (`should-fix`)
Flag when: `@ts-ignore`, `@ts-expect-error`, `biome-ignore`, or `eslint-disable` is added where a better-typed alternative exists.
Not a finding: a documented, unavoidable suppression.

### TN7 Naming (`nit`)
Flag when: names break the repo's conventions (`onX` props vs `handleX` handlers, `is`/`has`/`should` booleans, PascalCase components), mislead about what the value holds, or abbreviate unclearly.
Not a finding: names that match the surrounding file's established convention.

### TN8 Copy and fallbacks (`nit`)
Flag when: user-facing text has inconsistent capitalization or tone with sibling UI, typos, or nullable display data renders as blank, `undefined`, or `null` instead of a visible fallback ("Untitled", "N/A").
Not a finding: copy explicitly set by product in the PR description.
