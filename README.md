# skillz

untra's personal skills marketplace. Each skill is a single [Agent Skills](https://agentskills.io) `SKILL.md` (plus optional `scripts/` and `references/`), written once and loadable into Claude Code, OpenAI Codex, and GitHub Copilot.

Skills are grouped into category plugins:

```
plugins/<category>/skills/<skill-name>/SKILL.md
```

## Loading

**Claude Code**

```
/plugin marketplace add untra/skillz
/plugin install dev@skillz
```

**Codex** — symlink skill directories into `~/.codex/skills/` (or `.codex/skills/` in a project):

```sh
git clone https://github.com/untra/skillz && cd skillz
ln -s "$(pwd)"/plugins/*/skills/* ~/.codex/skills/
```

**Copilot** — copy or symlink skill directories into the consuming repo's `.github/skills/`.

## Authoring rules

The point of skills is spending context only when needed:

- The frontmatter `description` is the only text loaded every session. One line, third person, starting "Use when…" with concrete triggers — never a summary of the skill's workflow.
- The SKILL.md body loads only on invocation. Keep it under 500 lines.
- Heavy reference material lives in `references/` inside the skill, read on demand.
- Executable helpers live in `scripts/` as adjacent `.sh`/`.ps1` pairs with the same basename and identical output shape; agents run the one matching the OS (Windows → `.ps1`, otherwise → `.sh`) and never read them into context.

`plugins/dev/skills/system-info/` is the template — copy it to start a new skill.

## Adding

- **New skill:** create `plugins/<category>/skills/<name>/SKILL.md`.
- **New category:** create `plugins/<category>/.claude-plugin/plugin.json` and add an entry to `.claude-plugin/marketplace.json`.
