---
name: check-theme
description: "扫描项目中所有 .vue 和 .scss 文件，检查硬编码颜色值、不合规单位、DOM 操作等违反设计系统规范的问题。"
---

# Check Theme

扫描项目代码，检查是否违反设计系统规范。用法：`/check-theme [目录]`

## 执行步骤

### 1. 扫描硬编码颜色

用 `grep` 搜索所有 `.vue` 和 `.scss` 文件中的十六进制颜色值：

```bash
grep -rn --include="*.vue" --include="*.scss" -E '#[0-9a-fA-F]{3,8}' <目录> \
  | grep -v 'node_modules' \
  | grep -v 'uni_modules' \
  | grep -v '\.omp/' \
  | grep -v '// ' \
  | grep -v '/* '
```

排除项：
- 注释中的颜色（`// #fff` 或 `/* #fff */`）
- `node_modules` 和 `uni_modules`
- `.omp/` 目录

### 2. 扫描不合规单位

```bash
grep -rn --include="*.vue" --include="*.scss" -E '(rem|100vh|100vw)' <目录> \
  | grep -v 'node_modules' \
  | grep -v 'uni_modules'
```

### 3. 扫描 DOM 操作

```bash
grep -rn --include="*.vue" --include="*.js" \
  -E '(document\.|window\.|localStorage|sessionStorage|getElementById|querySelector)' <目录> \
  | grep -v 'node_modules' \
  | grep -v 'uni_modules'
```

### 4. 扫描 Web 标签

```bash
grep -rn --include="*.vue" -E '<(div|span|img|a |ul|li|p |h[1-6])' <目录> \
  | grep -v 'node_modules' \
  | grep -v 'uni_modules'
```

### 5. 汇总报告

输出格式：

```
🔍 设计系统规范检查报告

❌ 硬编码颜色 (5 处)
  pages/index/index.vue:380    color: #555
  pages/index/index.vue:392    color: #007aff
  pages/system/user/list.vue:1  background-color: #fff
  ...

⚠️ 不合规单位 (2 处)
  pages/xxx.vue:10    width: 100vw
  pages/xxx.vue:20    font-size: 1rem

❌ DOM 操作 (1 处)
  pages/xxx.vue:15    document.getElementById('box')

✅ Web 标签 — 未发现

建议修复:
  #555       → $uni-text-color
  #007aff    → getTheme('primary-color')
  #fff       → $uni-bg-color
  #606266    → $uni-text-color
  #999       → $uni-text-color-grey
  100vw      → 750rpx
  1rem       → $uni-font-size-base (14px)
```

### 6. 自动修复提示

如果用户要求自动修复，逐个文件替换：

| 硬编码值 | 替换为 | 理由 |
|---------|--------|------|
| `#333` | `$uni-text-color` | 主文字色 |
| `#555` | `$uni-text-color` | 接近主文字色 |
| `#606266` | `$uni-text-color` | 接近主文字色 |
| `#999` | `$uni-text-color-grey` | 辅助文字色 |
| `#007aff` | `getTheme('primary-color')` | 主题主色 |
| `#fff` / `#ffffff` | `$uni-bg-color` | 背景色 |
| `#ebeef5` | `$uni-table-border-color` | 表格边框色 |

**注意：** 替换前需要确认 `<style lang="scss">`，否则 SCSS 变量不生效。
