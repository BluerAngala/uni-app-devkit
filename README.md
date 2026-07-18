# uni-app-devkit

uni-app 全流程开发规范 — 一套规范，适配所有 AI agent 工具。

## 支持的工具

| 工具 | 项目级路径 | 全局路径 | 内容 |
|------|-----------|---------|------|
| **OMP** | `.omp/` | `~/.omp/agent/` | skills + rules + commands + prompts |
| **Claude Code** | `.claude/` | `~/.claude/` | skills + rules |
| **Agents** | `.agents/` | `~/.agents/` | skills + rules |
| **Codex** | `.codex/` | `~/.codex/` | skills |
| **Pi Agent** | `.pi/` | `~/.pi/` | skills + prompts |
| **OpenCode** | `.opencode/` | `~/.config/opencode/` | skills + commands |
| **GitHub Copilot** | `.github/` | `~/.github/` | skills + instructions |

## 安装

### 交互式（推荐）

```bash
git clone https://github.com/BluerAngala/uni-app-devkit.git /tmp/uni-app-devkit
bash /tmp/uni-app-devkit/setup.sh
```

交互式会让你选择：
1. **哪些工具** — 输入编号（如 `1,2,5`）或 `a` 全部
2. **安装范围** — 项目级（当前目录）或全局级（所有项目可用）

### 命令行

```bash
# 只装 OMP 和 Claude，项目级
bash setup.sh --tools omp,claude --scope project

# 只装 Pi Agent，全局级
bash setup.sh --tools pi --scope global

# 全部工具，项目级
bash setup.sh --tools omp,claude,agents,codex,pi,opencode,github --scope project

# 指定项目目录
bash setup.sh --tools omp --scope project /path/to/my-project
```

### OMP / Claude Code marketplace

```
/marketplace add BluerAngala/uni-app-devkit
/marketplace install uni-app-devkit@uni-app-devkit --scope project
```

### 卸载

```bash
bash setup.sh --uninstall /path/to/project
```

### 查看支持的工具

```bash
bash setup.sh --list
```

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
├── setup.sh                          ← 一键安装（交互式 / 命令行）
├── plugins/uni-app-devkit/
│   ├── rules/                        ← 共享规则
│   ├── skills/                       ← 共享技能
│   ├── commands/                     ← 共享命令
│   └── prompts/                      ← 共享提示
├── .omp-plugin/marketplace.json      ← OMP marketplace
└── .claude-plugin/marketplace.json   ← Claude marketplace

安装后项目内（符号链接 → 源文件）：
├── .omp/        ← OMP 原生
├── .claude/     ← Claude Code
├── .agents/     ← Agents
├── .codex/      ← Codex
├── .pi/         ← Pi Agent
├── .opencode/   ← OpenCode
└── .github/     ← GitHub Copilot
```

**设计原则：** 一份源文件，符号链接分发。`git pull` 一次，所有工具自动同步。

## License

MIT
