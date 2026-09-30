# Simplicity and Dead Code (SD)

Expands: FE3

## Reading order

1. The diff.
2. For every new export, prop, or constant: search the frontend directory for its usages.
3. For every new wrapper component or interface: open the thing it wraps.

## Checkpoints

### SD1 Single-use indirection (`nit`)
Flag when: a new constant, variable, or helper is used once and only renames a value or expression that is already clear inline.
Not a finding: a named constant that replaces a magic number or string, or a helper that isolates non-trivial logic for testing.

### SD2 Pass-through wrappers (`should-fix`)
Flag when: a new component, hook, or type only forwards its props or arguments to another one without adding behavior, defaults, or constraints.
Not a finding: a wrapper that pins a design-system variant, adds accessibility wiring, or narrows a type on purpose.

### SD3 Dead code (`should-fix`)
Flag when: the diff adds or leaves behind unused exports, props, parameters, imports, state, unreachable branches, or commented-out code.
Not a finding: exports consumed by stories or tests, or code the PR description says is staged for an immediate follow-up.

### SD4 Speculative generality (`should-fix`)
Flag when: a new abstraction, option, generic parameter, or config object has one caller (rule of three), or a prop exists for a variant nothing renders.
Not a finding: a public shared component whose API follows an existing sibling's convention.

### SD5 Readability (`nit`)
Flag when: nested ternaries, conditionals nested more than three deep, boolean-flag parameters that switch behavior, or long inline JSX expressions that an early return or a named variable would clarify.
Not a finding: a single ternary in JSX.

### SD6 Redundant logic (`nit`)
Flag when: `x ? true : false`, `!!` on an already-boolean value, `if (a) return true; return false;`, re-checking a condition already narrowed above, or spreading an object only to override every field.
Not a finding: a `Boolean()` coercion at a boundary where the type is genuinely wider.
