# uni-app-skills

uni-app 全流程开发规范 — OMP / Claude Code marketplace plugin。

## 包含什么

| 类型 | 文件 | 作用 |
|------|------|------|
| **rules** | `uni-app-conventions.md` | 编码约定（Options API、标签、生命周期、样式、i18n） |
| **rules** | `uni-cloud-security.md` | uniCloud 安全规则（权限校验、数据校验、JQL 安全） |
| **skill** | `uni-app-style-system` | 设计系统规范（token 体系、主题架构、组件样式约定） |
| **command** | `/scaffold-page` | 一键生成管理页面骨架（list/add/edit） |

## 安装

### OMP

```
/marketplace add Leonxlnx/uni-app-skills
/marketplace install uni-app-dev@uni-app-skills
```

### Claude Code

```
# 同上，自动识别 .claude-plugin/marketplace.json
```

### 手动安装

```bash
# 复制到项目 .omp/plugins/
cp -r plugins/uni-app-dev <your-project>/.omp/plugins/

# 或复制到 .claude/skills/（仅 skill 部分）
cp -r plugins/uni-app-dev/skills/uni-app-style-system <your-project>/.claude/skills/
```

## 使用

### Rules（自动生效）

安装后，rules 自动注入 agent 上下文，无需手动触发。

### Skill（按需加载）

当 agent 检测到你在修改样式/主题/组件时，会自动读取 `uni-app-style-system` skill。

### Command（手动触发）

```
/scaffold-page product --fields name,price,status --collection opendb-product
```

## 目录结构

```
uni-app-skills/
├── .omp-plugin/marketplace.json     # OMP marketplace catalog
├── .claude-plugin/marketplace.json  # Claude Code 兼容 catalog
└── plugins/uni-app-dev/
    ├── skills/
    │   └── uni-app-style-system/
    │       ├── SKILL.md             # 设计系统规范
    │       └── references/
    │           ├── design-tokens.md # token 完整列表
    │           └── component-guide.md
    ├── rules/
    │   ├── uni-app-conventions.md   # 编码约定
    │   └── uni-cloud-security.md    # 安全规则
    └── commands/
        └── scaffold-page.md         # 页面脚手架命令
```

## License

MIT
