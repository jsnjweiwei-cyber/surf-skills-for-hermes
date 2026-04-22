# Troubleshooting: Surf on Hermes

This note captures the failure modes already observed while wiring AskSurf into Hermes.

## Problem 1: `npx skills add ...` succeeds, but Hermes still does not see `surf`

### Symptom
You run:
```bash
npx skills add asksurf-ai/surf-skills --skill surf
```
and it clones the repo, but later:
```bash
hermes skills list
```
does not show `surf`.

### Cause
The `skills.sh` installer targets its own supported agent list and **does not support Hermes as an install target**.

### Verified evidence
Attempting:
```bash
npx skills add asksurf-ai/surf-skills --skill surf --agent hermes -y -g
```
returned an invalid-agent error for `hermes`.

### Fix
Do not rely on `skills.sh` to install into Hermes. Instead:
1. clone `asksurf-ai/surf-skills`
2. copy `skills/surf/SKILL.md` into `~/.hermes/skills/custom/surf/SKILL.md`
3. install the `surf` CLI separately

---

## Problem 2: Hermes has the `surf` skill, but `surf` command is missing

### Symptom
- `hermes skills list` shows `surf`
- but `command -v surf` returns nothing

### Cause
The skill file is only instructions. The actual runtime dependency is the standalone `surf` CLI.

### Fix
Install the CLI, then verify:
```bash
command -v surf
surf --help
```

---

## Problem 3: Bootstrap install can be flaky or time out

### Symptom
A bootstrap-based install path may hang or time out in some environments.

### Cause
The bootstrap step downloads the binary and then runs a local install step, which may take longer than expected in some tool environments.

### Fix
Use the direct binary route instead of a bootstrap shell pipe.

Reference flow:
```bash
curl -fsSL https://downloads.asksurf.ai/cli/releases/latest
curl -fsSLo /tmp/surf https://downloads.asksurf.ai/cli/releases/v1.0.4/surf_linux_amd64
printf 'cfa9bbebaa5a11e2e4f179c7f21ef6b6d5919c35fbac9f316268502f11e1ee3f  /tmp/surf\n' | sha256sum -c -
chmod +x /tmp/surf
/tmp/surf install --local
```

See also: `references/verified-artifacts.md`

---

## Problem 4: Docs domain and installer/binary domains differ

### Symptom
The skill text may mention one domain while the working installer/docs appear under another.

### Verified working endpoints
- Docs: `https://docs.asksurf.ai/cli/introduction`
- Binary CDN: `https://downloads.asksurf.ai/cli/releases/...`

### Guidance
Treat the docs domain and binary CDN as separate but legitimate parts of the same install path.

---

## Problem 5: Need to confirm install really worked

### Minimum smoke test
```bash
hermes skills list | grep -i surf
command -v surf
surf --help | head -40
surf list-operations | head -20
surf market-price --symbol BTC --json | head -40
```

### Success criteria
- Hermes lists `surf`
- shell finds `surf`
- command help works
- operation discovery works
- live data command returns JSON

---

## Rule of thumb
If Hermes cannot use Surf yet, check in this order:
1. Does `hermes skills list` show `surf`?
2. Does `command -v surf` resolve?
3. Does `surf --help` run?
4. Does `surf list-operations` return endpoints?
5. Does a real call like `surf market-price --symbol BTC --json` succeed?
