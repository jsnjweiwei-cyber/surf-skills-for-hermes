# Cleanup / rollback: Surf on Hermes

Use this when a Surf install was partial, broken, or needs to be reset before reinstalling.

## What to remove

### 1) Remove the Surf CLI binary
```bash
rm -f ~/.local/bin/surf
```

### 2) Remove the Hermes Surf skill
Delete this directory if present:
- `~/.hermes/skills/custom/surf`

### 3) Remove temporary clone directory if present
Delete this directory if present:
- `/tmp/surf-skills`

### 4) Optional: remove Surf local state/cache if needed
Only do this if the user wants a deeper reset. Remove these directories if present:
- `~/.surf`
- `~/.config/surf`

## Verification after cleanup
```bash
command -v surf || true
hermes skills list | grep -i surf || true
```

Expected result:
- `command -v surf` prints nothing
- `hermes skills list` no longer shows `surf`

## Reinstall order
If reinstalling after cleanup, use this order:
1. clone `asksurf-ai/surf-skills`
2. copy `skills/surf/SKILL.md` into `~/.hermes/skills/custom/surf/SKILL.md`
3. install `surf` CLI
4. run smoke tests

## Rule of thumb
If Hermes still cannot use Surf after reinstall:
- check `command -v surf`
- check `hermes skills list`
- run `surf --help`
- run `surf list-operations`
- run `surf market-price --symbol BTC --json`
