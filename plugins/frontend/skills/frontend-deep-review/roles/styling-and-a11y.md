# Styling and Accessibility (SA)

Expands: FE6

## Reading order

1. The diff, marking every className, style prop, CSS file, interactive element, and `aria-*` or `role` attribute.
2. For every primitive receiving `aria-*` or `role`: its source or docs, to check what it overwrites.
3. The theme or design-token files before judging any color, spacing, or z-index value.

## Checkpoints

### SA1 Styling discipline (`should-fix`)
Flag when: hard-coded colors, spacing, font sizes, or breakpoints bypass the design tokens or utility scale; inline `style` for static values; `!important`; or ad hoc z-index values.
Not a finding: dynamic values computed at runtime (positions, widths from measurements).

### SA2 Layout correctness (`should-fix`)
Flag when: text that can be long has no truncation or wrapping, fixed widths break on mobile, overflow is clipped unintentionally, or colors ignore dark mode.
Not a finding: layouts covered by an existing mobile or dark-mode story that still renders correctly.

### SA3 Keyboard reachability (`blocking`)
Flag when: a clickable `div` or `span` lacks a role, tab stop, and key handler; a disabled control hides its reason from keyboard users; or `tabIndex` greater than 0 is used.
Not a finding: native buttons, links, and inputs.

### SA4 Label in name (`should-fix`)
Flag when: an `aria-label` replaces or does not contain the visible label text.
Not a finding: icon-only buttons with a descriptive `aria-label`.

### SA5 Overwritten ARIA (`should-fix`)
Flag when: `aria-*` or `role` props are passed to a primitive that silently overwrites them (for example cmdk items and `aria-selected`).
Not a finding: props the primitive documents as forwarded.

### SA6 Hidden but focusable (`blocking`)
Flag when: a visually hidden or `opacity: 0` interactive element remains in the tab order or accessibility tree.
Not a finding: screen-reader-only text that is not interactive.

### SA7 Hard-coded IDs (`should-fix`)
Flag when: a form element, label, or ARIA relationship uses a hard-coded string ID in a component that can render more than once.
Not a finding: IDs generated with `React.useId()`.

### SA8 Focus management (`should-fix`)
Flag when: opening or closing a dialog, popover, or route transition drops focus to `body` or loses the user's position.
Not a finding: primitives that manage focus themselves.
