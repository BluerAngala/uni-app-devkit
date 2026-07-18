---
name: check-theme
description: "扫描项目中所有 .vue 和 .scss 文件，检查硬编码颜色值、不合规单位、DOM 操作等违反设计系统规范的问题。"
---

# Check Theme

扫描项目代码，检查是否违反设计系统规范。用法：`/check-theme [目录]`

## 执行步骤

### 0. 加载白名单

如果项目根目录存在 `.check-theme-ignore.json`，加载白名单。白名单中的行不再报错。

```json
{
  "colors": [
    "#transparent",
    "#wechat"
  ],
  "files": [
    "pages/debug/**",
    "uni_modules/**"
  ],
  "lines": [
    "src/utils/color-map.js:42"
  ]
}
```

- `colors`：忽略的色值（精确匹配，包括 URL 锚点 `#xxx`、CSS 函数参数等）
- `files`：glob 模式，整个文件跳过
- `lines`：`文件:行号`，精确跳过

### 1. 扫描硬编码颜色

用 `grep` 搜索所有 `.vue` 和 `.scss` 文件中的十六进制颜色值：

```bash
grep -rn --include="*.vue" --include="*.scss" -P '(?<![:\w])#(?:[0-9a-fA-F]{3}){1,2}\b' <目录> \
  | grep -v 'node_modules' \
  | grep -v 'uni_modules' \
  | grep -v '\.omp/' \
  | grep -v '\.claude/'
```

说明：
- `-P` 使用 PCRE 正则，`(?<![:\w])` 排除 `url(#id)`、`#wechat` 等非颜色用途
- 只匹配 3 位或 6 位十六进制（`#fff`、`#007aff`），不匹配 `#section-id` 等长字符串
- 注释中的色值仍会匹配，由报告阶段标注是否为注释行

误报过滤（报告阶段额外排除）：
- URL 锚点：`href="#top"`、`url(#gradient)` — 由 `(?<![:\w])` 已排除
- HTML id 选择器：`#app`、`#main` — 3 位纯字母组合由人工判断
- `v-bind` 中的变量名：`:class="{'active': isActive}"` — 不含 `#`，不触发

如果需要精确过滤注释行，可用 `awk` 提取行内非注释部分再匹配，但通常白名单 + 人工审核更实用。

### 2. 扫描不合规单位

```bash
grep -rn --include="*.vue" --include="*.scss" -E '(rem|[0-9]+vh|[0-9]+vw)' <目录> \
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
