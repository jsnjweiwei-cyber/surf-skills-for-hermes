# Verified Surf install artifacts

This reference captures the exact working values verified in this environment during installation.

## Environment
- OS: Linux
- Arch: x86_64
- libc: glibc

## Verified version
- `latest`: `v1.0.4`

## Verified docs/install endpoints
- Docs: `https://docs.asksurf.ai/cli/introduction`
- Release bootstrap script: `https://agent.asksurf.ai/cli/releases/install.sh`
- Release CDN base: `https://downloads.asksurf.ai/cli/releases/`

## Verified binary
- Artifact: `surf_linux_amd64`
- URL: `https://downloads.asksurf.ai/cli/releases/v1.0.4/surf_linux_amd64`
- SHA256: `cfa9bbebaa5a11e2e4f179c7f21ef6b6d5919c35fbac9f316268502f11e1ee3f`

## Verified install sequence
```bash
curl -fsSL https://downloads.asksurf.ai/cli/releases/latest
curl -fsSLo /tmp/surf https://downloads.asksurf.ai/cli/releases/v1.0.4/surf_linux_amd64
printf 'cfa9bbebaa5a11e2e4f179c7f21ef6b6d5919c35fbac9f316268502f11e1ee3f  /tmp/surf\n' | sha256sum -c -
chmod +x /tmp/surf
/tmp/surf install --local
```

## Verified post-install state
- Installed binary path: `~/.local/bin/surf`
- Hermes skill path: `~/.hermes/skills/custom/surf/SKILL.md`

## Verified smoke tests
```bash
hermes skills list | grep -i surf
surf --help | head -40
surf list-operations | head -20
surf market-price --symbol BTC --json | head -40
```

## Maintenance note
If `latest` moves to a newer release, re-check:
1. the version string
2. artifact URL
3. checksum
4. whether install still lands at `~/.local/bin/surf`
