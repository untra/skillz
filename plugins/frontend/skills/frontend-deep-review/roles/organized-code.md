# Organized Code (OC)

Expands: FE3

## Reading order

1. The changed file list, noting new files and their folders.
2. For every new component, hook, or helper: search the shared components folder, hooks, utils, and sibling feature folders for an existing equivalent.
3. The PR purpose, to judge scope.

## Checkpoints

### OC1 Existing equivalent (`should-fix`)
Flag when: a new component, hook, or helper duplicates or nearly duplicates one that already exists in the repo.
Not a finding: a deliberate fork the PR description justifies.

### OC2 Hand-assembled primitives (`should-fix`)
Flag when: the diff assembles the underlying pieces of a wrapped primitive (Combobox, dialog, table, popover, tooltip) instead of using the wrapper.
Not a finding: the wrapper lacks a needed capability and the diff extends the wrapper instead.

### OC3 Duplication within the diff (`should-fix`)
Flag when: the same logic or JSX block appears three or more times in the diff (rule of three), or twice with copy-paste drift that already diverges.
Not a finding: two similar blocks that are likely to diverge.

### OC4 File placement (`nit`)
Flag when: a file lands outside the folder convention its siblings follow (feature folder vs shared, test and story colocation, barrel exports), or a feature-specific module is placed in a shared folder.
Not a finding: placement that matches the nearest sibling.

### OC5 Change scope (`should-fix`)
Flag when: the diff bundles unrelated refactors, renames, formatting sweeps, or drive-by fixes that do not serve the PR's stated purpose.
Not a finding: a minimal fix required for the change to work.

### OC6 File size (`nit`)
Flag when: a changed file exceeds 1000 lines, or the diff adds over 1000 lines to one file.
Not a finding: generated files.
