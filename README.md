# skillz

![alt text](skillz.gif)

Personal skills marketplace. Each skill is a single [Agent Skills](https://agentskills.io) `SKILL.md` (plus optional `scripts/` and `references/`), written once and loadable into Claude Code, OpenAI Codex, and GitHub Copilot.

Skills are grouped into category plugins:

```
plugins/<category>/skills/<skill-name>/SKILL.md
```

## Loading

**Claude Code**

```
/plugin marketplace add untra/skillz
/plugin install dev@skillz
/plugin install frontend@skillz
```

**Grok** — reads `.claude-plugin/marketplace.json`, so there is no separate Grok index. A skill is a directory with a `SKILL.md`; Grok reloads when those files change. Inside this checkout, `.agents/skills/` loads with no install step. `~/.grok/skills/` is the native user directory.

```sh
grok plugin marketplace add untra/skillz
grok plugin install dev --trust
grok plugin install frontend --trust
grok plugin validate plugins/dev
grok inspect
```

**Codex** — `.agents/plugins/marketplace.json` is the marketplace, and each plugin has `plugins/<category>/.codex-plugin/plugin.json`.

```sh
codex plugin marketplace add untra/skillz
codex plugin add dev@skillz
codex plugin add frontend@skillz
```

Without the plugin CLI, symlink skill directories into `~/.codex/skills/` (or `.codex/skills/` in a project):

```sh
git clone https://github.com/untra/skillz && cd skillz
ln -s "$(pwd)"/plugins/*/skills/* ~/.codex/skills/
```

**Copilot** — copy or symlink skill directories into the consuming repo's `.github/skills/`.

## Authoring rules

The point of skills is spending context only when needed:

* *The frontmatter `description` is the only text loaded every session. One line, third person, starting "Use when…" with concrete triggers — never a summary of the skill's workflow. `name` and `description` are the shared contract; unknown frontmatter is ignored.
* *The SKILL.md body loads only on invocation. Keep it under 500 lines.
* *Name the action (run the OS script, spawn a sub-agent, read a reference file). Do not name a Claude, Grok, or Codex tool.
* *Heavy reference material lives in `references/` inside the skill, read on demand.
* *Executable helpers live in `scripts/` as adjacent `.sh`/`.ps1` pairs with the same basename and identical output shape; agents run the one matching the OS (Windows → `.ps1`, otherwise → `.sh`) and never read them into context.

`plugins/dev/skills/system-info/` is the template — copy it to start a new skill.

## Adding

- **New skill:** create `plugins/<category>/skills/<name>/SKILL.md`, then symlink it from `.agents/skills/<name>`.
- **New category:** create `plugins/<category>/.claude-plugin/plugin.json` and `plugins/<category>/.codex-plugin/plugin.json`, and add an entry to both `.claude-plugin/marketplace.json` and `.agents/plugins/marketplace.json`.

## Local `.agents/skills`

`.agents/skills/*` are symlinks to `plugins/<category>/skills/<name>`, so Codex and Grok see the same files while working in this checkout. Link them into the user skill directories to use them from other repos:

```sh
for n in .agents/skills/*/; do
  n=$(basename "$n")
  for d in ~/.claude/skills ~/.codex/skills ~/.grok/skills ~/.agents/skills; do
    mkdir -p "$d"
    ln -sfn "$PWD/.agents/skills/$n" "$d/$n"
  done
done
```
