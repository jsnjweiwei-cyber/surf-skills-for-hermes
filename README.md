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
README.md
README.zh-CN.md
LICENSE
```

## Quick install

```bash
chmod +x install.sh
./install.sh all
```

Install only one skill:

```bash
./install.sh install-surf-for-hermes
./install.sh surf
```

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

The skill files do not install the AskSurf CLI by themselves.
To actually use `surf`, install the CLI separately and verify with commands like:

```bash
surf --help
surf list-operations
surf market-price --symbol BTC --json
```

## License

MIT
