# 视觉品质基准

本文件定义 uni-app 项目"好看"的可量化标准。所有页面/组件交付前必须通过此基准。

## 一、间距节奏

### 留白是品质的第一要素

React 生态的页面好看，80% 的原因是**留白充足**。uni-app 项目最常见的设计问题是"挤"。

| 场景 | 最小间距 | 推荐间距 | 说明 |
|------|---------|---------|------|
| 页面内边距 | 24rpx | 32rpx | 页面左右 padding |
| 区块间距 | 32rpx | 48rpx | 两个内容块之间的距离 |
| 卡片内边距 | 24rpx | 32rpx | 卡片内部 padding |
| 列表项间距 | 16rpx | 24rpx | 列表项之间的间距 |
| 表单项间距 | 20rpx | 32rpx | label 和 input 之间 |
| 按钮组间距 | 16rpx | 24rpx | 按钮之间的间距 |
| 图标与文字 | 8rpx | 12rpx | 图标和旁边文字的距离 |

### 留白检查

```
❌ 错误：所有元素紧贴在一起
┌──────────────────────┐
│标题                   │
│内容内容内容内容内容    │
│按钮按钮按钮           │
│标题                   │
│内容内容内容内容内容    │
└──────────────────────┘

✅ 正确：充足的呼吸感
┌──────────────────────┐
│                      │
│  标题                │
│                      │
│  内容内容内容内容内容  │
│                      │
│  按钮    按钮        │
│                      │
│  ─────────────────── │
│                      │
│  标题                │
│                      │
│  内容内容内容内容内容  │
│                      │
└──────────────────────┘
```

### 规则

- 页面顶部第一个元素不要紧贴导航栏，留 24-32rpx
- 按钮不要紧贴表单项，留 32rpx
- 卡片与卡片之间至少 24rpx
- 列表项之间用分割线或间距，不要既无线又无间距
- 底部操作按钮与内容区至少 48rpx

## 二、颜色品质

### 默认蓝的问题

uni-ui 默认主色 `#2979ff` 是“工具蓝”，缺乏品牌感。好的设计需要**精心挑选的主色**。

### 推荐色板（非默认蓝）

| 风格 | 主色 | 适用场景 |
|------|------|----------|
| 商务沉稳 | `#1a56db` | 企业后台、B2B |
| 科技感 | `#6366f1` | SaaS、工具类产品 |
| 活力橙 | `#f97316` | 电商、生活服务 |
| 自然绿 | `#059669` | 健康、环保、金融 |
| 高级紫 | `#7c3aed` | 创意、设计、AI |
| 暖棕 | `#92400e` | 奢侈品、手工艺 |
| 冷灰蓝 | `#475569` | 极简、专业工具 |

### 颜色使用规则

- **一个主色 + 一个强调色**，不要超过 3 种彩色
- 正文不用纯黑 `#000`，用 `$uni-text-color`（`#1a1a2e` 或 `#334155`）
- 背景不用纯白 `#fff`，用 `$uni-bg-color`（`#fafafa` 或 `#f8fafc`）
- 边框不用深灰，用 `$uni-border-color`（`#e2e8f0` 或 `#f1f5f9`）
- 分割线用 `1px solid $uni-border-color-light`，不用硬编码

### 颜色品质对比

```
❌ 低品质配色
- 主色: #2979ff（默认蓝）
- 文字: #000000（纯黑）
- 背景: #ffffff（纯白）
- 边框: #cccccc（死灰）
→ 对比过强，刺眼，无层次

✅ 高品质配色
- 主色: #6366f1（靛紫）
- 文字: #1e293b（深蓝灰）
- 背景: #f8fafc（极浅蓝灰）
- 边框: #e2e8f0（浅蓝灰）
→ 柔和，有层次，舒适
```

## 三、排版品质

### 字号层级

必须有清晰的层级，不要所有文字一样大：

| 层级 | 字号 | 字重 | 颜色 | 用途 |
|------|------|------|------|------|
| 大标题 | 36-40rpx | 700 | `$uni-text-color` | 页面标题 |
| 小标题 | 30-32rpx | 600 | `$uni-text-color` | 区块标题 |
| 正文 | 28rpx | 400 | `$uni-text-color` | 主要内容 |
| 辅助 | 24rpx | 400 | `$uni-text-color-secondary` | 次要信息 |
| 标签 | 22rpx | 400 | `$uni-text-color-grey` | 时间、标签 |

### 行高

- 标题行高：1.3-1.4（紧凑）
- 正文行高：1.6-1.7（宽松，易读）
- 辅助行高：1.4-1.5

### 字重使用

- 正文用 400（regular），不要用 300（太细看不清）
- 标题用 600-700，不要所有文字都加粗
- 强调用 500-600，不要用 `color: red` 强调

## 四、卡片品质

### 基础卡片

```scss
// ✅ 高品质卡片
.premium-card {
  background: $uni-bg-color;
  border-radius: $uni-radius-lg;          // 12-16px 圆角
  padding: $uni-space-5;                  // 20-24rpx 内边距
  border: 1px solid rgba(0, 0, 0, 0.04); // 极浅边框，不用深灰
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04); // 极浅阴影
}

// ❌ 低品质卡片
.basic-card {
  background: #fff;
  border: 1px solid #ccc;    // 深灰边框，生硬
  padding: 10px;             // 内边距不足
  border-radius: 4px;        // 圆角太小
}
```

### 卡片层级

| 层级 | 边框 | 阴影 | 用途 |
|------|------|------|------|
| 平面 | 1px solid rgba(0,0,0,0.06) | 无 | 列表项、分组 |
| 浮起 | 无 | 0 1px 3px rgba(0,0,0,0.06) | 普通卡片 |
| 悬浮 | 无 | 0 4px 12px rgba(0,0,0,0.08) | 弹窗、浮层 |
| 强调 | 无 | 0 8px 24px rgba(0,0,0,0.12) | 模态弹窗 |

## 五、按钮品质

### 按钮尺寸

| 类型 | 高度 | 内边距 | 字号 | 圆角 |
|------|------|--------|------|------|
| 大按钮 | 88rpx | 0 48rpx | 30rpx | 12rpx |
| 常规按钮 | 72rpx | 0 36rpx | 28rpx | 8rpx |
| 小按钮 | 56rpx | 0 24rpx | 24rpx | 6rpx |
| 迷你按钮 | 44rpx | 0 16rpx | 22rpx | 4rpx |

### 按钮风格

```scss
// ✅ 主按钮 — 渐变 + 精致
.btn-primary {
  background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
  color: #fff;
  border: none;
  border-radius: 12rpx;
  font-weight: 600;
  box-shadow: 0 4px 12px rgba(99, 102, 241, 0.3);
  &:active {
    transform: scale(0.98);
    box-shadow: 0 2px 6px rgba(99, 102, 241, 0.3);
  }
}

// ✅ 幽灵按钮 — 透明 + 边框
.btn-ghost {
  background: transparent;
  color: #6366f1;
  border: 1.5px solid #6366f1;
  border-radius: 12rpx;
  &:active {
    background: rgba(99, 102, 241, 0.06);
  }
}

// ✅ 文字按钮 — 无边框无背景
.btn-text {
  background: transparent;
  color: #6366f1;
  border: none;
  padding: 0;
  &:active {
    opacity: 0.7;
  }
}
```

## 六、列表品质

### 列表项设计

```scss
// ✅ 高品质列表项
.list-item {
  display: flex;
  align-items: center;
  padding: 24rpx 32rpx;
  background: $uni-bg-color;
  border-bottom: 1px solid rgba(0, 0, 0, 0.04);
  min-height: 96rpx;  // 足够的触控区域

  &:active {
    background: rgba(0, 0, 0, 0.02);
  }
}

// ❌ 低品质列表项
.list-item {
  padding: 10px;
  border-bottom: 1px solid #eee;  // 分割线太粗
  // 没有 active 状态
  // 没有统一高度
}
```

### 列表信息层级

```
✅ 高品质列表
┌────────────────────────────────────┐
│  ┌────┐  商品名称                   │
│  │图片 │  商品描述信息，灰色小字      │
│  └────┘  ¥99.00          2024-01-01 │
└────────────────────────────────────┘

❌ 低品质列表
┌────────────────────────────────────┐
│ 商品名称 ¥99.00 2024-01-01         │
│ 商品描述信息                        │
└────────────────────────────────────┘
```

规则：
- 主信息用 `$uni-text-color` + 字重 500
- 次信息用 `$uni-text-color-secondary` + 字号小一号
- 价格/金额用字重 600 + 主色或红色
- 时间用 `$uni-text-color-grey` + 最小字号

## 七、状态设计

### 必须设计的 5 种状态

| 状态 | 设计要求 |
|------|---------|
| **加载中** | 骨架屏（skeleton），不用菊花转圈 |
| **空状态** | 插图 + 引导文案 + 操作按钮 |
| **错误状态** | 图标 + 错误描述 + 重试按钮 |
| **网络异常** | 图标 + "网络开小差" + 重试按钮 |
| **成功状态** | 图标 + 成功描述 + 下一步操作 |

### 骨架屏

```vue
<template>
  <view v-if="loading" class="skeleton">
    <view class="skeleton-avatar" />
    <view class="skeleton-lines">
      <view class="skeleton-line skeleton-line--long" />
      <view class="skeleton-line skeleton-line--short" />
    </view>
  </view>
  <view v-else>
    <!-- 真实内容 -->
  </view>
</template>

<style>
.skeleton {
  display: flex;
  padding: 24rpx 32rpx;
}
.skeleton-avatar {
  width: 96rpx;
  height: 96rpx;
  border-radius: 12rpx;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
.skeleton-lines {
  flex: 1;
  margin-left: 20rpx;
}
.skeleton-line {
  height: 28rpx;
  border-radius: 4rpx;
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  margin-bottom: 16rpx;
}
.skeleton-line--long { width: 80%; }
.skeleton-line--short { width: 50%; }

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
</style>
```

### 空状态

```vue
<template>
  <view class="empty-state">
    <image class="empty-icon" src="/static/empty.png" mode="aspectFit" />
    <text class="empty-title">暂无数据</text>
    <text class="empty-desc">点击下方按钮添加第一条记录</text>
    <button class="btn-primary" @click="add">立即添加</button>
  </view>
</template>

<style>
.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 120rpx 64rpx;
}
.empty-icon {
  width: 240rpx;
  height: 240rpx;
  margin-bottom: 32rpx;
}
.empty-title {
  font-size: 32rpx;
  font-weight: 600;
  color: $uni-text-color;
  margin-bottom: 12rpx;
}
.empty-desc {
  font-size: 26rpx;
  color: $uni-text-color-secondary;
  margin-bottom: 48rpx;
  text-align: center;
}
</style>
```

## 八、品质 Checklist

每个页面交付前检查：

- [ ] **间距** — 页面内边距 ≥ 24rpx，区块间距 ≥ 32rpx，元素不紧贴
- [ ] **颜色** — 非默认蓝，正文非纯黑，背景非纯白，边框非深灰
- [ ] **排版** — 有清晰字号层级（标题/正文/辅助），行高 ≥ 1.5
- [ ] **卡片** — 圆角 ≥ 8px，边框极浅或无，有微阴影
- [ ] **按钮** — 有 active 状态反馈（scale 或 opacity）
- [ ] **列表** — 有 active 状态，信息有主次层级
- [ ] **状态** — 加载/空/错误/网络异常 4 种状态已设计
- [ ] **分割线** — 极浅（rgba(0,0,0,0.04)~0.08），不用深灰
- [ ] **图标** — 风格统一（线性或面性），尺寸一致
- [ ] **整体** — 无"AI 默认感"（默认蓝、纯黑白、无留白、无层级）
