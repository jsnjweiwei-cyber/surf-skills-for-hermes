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

对新用户来说，推荐直接执行这一条。它会：
- 安装两个 skill
- 安装 Surf CLI
- 执行 `surf sync`
- 验证 `surf` 已能正常使用

```bash
chmod +x install.sh
./install.sh all
```

执行成功后，用户应当就可以直接使用 Surf。

如果只想安装部分内容：

```bash
./install.sh install-surf-for-hermes   # 只安装辅助说明 skill
./install.sh surf                      # 安装 surf skill + Surf CLI
./install.sh cli                       # 只安装 / 更新 Surf CLI
```

## 手动安装

如果你不想用安装脚本，也可以直接手动复制这两个 skill 文件：

```bash
mkdir -p ~/.hermes/skills/custom/install-surf-for-hermes
cp skills/install-surf-for-hermes/SKILL.md ~/.hermes/skills/custom/install-surf-for-hermes/SKILL.md

mkdir -p ~/.hermes/skills/custom/surf
cp skills/surf/SKILL.md ~/.hermes/skills/custom/surf/SKILL.md
```

然后执行下面这条命令安装 Surf CLI：

```bash
./install.sh cli
```

安装后可验证：

```bash
hermes skills list | grep -E 'surf|install-surf'
```

## 说明

`./install.sh all` 的目标就是让新用户执行完后即可直接使用 Surf：
- 安装两个 skill 文件
- 安装 AskSurf CLI
- 自动执行 `surf sync`
- 自动验证 `surf --help`、`surf list-operations` 和 BTC 实时报价查询

如果用户的 `PATH` 里暂时没有 `~/.local/bin`，脚本会提示该怎么加；在此之前也仍然可以用脚本输出的完整路径直接执行 Surf。

## License

MIT
