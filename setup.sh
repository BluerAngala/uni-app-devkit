#!/bin/bash
# uni-app-devkit setup — 为当前项目配置所有支持的 AI agent 工具
# 用法: curl -fsSL <raw-url>/setup.sh | bash
# 或:   bash setup.sh [--uninstall]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR/plugins/uni-app-devkit"
PROJECT_DIR="${1:-.}"

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[uni-app-devkit]${NC} $*"; }
warn()  { echo -e "${YELLOW}[uni-app-devkit]${NC} $*"; }
error() { echo -e "${RED}[uni-app-devkit]${NC} $*" >&2; }

# ─── 卸载模式 ───
if [[ "${1:-}" == "--uninstall" ]]; then
  info "卸载中..."
  for target in \
    ".omp/rules" ".omp/commands" ".omp/prompts" ".omp/skills/uni-app-style-system" \
    ".omp/skills/uni-app-page-dev" ".omp/skills/uni-app-cloud-dev" \
    ".claude/rules" ".claude/skills/uni-app-style-system" \
    ".claude/skills/uni-app-page-dev" ".claude/skills/uni-app-cloud-dev" \
    ".agents/rules" ".agents/skills/uni-app-style-system" \
    ".agents/skills/uni-app-page-dev" ".agents/skills/uni-app-cloud-dev" \
    ".codex/skills/uni-app-style-system" ".codex/skills/uni-app-page-dev" ".codex/skills/uni-app-cloud-dev" \
    ".github/skills/uni-app-style-system" ".github/skills/uni-app-page-dev" ".github/skills/uni-app-cloud-dev" \
    ".github/instructions/uni-app-conventions.instructions.md" \
    ".github/instructions/uni-cloud-security.instructions.md" \
    ".github/instructions/uni-cross-platform.instructions.md" \
    ".pi/skills/uni-app-style-system" \
    ".pi/skills/uni-app-page-dev" \
    ".pi/skills/uni-app-cloud-dev" \
    ".pi/prompts/uni-code-review.md" \
    ".opencode/skills/uni-app-style-system" \
    ".opencode/skills/uni-app-page-dev" \
    ".opencode/skills/uni-app-cloud-dev" \
    ".opencode/commands/check-theme.md" \
    ".opencode/commands/scaffold-page.md" \
    ".opencode/commands/scaffold-cloud.md"; do
    if [ -L "$PROJECT_DIR/$target" ] || [ -d "$PROJECT_DIR/$target" ]; then
      rm -rf "$PROJECT_DIR/$target"
      info "  已移除 $target"
    fi
  done
  info "卸载完成"
  exit 0
fi

# ─── 辅助函数 ───
link_content() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    warn "  跳过 $dst（已存在，非符号链接）"
    return
  fi
  ln -s "$src" "$dst"
  info "  ✓ $(basename "$dst")"
}

info "安装 uni-app-devkit 到 $PROJECT_DIR"
echo ""

# ─── 1. OMP（原生格式，最高优先级） ───
info "OMP (.omp/)"
mkdir -p "$PROJECT_DIR/.omp"

# rules
for f in "$PLUGIN_DIR/rules/"*.md; do
  link_content "$f" "$PROJECT_DIR/.omp/rules/$(basename "$f")"
done

# skills
for dir in "$PLUGIN_DIR/skills/"*/; do
  name=$(basename "$dir")
  link_content "$dir" "$PROJECT_DIR/.omp/skills/$name"
done

# commands
for f in "$PLUGIN_DIR/commands/"*.md; do
  link_content "$f" "$PROJECT_DIR/.omp/commands/$(basename "$f")"
done

# prompts
for f in "$PLUGIN_DIR/prompts/"*.md; do
  link_content "$f" "$PROJECT_DIR/.omp/prompts/$(basename "$f")"
done

echo ""

# ─── 2. Claude Code (.claude/) ───
if [ -d "$PROJECT_DIR/.claude" ] || command -v claude &>/dev/null; then
  info "Claude Code (.claude/)"
  mkdir -p "$PROJECT_DIR/.claude"

  # skills
  for dir in "$PLUGIN_DIR/skills/"*/; do
    name=$(basename "$dir")
    link_content "$dir" "$PROJECT_DIR/.claude/skills/$name"
  done

  # rules
  for f in "$PLUGIN_DIR/rules/"*.md; do
    link_content "$f" "$PROJECT_DIR/.claude/rules/$(basename "$f")"
  done

  echo ""
fi

# ─── 3. Agents (.agents/) ───
info "Agents (.agents/)"
mkdir -p "$PROJECT_DIR/.agents"

for dir in "$PLUGIN_DIR/skills/"*/; do
  name=$(basename "$dir")
  link_content "$dir" "$PROJECT_DIR/.agents/skills/$name"
done

for f in "$PLUGIN_DIR/rules/"*.md; do
  link_content "$f" "$PROJECT_DIR/.agents/rules/$(basename "$f")"
done

echo ""

# ─── 4. Codex (.codex/) ───
if [ -d "$PROJECT_DIR/.codex" ] || command -v codex &>/dev/null; then
  info "Codex (.codex/)"
  mkdir -p "$PROJECT_DIR/.codex"

  for dir in "$PLUGIN_DIR/skills/"*/; do
    name=$(basename "$dir")
    link_content "$dir" "$PROJECT_DIR/.codex/skills/$name"
  done

  echo ""
fi

# ─── 5. GitHub Copilot (.github/) ───
if [ -d "$PROJECT_DIR/.github" ]; then
  info "GitHub Copilot (.github/)"

  # skills
  for dir in "$PLUGIN_DIR/skills/"*/; do
    name=$(basename "$dir")
    link_content "$dir" "$PROJECT_DIR/.github/skills/$name"
  done

  # rules → instructions 格式
  for f in "$PLUGIN_DIR/rules/"*.md; do
    basename_no_ext=$(basename "$f" .md)
    link_content "$f" "$PROJECT_DIR/.github/instructions/${basename_no_ext}.instructions.md"
  done

  echo ""
fi

# ─── 6. Pi Agent (.pi/) ───
info "Pi Agent (.pi/)"
mkdir -p "$PROJECT_DIR/.pi"

# skills
for dir in "$PLUGIN_DIR/skills/"*/; do
  name=$(basename "$dir")
  link_content "$dir" "$PROJECT_DIR/.pi/skills/$name"
done

# prompts
mkdir -p "$PROJECT_DIR/.pi/prompts"
for f in "$PLUGIN_DIR/prompts/"*.md; do
  link_content "$f" "$PROJECT_DIR/.pi/prompts/$(basename "$f")"
done

echo ""

# ─── 7. OpenCode (.opencode/) ───
info "OpenCode (.opencode/)"
mkdir -p "$PROJECT_DIR/.opencode"

# skills
for dir in "$PLUGIN_DIR/skills/"*/; do
  name=$(basename "$dir")
  link_content "$dir" "$PROJECT_DIR/.opencode/skills/$name"
done

# commands
for f in "$PLUGIN_DIR/commands/"*.md; do
  link_content "$f" "$PROJECT_DIR/.opencode/commands/$(basename "$f")"
done

echo ""

# ─── 8. 生成 AGENTS.md 入口（供 Codex / standalone AGENTS.md 发现） ───
AGENTS_FILE="$PROJECT_DIR/AGENTS.md"
if [ ! -f "$AGENTS_FILE" ]; then
  info "生成 AGENTS.md（Codex / agents-md 入口）"
  cat > "$AGENTS_FILE" << 'AGENTSEOF'
# uni-app 开发规范

本项目使用 uni-app-devkit 管理开发规范。

## 规范文件

所有规范文件通过符号链接统一管理，源文件在 `.omp/` 目录下：

- **编码约定** — `.omp/rules/uni-app-conventions.md`（Options API、标签、生命周期、样式、i18n）
- **安全规则** — `.omp/rules/uni-cloud-security.md`（权限校验、数据校验、JQL 安全）
- **跨端适配** — `.omp/rules/uni-cross-platform.md`（条件编译、CSS/API/导航差异）

## 设计系统

修改样式前，先读 `.omp/skills/uni-app-style-system/SKILL.md`。

核心规则：禁止硬编码颜色，用 `$uni-text-color`、`getTheme('primary-color')` 等 token 变量。

## 页面开发

新建页面前，先读 `.omp/skills/uni-app-page-dev/SKILL.md`。

## 云函数开发

新建云函数前，先读 `.omp/skills/uni-app-cloud-dev/SKILL.md`。
AGENTSEOF
  info "  ✓ AGENTS.md"
  echo ""
fi

info "安装完成！"
echo ""
info "已适配的工具:"
info "  ✓ OMP（原生）— .omp/"
info "  ✓ Claude Code — .claude/"
info "  ✓ Agents — .agents/"
info "  ✓ Codex — .codex/"
info "  ✓ GitHub Copilot — .github/"
info "  ✓ Standalone AGENTS.md — ./AGENTS.md"
info "  ✓ Pi Agent — .pi/"
info "  ✓ OpenCode — .opencode/"
echo ""
info "卸载: bash setup.sh --uninstall"
