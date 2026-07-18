# uni-app-devkit

uni-app 全流程开发规范 — 一套规范，适配所有 AI agent 工具。

## 适配的工具

| 工具 | 安装方式 | 生效路径 |
|------|---------|---------|
| **OMP** | `/marketplace install` | `.omp/` |
| **Claude Code** | `/marketplace install` 或 setup.sh | `.claude/` |
| **Codex** | `bash setup.sh` | `.codex/` + `AGENTS.md` |
| **OpenCode** | `bash setup.sh` | 符号链接到 `.omp/` |
| **Agents** | `bash setup.sh` | `.agents/` |
| **GitHub Copilot** | `bash setup.sh` | `.github/` |

## 安装

### 方式 1: OMP / Claude Code marketplace（推荐）

```
/marketplace add BluerAngala/uni-app-devkit
/marketplace install uni-app-devkit@uni-app-devkit --scope project
```

### 方式 2: setup.sh（通用，适配所有工具）

```bash
# 下载并执行
curl -fsSL https://raw.githubusercontent.com/BluerAngala/uni-app-devkit/main/setup.sh | bash

# 或 clone 后本地执行
git clone https://github.com/BluerAngala/uni-app-devkit.git /tmp/uni-app-devkit
bash /tmp/uni-app-devkit/setup.sh

# 卸载
bash /tmp/uni-app-devkit/setup.sh --uninstall
```

setup.sh 会：
1. 将 rules/skills/commands/prompts 符号链接到 `.omp/`
2. 检测已安装的工具，自动创建对应目录的符号链接
3. 生成 `AGENTS.md` 入口文件（供 Codex / standalone 发现）

## 包含内容

| 层 | 名称 | 作用 | 生效方式 |
|---|---|---|---|
| **rules** | `uni-app-conventions` | 编码约定 | 自动，始终生效 |
| **rules** | `uni-cloud-security` | 安全规则 | 自动，始终生效 |
| **rules** | `uni-cross-platform` | 跨端适配 | 自动，始终生效 |
| **skill** | `uni-app-style-system` | 设计系统 | 检测到样式修改时 |
| **skill** | `uni-app-page-dev` | 页面开发 | 检测到页面开发时 |
| **skill** | `uni-app-cloud-dev` | 云开发 | 检测到云函数开发时 |
| **command** | `/scaffold-page` | 页面脚手架 | 手动触发 |
| **command** | `/scaffold-cloud` | 云对象脚手架 | 手动触发 |
| **command** | `/check-theme` | 扫描硬编码颜色 | 手动触发 |
| **prompt** | `uni-code-review` | 代码审查 | 手动引用 |

## 架构

```
uni-app-devkit/                       ← 源文件（唯一维护点）
├── setup.sh                          ← 一键适配所有工具
├── plugins/uni-app-devkit/           ← marketplace plugin
│   ├── rules/                        ← 共享规则
│   ├── skills/                       ← 共享技能
│   ├── commands/                     ← 共享命令
│   └── prompts/                      ← 共享提示
└── .omp-plugin/marketplace.json      ← OMP catalog
└── .claude-plugin/marketplace.json   ← Claude catalog

安装后项目内：
├── .omp/                             ← 符号链接 → 源文件
├── .claude/                          ← 符号链接 → 源文件（如已安装）
├── .agents/                          ← 符号链接 → 源文件
├── .codex/                           ← 符号链接 → 源文件（如已安装）
├── .github/                          ← 符号链接 → 源文件（如已安装）
└── AGENTS.md                         ← 入口文件
```

**设计原则：** 一份源文件，符号链接分发。升级时 pull 一次，所有工具自动同步。

## License

MIT
