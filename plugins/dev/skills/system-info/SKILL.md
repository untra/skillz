---
name: system-info
description: Use when the user asks what OS, shell, architecture, or dev toolchain versions the current machine has, or when debugging behavior that may differ across machines or environments
---

# System Info

## Overview

Prints a snapshot of the host: OS, architecture, hostname, shell, and versions of common dev tools. Doubles as this repo's authoring template.

## Usage

Run the script for the current platform from this skill's directory. Run it — don't read it.

- Windows: `pwsh -File scripts/sysinfo.ps1` (fall back to `powershell -File scripts/sysinfo.ps1`)
- macOS / Linux: `sh scripts/sysinfo.sh`

Report the output to the user, calling out anything relevant to their question (e.g. a missing tool).

## Template notes

Skills in this repo follow this shape:

- The frontmatter `description` is the only always-loaded text. One line, third person, "Use when…" triggers only — never a summary of the workflow. `name` and `description` are the shared contract; other frontmatter is ignored by agents that do not know it.
- Keep this body small (hard ceiling 500 lines); it loads only on invocation.
- Name the action (run the OS script, spawn a sub-agent, read a reference file). Do not name a Claude, Grok, or Codex tool.
- Heavy reference material goes in a `references/` subdirectory, read on demand.
- Executable helpers go in `scripts/` as adjacent `.sh`/`.ps1` pairs with the same basename and identical output shape, selected by OS as above.
