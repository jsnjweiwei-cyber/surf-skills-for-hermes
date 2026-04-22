---
name: install-surf-for-hermes
description: Safely install AskSurf's `surf` skill and CLI for Hermes Agent when the official `npx skills add asksurf-ai/surf-skills --skill surf` flow does not support Hermes directly.
version: 1.0.1
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [surf, asksurf, hermes, skill-install, cli]
---

# Install Surf for Hermes

Use this when a user wants the AskSurf `surf` skill usable inside Hermes Agent.

## Why this skill exists

The official command:

```bash
npx skills add asksurf-ai/surf-skills --skill surf
```

can fetch the repo and find the `surf` skill, but the `skills.sh` ecosystem does **not** support `hermes` as a valid `--agent` target. It supports agents like `codex`, `claude-code`, and `openclaw`, but **not Hermes**.

So for Hermes, the reliable approach is:
1. fetch `skills/surf/SKILL.md` from the repo
2. copy it into `~/.hermes/skills/custom/surf/SKILL.md`
3. install the actual `surf` CLI separately
4. verify both the skill and CLI

## Verified working procedure

### 1) Fetch the skill repo and inspect it

Clone or otherwise fetch:

```bash
https://github.com/asksurf-ai/surf-skills.git
```

The skill file is at:

```bash
skills/surf/SKILL.md
```

### 2) Install the skill into Hermes manually

Create this directory if needed:

```bash
~/.hermes/skills/custom/surf/
```

Copy the repo's file to:

```bash
~/.hermes/skills/custom/surf/SKILL.md
```

Verify:

```bash
hermes skills list | grep -i surf
```

Expected: a `surf` skill under category `custom`.

### 3) Install the Surf CLI

Useful endpoints discovered during setup:

- Docs page: `https://docs.asksurf.ai/cli/introduction`
- Installer script: `https://agent.asksurf.ai/cli/releases/install.sh`
- Binary CDN base: `https://downloads.asksurf.ai/cli/releases`

#### Preferred install

Use the official installer from the docs page.

#### Manual binary fallback

If the installer script hangs or is blocked in the current environment, do a manual binary install.

First discover the latest version:

```bash
curl -fsSL https://downloads.asksurf.ai/cli/releases/latest
```

For Linux x86_64 glibc, the verified binary path pattern is:

```bash
https://downloads.asksurf.ai/cli/releases/<version>/surf_linux_amd64
```

Checksums are at:

```bash
https://downloads.asksurf.ai/cli/releases/<version>/checksums.txt
```

Install the matching binary, verify checksum, make it executable, then run:

```bash
surf install --local
```

Verified install location:

```bash
~/.local/bin/surf
```

## Verification checklist

Run all of these:

```bash
hermes skills list | grep -i surf
surf --help
surf list-operations
surf market-price --symbol BTC --json
```

Success criteria:
- Hermes lists `surf`
- `surf --help` works
- `surf list-operations` works
- a real query like `surf market-price --symbol BTC --json` returns data

## Important findings / pitfalls

### `npx skills add` is not enough for Hermes

This command can fetch the skill:

```bash
npx skills add asksurf-ai/surf-skills --skill surf
```

but it enters agent-selection UI and does **not** install to Hermes.

This command fails:

```bash
npx skills add asksurf-ai/surf-skills --skill surf --agent hermes -y -g
```

with:
- `Invalid agents: hermes`

So do **not** rely on `skills.sh` to install directly into Hermes.

### Skill file alone is insufficient

The AskSurf `SKILL.md` calls commands like:

```bash
surf install
surf sync
surf market-price --symbol BTC --json
```

Therefore you must install the real `surf` CLI. Copying only the skill file will not make Surf usable.

### Docs vs hostnames

These endpoints were useful:
- Docs: `https://docs.asksurf.ai/cli/introduction`
- Installer script: `https://agent.asksurf.ai/cli/releases/install.sh`
- Binary CDN: `https://downloads.asksurf.ai/cli/releases`

Do not assume older `agents.asksurf.ai` links are the only working ones.

### Cleanup if SurfAgent was installed by mistake

If `surfagent` / SurfAgent MCP was installed instead of AskSurf `surf`, remove the SurfAgent-specific MCP/server/package/skill first, then continue with the AskSurf flow.
