---
name: normalize-text
description: Use when source files need typographic punctuation or invisible Unicode characters (smart quotes, em dashes, ellipses, NBSP, zero-width spaces, BOMs) replaced with plain ASCII, for hidden-character cleanup or ASCII-safe punctuation checks; not where typographic characters are intentional.
---

# Normalize Text

Run the script for the current platform from this skill's directory. Run it — don't read it.

- Windows: `pwsh -File scripts/normalize-text.ps1` (fall back to `powershell -File scripts/normalize-text.ps1`)
- macOS / Linux: `sh scripts/normalize-text.sh` (requires `perl`)

Both recursively handle regular UTF-8 files and skip symlinks, `.git`, files containing NUL bytes, and files that are not valid UTF-8. Flags below use the `.sh` spelling; the `.ps1` equivalents are `-Check`, `-Verbose`, and `-Exclude a,b`.

Before changing files, inspect the requested scope:

```sh
sh scripts/normalize-text.sh --check PATH
```

Exit status `1` means normalization is needed; status `2` means an error occurred. Review the listed files, especially vendored or generated content. Add repeatable `--exclude DIRECTORY_NAME` options when those directories are outside the requested scope.

Apply the normalization only to the user-authorized path, then verify it:

```sh
sh scripts/normalize-text.sh PATH
sh scripts/normalize-text.sh --check PATH
```

The script makes these exact replacements:

- Em dash, en dash, and mathematical minus (`U+2014`, `U+2013`, `U+2212`) to `-`
- Curly double quotes (`U+201C`, `U+201D`) to `"`
- Curly single quotes (`U+2018`, `U+2019`) to `'`
- Horizontal ellipsis (`U+2026`) to `...`
- Non-breaking and narrow non-breaking spaces (`U+00A0`, `U+202F`) to an ASCII space
- Zero-width space and word joiner (`U+200B`, `U+2060`) to an ASCII space, not removed
- Byte order marks (`U+FEFF`) removed wherever they occur

Use `--verbose` to list files as they are changed. Do not reinterpret or expand the replacement set without an explicit request.
