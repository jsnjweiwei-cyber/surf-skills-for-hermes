# surf-skills-for-hermes

A small GitHub repository that packages two Hermes-compatible custom skills related to AskSurf:

- `install-surf-skill-for-hermes`: manual installation workflow for making AskSurf usable in Hermes when the upstream `skills.sh` flow does not support Hermes directly
- `surf`: the runtime skill that teaches Hermes how to use the `surf` CLI for live crypto data

## Repository layout

```text
skills/
  install-surf-skill-for-hermes/
    SKILL.md
  surf/
    SKILL.md
```

## Included skills

### 1. install-surf-skill-for-hermes

Purpose:
- explain why `npx skills add asksurf-ai/surf-skills --skill surf` is insufficient for Hermes
- document the manual Hermes install path
- document how to install and verify the real `surf` CLI

### 2. surf

Purpose:
- teach Hermes when to route crypto questions to the `surf` CLI
- document discovery, usage patterns, endpoint selection, caveats, and troubleshooting

## Install into Hermes manually

Copy either skill into your Hermes custom skills directory.

Example:

```bash
mkdir -p ~/.hermes/skills/custom/install-surf-skill-for-hermes
cp skills/install-surf-skill-for-hermes/SKILL.md ~/.hermes/skills/custom/install-surf-skill-for-hermes/SKILL.md

mkdir -p ~/.hermes/skills/custom/surf
cp skills/surf/SKILL.md ~/.hermes/skills/custom/surf/SKILL.md
```

Then verify:

```bash
hermes skills list | grep -E 'surf|install-surf'
```

## Notes

- The skill files alone do not install the AskSurf CLI.
- To actually use `surf`, install the CLI separately and verify commands like:

```bash
surf --help
surf list-operations
surf market-price --symbol BTC --json
```

## License

MIT
