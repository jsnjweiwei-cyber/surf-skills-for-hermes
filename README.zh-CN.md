# surf-skills-for-hermes

这是一个面向 Hermes Agent 的公开技能仓库，收录了两个与 AskSurf 相关的自定义 skill：

- `install-surf-for-hermes`
  - 说明如何在 Hermes 中手动安装 AskSurf skill
  - 解决官方 `skills.sh` 流程暂不直接支持 Hermes 的问题
- `surf`
  - 教 Hermes 在处理加密货币相关问题时，如何正确调用 `surf` CLI 获取实时数据

## 仓库结构

```text
skills/
  install-surf-for-hermes/
    SKILL.md
  surf/
    SKILL.md
install.sh
```

## 适用场景

如果你遇到下面这些需求，这个仓库就是为你准备的：

- 想让 Hermes Agent 使用 AskSurf 的 `surf` 能力
- 想在 Hermes 里查询实时币价、钱包、DeFi、链上、预测市场等数据
- 想把一套可复用的 Surf 技能文件公开托管在 GitHub 上

## 快速安装

给仓库里的安装脚本执行权限后，直接安装：

```bash
chmod +x install.sh
./install.sh all
```

只安装单个 skill：

```bash
./install.sh install-surf-for-hermes
./install.sh surf
```

## 手动安装

```bash
mkdir -p ~/.hermes/skills/custom/install-surf-for-hermes
cp skills/install-surf-for-hermes/SKILL.md ~/.hermes/skills/custom/install-surf-for-hermes/SKILL.md

mkdir -p ~/.hermes/skills/custom/surf
cp skills/surf/SKILL.md ~/.hermes/skills/custom/surf/SKILL.md
```

安装后可验证：

```bash
hermes skills list | grep -E 'surf|install-surf'
```

## 说明

- skill 文件本身不会自动安装 AskSurf CLI。
- 如果你要真正使用 `surf`，仍需单独安装 CLI，并验证：

```bash
surf --help
surf list-operations
surf market-price --symbol BTC --json
```

## License

MIT
