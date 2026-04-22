---
name: install-surf-for-hermes
description: Install AskSurf's `surf` skill and CLI for Hermes Agent with a simple copy-based flow.
version: 1.0.2
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [surf, asksurf, hermes, skill-install, cli]
---

# Install Surf for Hermes

Use this when a user wants Hermes to use AskSurf `surf` and needs the simplest working install path.

## Recommended install

From this repository, run:

```bash
chmod +x install.sh
./install.sh all
```

That does everything needed for a new user:
- installs `install-surf-for-hermes` into `~/.hermes/skills/custom/`
- installs `surf` into `~/.hermes/skills/custom/`
- installs the real Surf CLI
- runs `surf sync`
- verifies Surf with a live query

## If the user wants manual install

Copy the skill files:

```bash
mkdir -p ~/.hermes/skills/custom/install-surf-for-hermes
cp skills/install-surf-for-hermes/SKILL.md ~/.hermes/skills/custom/install-surf-for-hermes/SKILL.md

mkdir -p ~/.hermes/skills/custom/surf
cp skills/surf/SKILL.md ~/.hermes/skills/custom/surf/SKILL.md
```

Then install the CLI:

```bash
./install.sh cli
```

## Why this exists

The upstream command:

```bash
npx skills add asksurf-ai/surf-skills --skill surf
```

is not enough for Hermes. The `skills.sh` flow does not support `hermes` as a direct install target, so the reliable Hermes approach is:
- copy the skill files into `~/.hermes/skills/custom/`
- install the real `surf` CLI
- verify everything works

## Verification

Run:

```bash
hermes skills list | grep -E 'surf|install-surf'
surf --help
surf list-operations
surf market-price --symbol BTC --json
```

Success means:
- Hermes lists the installed skills
- `surf --help` works
- `surf list-operations` works
- the BTC price query returns data

## Important note

Copying `SKILL.md` files alone is not enough. The real `surf` CLI must also be installed.

## Useful endpoints

- Docs: `https://docs.asksurf.ai/cli/introduction`
- Installer script: `https://agent.asksurf.ai/cli/releases/install.sh`
- Binary CDN: `https://downloads.asksurf.ai/cli/releases`
