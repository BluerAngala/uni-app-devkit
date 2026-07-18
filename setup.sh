#!/bin/bash
# uni-app-devkit setup — 按需引入，支持全局/项目级安装
# 用法:
#   bash setup.sh                          # 交互式选择
#   bash setup.sh --tools omp,claude --scope project   # 命令行指定
#   bash setup.sh --list                   # 列出支持的工具
#   bash setup.sh --uninstall              # 卸载

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$SCRIPT_DIR/plugins/uni-app-devkit"

# ─── 颜色 ───
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[0;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${GREEN}[devkit]${NC} $*"; }
warn()  { echo -e "${YELLOW}[devkit]${NC} $*"; }
err()   { echo -e "${RED}[devkit]${NC} $*" >&2; }

# ─── 工具注册表 ───
# 格式: id|名称|项目级目录|全局目录|检测命令
TOOLS=(
  "omp|OMP / Pi Agent 原生|.omp|~/.omp/agent|omp"
  "claude|Claude Code|.claude|~/.claude|claude"
  "agents|Agents (.agents/)|.agents|~/.agents|"
  "codex|Codex|.codex|~/.codex|codex"
  "pi|Pi Agent (.pi/)|.pi|~/.pi|"
  "opencode|OpenCode|.opencode|~/.config/opencode|opencode"
  "github|GitHub Copilot|.github|~/.github|"
)

# 工具支持的内容类型
# skills = 技能, rules = 规则, commands = 命令, prompts = 提示
TOOL_CAPS=(
  "omp:skills,rules,commands,prompts"
  "claude:skills,rules"
  "agents:skills,rules"
  "codex:skills"
  "pi:skills,prompts"
  "opencode:skills,commands"
  "github:skills,rules"
)

get_tool_cap() {
  for cap in "${TOOL_CAPS[@]}"; do
    if [[ "$cap" == "$1:"* ]]; then
      echo "${cap#*:}"
      return
    fi
  done
  echo ""
}

# ─── 辅助函数 ───
link_content() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -e "$dst" ]; then
    warn "  跳过 $(basename "$dst")（已存在，非符号链接）"
    return
  fi
  ln -sf "$src" "$dst"
  info "  ✓ $(basename "$dst")"
}

install_component() {
  local tool_id="$1" target_dir="$2" caps="$3"

  IFS=',' read -ra CAP_LIST <<< "$caps"
  for cap in "${CAP_LIST[@]}"; do
    case "$cap" in
      skills)
        for dir in "$PLUGIN_DIR/skills/"*/; do
          name=$(basename "$dir")
          link_content "$dir" "$target_dir/skills/$name"
        done
        ;;
      rules)
        # GitHub Copilot 需要 .instructions.md 格式
        if [[ "$tool_id" == "github" ]]; then
          for f in "$PLUGIN_DIR/rules/"*.md; do
            basename_no_ext=$(basename "$f" .md)
            link_content "$f" "$target_dir/instructions/${basename_no_ext}.instructions.md"
          done
        else
          for f in "$PLUGIN_DIR/rules/"*.md; do
            link_content "$f" "$target_dir/rules/$(basename "$f")"
          done
        fi
        ;;
      commands)
        for f in "$PLUGIN_DIR/commands/"*.md; do
          link_content "$f" "$target_dir/commands/$(basename "$f")"
        done
        ;;
      prompts)
        for f in "$PLUGIN_DIR/prompts/"*.md; do
          link_content "$f" "$target_dir/prompts/$(basename "$f")"
        done
        ;;
    esac
  done
}

# ─── 列出支持的工具 ───
if [[ "${1:-}" == "--list" ]]; then
  echo "支持的工具:"
  echo ""
  for entry in "${TOOLS[@]}"; do
    IFS='|' read -r id name proj_dir global_dir cmd <<< "$entry"
    caps=$(get_tool_cap "$id")
    printf "  %-12s %-25s 项目: %-10s 全局: %-20s 内容: %s\n" "$id" "$name" "$proj_dir" "$global_dir" "$caps"
  done
  echo ""
  echo "用法:"
  echo "  bash setup.sh                                    # 交互式"
  echo "  bash setup.sh --tools omp,claude --scope project # 命令行"
  echo "  bash setup.sh --uninstall                        # 卸载"
  exit 0
fi

# ─── 卸载 ───
if [[ "${1:-}" == "--uninstall" ]]; then
  # 解析 PROJECT_DIR
  UNINSTALL_DIR="."
  shift
  for arg in "$@"; do
    case "$arg" in
      --*) ;;
      *) UNINSTALL_DIR="$arg" ;;
    esac
  done

  info "卸载中... ($UNINSTALL_DIR)"
  for entry in "${TOOLS[@]}"; do
    IFS='|' read -r id name proj_dir global_dir cmd <<< "$entry"
    caps=$(get_tool_cap "$id")
    [ -z "$caps" ] && continue

    IFS=',' read -ra CAP_LIST <<< "$caps"
    for cap in "${CAP_LIST[@]}"; do
      case "$cap" in
        skills)
          for sname in uni-app-style-system uni-app-page-dev uni-app-cloud-dev uni-testing uni-hbuilderx-cli; do
            target="$UNINSTALL_DIR/$proj_dir/skills/$sname"
            [ -L "$target" ] && { rm "$target"; info "  已移除 $target"; }
          done ;;
        rules)
          if [[ "$id" == "github" ]]; then
            for rname in uni-app-conventions uni-cloud-security uni-cross-platform uni-http uni-state-management uni-typescript uni-i18n uni-git uni-performance; do
              target="$UNINSTALL_DIR/$proj_dir/instructions/${rname}.instructions.md"
              [ -L "$target" ] && { rm "$target"; info "  已移除 $target"; }
            done
          else
            for rname in uni-app-conventions.md uni-cloud-security.md uni-cross-platform.md uni-http.md uni-state-management.md uni-typescript.md uni-i18n.md uni-git.md uni-performance.md; do
              target="$UNINSTALL_DIR/$proj_dir/rules/$rname"
              [ -L "$target" ] && { rm "$target"; info "  已移除 $target"; }
            done
          fi ;;
        commands)
          for cname in scaffold-page.md scaffold-cloud.md check-theme.md; do
            target="$UNINSTALL_DIR/$proj_dir/commands/$cname"
            [ -L "$target" ] && { rm "$target"; info "  已移除 $target"; }
          done ;;
        prompts)
          for pname in uni-code-review.md; do
            target="$UNINSTALL_DIR/$proj_dir/prompts/$pname"
            [ -L "$target" ] && { rm "$target"; info "  已移除 $target"; }
          done ;;
      esac
    done
  done

  # 清理 AGENTS.md
  if [ -f "$UNINSTALL_DIR/AGENTS.md" ] && grep -q "uni-app-devkit" "$UNINSTALL_DIR/AGENTS.md" 2>/dev/null; then
    rm "$UNINSTALL_DIR/AGENTS.md"
    info "  已移除 AGENTS.md"
  fi

  info "卸载完成"
  exit 0
fi

# ─── 解析命令行参数 ───
SELECTED_TOOLS=""
SCOPE=""
PROJECT_DIR="."

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tools)
      SELECTED_TOOLS="$2"; shift 2 ;;
    --scope)
      SCOPE="$2"; shift 2 ;;
    --list|--uninstall)
      ;; # handled elsewhere
    *)
      PROJECT_DIR="$1"; shift ;;
  esac
done

# ─── 交互式选择 ───
if [ -z "$SELECTED_TOOLS" ]; then
  echo ""
  echo -e "${CYAN}uni-app-devkit 安装向导${NC}"
  echo ""
  echo "选择要适配的工具（输入编号，逗号分隔，如 1,2,5）："
  echo ""
  TOOL_IDS_LIST=()
  idx=1
  for entry in "${TOOLS[@]}"; do
    IFS='|' read -r id name proj_dir global_dir cmd <<< "$entry"
    printf "  %d) %-12s %s\n" "$idx" "$id" "$name"
    TOOL_IDS_LIST+=("$id")
    ((idx++))
  done
  echo "  a) 全部"
  echo ""
  read -rp "请选择 [1-${#TOOLS[@]}/a]: " choice

  if [[ "$choice" == "a" || "$choice" == "A" ]]; then
    SELECTED_TOOLS=""
    for entry in "${TOOLS[@]}"; do
      IFS='|' read -r id name proj_dir global_dir cmd <<< "$entry"
      SELECTED_TOOLS="${SELECTED_TOOLS:+$SELECTED_TOOLS,}$id"
    done
  else
    IFS=',' read -ra NUMS <<< "$choice"
    for n in "${NUMS[@]}"; do
      n=$(echo "$n" | xargs)
      idx_val=$((n - 1))
      if [[ $idx_val -ge 0 && $idx_val -lt ${#TOOL_IDS_LIST[@]} ]]; then
        SELECTED_TOOLS="${SELECTED_TOOLS:+$SELECTED_TOOLS,}${TOOL_IDS_LIST[$idx_val]}"
      else
        err "无效选项: $n"
        exit 1
      fi
    done
  fi

  echo ""
  echo "安装范围："
  echo "  1) 项目级（当前目录，符号链接）"
  echo "  2) 全局级（用户目录，所有项目可用）"
  echo ""
  read -rp "请选择 [1/2]: " scope_choice
  case "$scope_choice" in
    1) SCOPE="project" ;;
    2) SCOPE="global" ;;
    *) err "无效选项"; exit 1 ;;
  esac
fi

# 默认项目级
SCOPE="${SCOPE:-project}"

echo ""
info "安装 uni-app-devkit"
info "  范围: $SCOPE"
info "  工具: $SELECTED_TOOLS"
echo ""

# ─── 执行安装 ───
IFS=',' read -ra TOOL_IDS <<< "$SELECTED_TOOLS"
INSTALLED=()

for tool_id in "${TOOL_IDS[@]}"; do
  tool_id=$(echo "$tool_id" | xargs)  # trim

  # 查找工具定义
  found=false
  for entry in "${TOOLS[@]}"; do
    IFS='|' read -r id name proj_dir global_dir cmd <<< "$entry"
    if [[ "$id" == "$tool_id" ]]; then
      found=true
      break
    fi
  done

  if ! $found; then
    err "未知工具: $tool_id"
    continue
  fi

  caps=$(get_tool_cap "$tool_id")
  if [ -z "$caps" ]; then
    warn "工具 $tool_id 无可用内容，跳过"
    continue
  fi

  info "$name ($tool_id)"

  if [[ "$SCOPE" == "project" ]]; then
    target_dir="$PROJECT_DIR/$proj_dir"
  else
    target_dir="${global_dir/#\~/$HOME}"
  fi

  install_component "$tool_id" "$target_dir" "$caps"
  INSTALLED+=("$tool_id ($SCOPE → $target_dir)")
  echo ""
done

# ─── 生成 AGENTS.md（项目级且不存在时） ───
if [[ "$SCOPE" == "project" ]] && [ ! -f "$PROJECT_DIR/AGENTS.md" ]; then
  info "生成 AGENTS.md"
  cat > "$PROJECT_DIR/AGENTS.md" << 'AGENTSEOF'
# uni-app 开发规范

本项目使用 [uni-app-devkit](https://github.com/BluerAngala/uni-app-devkit) 管理开发规范。

## 规范文件

- **编码约定** — 禁止 Options API 以外写法、禁止硬编码颜色、禁止 DOM 操作
- **安全规则** — 云函数权限校验、数据校验、JQL 安全
- **跨端适配** — 条件编译、CSS/API/导航差异

## 设计系统

修改样式前，先读 `uni-app-style-system` skill。
核心规则：用 `$uni-text-color`、`getTheme('primary-color')` 等 token，禁止硬编码。

## 常用命令

- `/scaffold-page <模块>` — 生成列表/新增/编辑页面
- `/scaffold-cloud <名称>` — 生成云对象 + Schema
- `/check-theme` — 扫描硬编码颜色
AGENTSEOF
  info "  ✓ AGENTS.md"
  echo ""
fi

# ─── 完成 ───
info "安装完成！"
echo ""
info "已安装:"
for item in "${INSTALLED[@]}"; do
  info "  ✓ $item"
done
echo ""
info "卸载: bash setup.sh --uninstall"
