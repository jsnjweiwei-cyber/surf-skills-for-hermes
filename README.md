# surf-skills-for-hermes

Public Hermes-compatible skills for AskSurf.

This repository packages two custom skills that make AskSurf usable inside Hermes Agent:

- `install-surf-for-hermes`
  - explains why the upstream `skills.sh` install flow is not enough for Hermes
  - documents the manual Hermes installation workflow
  - covers `surf` CLI installation and verification
- `surf`
  - teaches Hermes when and how to route crypto questions to the `surf` CLI
  - documents endpoint discovery, usage patterns, caveats, and troubleshooting

Chinese README: [README.zh-CN.md](README.zh-CN.md)

## Why this repo exists

AskSurf provides a powerful `surf` CLI and upstream skill content, but Hermes users may need a Hermes-specific packaging flow.
This repo gives you a ready-to-copy, GitHub-hosted layout that works well for:

- personal Hermes skill backups
- public sharing
- repeatable local installation
- documenting a Hermes-specific Surf workflow

## Repository layout

```text
skills/
  install-surf-for-hermes/
    SKILL.md
  surf/
    SKILL.md
install.sh
sync-to-hermes.sh
README.md
README.zh-CN.md
LICENSE
```

## Quick install

For new users, this is the recommended one-command setup. It installs both skills, installs the Surf CLI, syncs the API spec cache, and verifies that `surf` works:

```bash
chmod +x install.sh
./install.sh all
```

After this finishes successfully, Surf should be ready to use.

Install only one piece:

```bash
./install.sh install-surf-for-hermes   # helper skill only
./install.sh surf                      # surf skill + Surf CLI
./install.sh cli                       # Surf CLI only
```

## Sync active Hermes paths to this repo

If you want Hermes to load these skills directly from this repository via symlinks:

```bash
chmod +x sync-to-hermes.sh
./sync-to-hermes.sh
```

Check current link state only:

```bash
./sync-to-hermes.sh status
```

This keeps these active Hermes paths pointed at the repository source:

- `~/.hermes/skills/autonomous-ai-agents/install-surf-for-hermes`
- `~/.hermes/skills/custom/surf`

## Manual install into Hermes

Copy either skill into your Hermes custom skills directory.

```bash
mkdir -p ~/.hermes/skills/custom/install-surf-for-hermes
cp skills/install-surf-for-hermes/SKILL.md ~/.hermes/skills/custom/install-surf-for-hermes/SKILL.md

mkdir -p ~/.hermes/skills/custom/surf
cp skills/surf/SKILL.md ~/.hermes/skills/custom/surf/SKILL.md
```

Then verify:

```bash
hermes skills list | grep -E 'surf|install-surf'
```

## What each skill does

### install-surf-for-hermes

Use this when you want to install AskSurf support into Hermes and need a Hermes-compatible workflow.

### surf

Use this when you want Hermes to query live crypto data through the `surf` CLI instead of relying on stale model knowledge.

## Important note

`./install.sh all` is intended to leave a new user with a working Surf setup immediately:
- installs the two skill files
- installs the AskSurf CLI
- runs `surf sync`
- verifies `surf --help`, `surf list-operations`, and a live BTC price query

If `~/.local/bin` is not in the user's `PATH`, the script prints the exact command they need to add. In that case the CLI still works via the full path it prints.

## License

MIT
