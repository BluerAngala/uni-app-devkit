# uni-app-devkit

uni-app 全流程开发规范 — OMP / Claude Code marketplace plugin。

## 包含什么

| 类型 | 文件 | 作用 |
|------|------|------|
| **rules** | `uni-app-conventions.md` | 编码约定（Options API、标签、生命周期、样式、i18n） |
| **rules** | `uni-cloud-security.md` | uniCloud 安全规则（权限校验、数据校验、JQL 安全） |
| **skill** | `uni-app-style-system` | 设计系统规范（token 体系、主题架构、组件样式约定） |
| **skill** | `uni-app-page-dev` | 页面开发全流程（列表页、表单页、权限、路由注册） |
| **skill** | `uni-app-cloud-dev` | 云开发全流程（云对象、云函数、Schema、JQL） |
| **command** | `/scaffold-page` | 一键生成管理页面骨架（list/add/edit） |
| **command** | `/scaffold-cloud` | 一键生成云对象/云函数骨架 + Schema |

## 安装

### OMP / Claude Code

```
/marketplace add BluerAngala/uni-app-devkit
/marketplace install uni-app-devkit@uni-app-devkit --scope project
```

### 手动安装

```bash
# 复制到项目
cp -r plugins/uni-app-devkit <your-project>/.omp/plugins/

# 或只复制 skill 到 .claude/skills/
cp -r plugins/uni-app-devkit/skills/* <your-project>/.claude/skills/
```

## 使用

### Rules（自动生效）

安装后 rules 自动注入 agent 上下文，无需手动触发。

### Skills（按需加载）

| Skill | 何时触发 |
|-------|---------|
| `uni-app-style-system` | 修改 CSS/SCSS、添加主题、调整布局 |
| `uni-app-page-dev` | 新建/修改页面、CRUD 功能 |
| `uni-app-cloud-dev` | 新建/修改云函数、云对象、Schema |

### Commands（手动触发）

```
/scaffold-page product --fields name,price,status --collection opendb-product
/scaffold-cloud product-co --collection opendb-product
```

## 目录结构

```
uni-app-devkit/
├── .omp-plugin/marketplace.json
├── .claude-plugin/marketplace.json
├── README.md
├── LICENSE
└── plugins/uni-app-devkit/
    ├── skills/
    │   ├── uni-app-style-system/
    │   │   ├── SKILL.md
    │   │   └── references/
    │   ├── uni-app-page-dev/
    │   │   └── SKILL.md
    │   └── uni-app-cloud-dev/
    │       └── SKILL.md
    ├── rules/
    │   ├── uni-app-conventions.md
    │   └── uni-cloud-security.md
    └── commands/
        ├── scaffold-page.md
        └── scaffold-cloud.md
```

## License

MIT
