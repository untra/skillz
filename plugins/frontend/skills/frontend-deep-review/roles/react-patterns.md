# React Patterns (RP)

Expands: FE8, and the `key` rule in FE5

## Reading order

1. The diff, marking every added or modified `useEffect`, `useLayoutEffect`, `useRef`, `useMemo`, `useCallback`, custom hook, and `key` prop.
2. The whole component file for each mark, so dependencies and consumers are visible.
3. For new hooks: search the hooks folders for an existing equivalent.

## Checkpoints

### RP1 Effect decision tree (`should-fix`)
Flag when: an effect handles something that could be computed in render, belongs in an event handler, or is server data that belongs in a query (FE8 steps 1 to 3).
Not a finding: an effect that synchronizes with an external system (WebSocket, DOM API, subscription, timer).

### RP2 Derived state in effects (`should-fix`)
Flag when: an effect reads state or props and calls a setter to mirror or derive another value.
Not a finding: a setter called from an external subscription callback inside the effect.

### RP3 Effect dependencies (`blocking`)
Flag when: a dependency added to an effect that owns a connection or triggers a fetch would reconnect or refetch on unrelated changes, or can loop (an effect on `isFetching`, on an object recreated every render).
Not a finding: stable dependencies (setters, refs, memoized values with stable inputs).

### RP4 Refs (`should-fix`)
Flag when: a ref is written but never read, a ref holds a value that should trigger a render, or a ref is read during render.
Not a finding: refs for DOM nodes, timers, or latest-callback patterns read inside handlers or effects.

### RP5 New hooks (`should-fix`)
Flag when: a new custom hook could be an existing hook, a plain function, or local state; or the diff adds several single-use hooks.
Not a finding: a hook that encapsulates an effect or subscription reused by two or more components.

### RP6 Memoization (`nit`)
Flag when: `useMemo`/`useCallback` wraps cheap work whose identity nobody depends on, or a value passed to a memoized child or effect dependency is recreated every render without memoization.
Not a finding: the codebase uses the React Compiler and the diff follows its conventions.

### RP7 Render helpers (`nit`)
Flag when: a component defines `renderX()` functions or inline components inside its body that should be separate components.
Not a finding: a small inline map callback.

### RP8 Component size and responsibility (`should-fix`)
Flag when: a component grows past roughly 300 lines, or mixes data fetching, business logic, and presentation that could split along an existing container/view convention.
Not a finding: a long but flat declarative layout.

### RP9 Keys (`blocking`)
Flag when: array index keys on lists that reorder, insert, or delete; `key={String(booleanState)}` or other keys used to force a remount; or unstable keys generated during render.
Not a finding: index keys on static lists.

### RP10 Forms (`should-fix`)
Flag when: an input switches between controlled and uncontrolled, validation runs on every keystroke without need, the repo's form library conventions are bypassed, or submit handlers ignore pending state and allow double submits.
Not a finding: a simple uncontrolled input read on submit.
