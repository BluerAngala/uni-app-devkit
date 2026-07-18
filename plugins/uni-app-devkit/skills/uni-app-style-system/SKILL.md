---
name: uni-app-style-system
description: "uni-app 设计系统入口。修改样式前先读本文件，再按当前目标端读对应的端规范。"
tags: [uni-app, design-system, scss, theme, cross-platform]
---

# uni-app 设计系统

本 skill 是设计系统的入口。修改样式时的阅读顺序：

1. **本文件**（通用规则） — 始终生效
2. **端规范** — 按目标平台读对应文件
3. **参考文件** — token 表、组件示例

## 文件结构

```
skills/uni-app-style-system/
├── SKILL.md                              ← 你在这里（通用规则）
├── references/
│   ├── design-tokens.md                  ← Token 完整表
│   ├── component-guide.md                ← 组件基础示例
│   ├── visual-quality.md                 ← 视觉品质基准
│   ├── premium-components.md             ← 高端组件模板
│   ├── interaction-patterns.md           ← 交互模式（导航/搜索/表单/列表/反馈）
│   ├── content-standards.md              ← 内容规范（文案/数字/日期/状态/错误信息）
│   ├── graphics-assets.md                ← 图形资源（图标/插图/图片/Logo）
│   ├── accessibility.md                  ← 无障碍（对比度/触控/焦点/键盘/ARIA）
│   ├── icon-upgrade.md                   ← 图标升级方案
│   ├── h5-design.md                      ← H5 端规范（响应式/管理系统布局）
│   ├── h5-advanced-effects.md            ← H5 高级效果
│   ├── miniprogram-design.md             ← 小程序端规范
│   └── app-design.md                     ← App 端规范
```

## 通用规则（所有端必须遵守）

### 1. Token 系统

- **禁止硬编码颜色值** — 所有颜色必须引用 `$uni-*` 变量或 `getTheme()`
- **单位** — rpx（响应式）或 px（固定），禁止 rem/vh/vw
- **间距** — 基于 4px 网格（`$uni-space-1` ~ `$uni-space-12`）
- **圆角** — 全局统一一套（`$uni-radius-sm` / `base` / `lg` / `xl` / `full`）
- **阴影** — 3 级深度（`$uni-shadow-sm` / `base` / `lg`），小程序用边框模拟

详细 token 值见 `references/design-tokens.md`。

### 2. 主题系统

- **统一机制** — `$themes` map + `themeify` mixin + 根元素 class 切换
- **禁止混用** — 不要同时用 `getTheme()` 和 CSS `var()` 变量
- **深色模式** — 所有颜色必须在 light/dark 两个主题下都有值
- **切换方式** — 运行时切换根元素 class（`.theme-light` / `.theme-dark`）

```scss
// 正确
.my-button {
  @include themeify {
    background-color: getTheme('primary-color');
  }
}

// 错误 — 硬编码
.my-button { background-color: #2979ff; }
```

### 3. 数据驱动样式

- 用 `:class` / `:style` 绑定样式，禁止 DOM 操作
- 不操作 `document.style` / `classList`
- 用 `v-if` / `v-show` 控制显隐，不用 CSS `display: none`

### 4. 组件规范

- 按钮：主操作 `type="primary"`，危险 `type="warn"`，次要 `type="default"`
- 表格：`<uni-table>` + `border` + `stripe`
- 表单：`<uni-forms>` + `label-position="left"`
- 弹窗：`<uni-popup>`，信息确认 400px，表单 600px
- 最小触控区域：48px

详见 `references/component-guide.md`。

### 5. 一致性锁定

- **颜色一致性** — 选定主色调后整站统一
- **圆角一致性** — 选定一套后全局统一
- **间距一致性** — 同级元素用同一 token

### 6. 禁用清单

| 禁止 | 替代 |
|------|------|
| 硬编码颜色值 | `$uni-*` 变量 / `getTheme()` |
| rem/vh/vw 单位 | rpx / px |
| DOM 操作 | `:class` / `:style` |
| `<div>` / `<span>` / `<img>` | `<view>` / `<text>` / `<image>` |
| 混用 `getTheme()` 和 CSS `var()` | 统一用 `$themes` + class |
| 对比度 < 4.5:1 的文字 | 用 `$uni-text-color` 系列 |
| emoji 做图标 | SVG / icon font |
| 纯黑 `#000` 做页面背景 | `$uni-bg-color` |

### 7. 深色模式 Checklist

- [ ] 所有颜色通过 token，无硬编码
- [ ] light/dark 双主题下对比度 ≥ 4.5:1
- [ ] 输入框、表单深色背景不与页面融合
- [ ] 图标/图片有深色模式版本或加蒙层

## 端规范选择

| 你的目标平台 | 读哪个文件 |
|-------------|-----------|
| H5（Web） | `references/h5-design.md` |
| 微信/支付宝/字节等小程序 | `references/miniprogram-design.md` |
| App（iOS / Android） | `references/app-design.md` |
| 多端同时开发 | 三个都读，取交集 |

## 交付 Checklist

- [ ] 颜色合规（无硬编码）
- [ ] 深色模式正常
- [ ] 单位正确（rpx/px）
- [ ] 触控区域 ≥ 48px
- [ ] 过渡动画 150-300ms
- [ ] i18n 文本用 `$t()`
- [ ] **已读目标端的专属规范并遵守**
- [ ] 至少在两个平台验证过
