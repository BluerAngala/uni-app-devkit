# H5 端设计规范

本文件是 H5（Web）端的专属设计规范。修改 H5 相关样式前先读本文件。
通用规则见 `SKILL.md`，token 表见 `design-tokens.md`。

## 一、响应式布局体系

### 断点系统

| 断点 | 宽度 | 设备 | 布局模式 |
|------|------|------|---------|
| `xs` | < 576px | 手机竖屏 | 单列，无侧边栏 |
| `sm` | 576-767px | 手机横屏 | 单列，无侧边栏 |
| `md` | 768-991px | 平板 | 侧边栏折叠（icon 模式） |
| `lg` | 992-1199px | 小桌面 | 侧边栏展开（窄） |
| `xl` | ≥ 1200px | 大桌面 | 侧边栏展开（完整） |

### 管理系统经典布局

```
┌─────────────────────────────────────────────┐
│  Header（固定顶部，height: 56px）            │
├──────────┬──────────────────────────────────┤
│          │                                  │
│ Sidebar  │  Main Content                    │
│ (固定左侧)│  (可滚动)                         │
│          │                                  │
│ 200-240px│  flex: 1                         │
│          │                                  │
└──────────┴──────────────────────────────────┘
```

```scss
/* #ifdef H5 */
.admin-layout {
  display: flex;
  min-height: 100dvh;
}

.admin-sidebar {
  width: 240px;
  flex-shrink: 0;
  background: $uni-bg-color;
  border-right: 1px solid $uni-border-color-light;
  position: sticky;
  top: 0;
  height: 100dvh;
  overflow-y: auto;
  transition: width $uni-duration-base ease;
  z-index: 100;
}

.admin-header {
  height: 56px;
  background: $uni-bg-color;
  border-bottom: 1px solid $uni-border-color-light;
  position: sticky;
  top: 0;
  z-index: 99;
  display: flex;
  align-items: center;
  padding: 0 $uni-space-5;
}

.admin-main {
  flex: 1;
  min-width: 0;  // 防止 flex 子元素溢出
  padding: $uni-space-5;
  background: $uni-bg-color-secondary;
}

// 响应式：平板侧边栏折叠为 icon 模式
@media (max-width: 991px) {
  .admin-sidebar {
    width: 64px;
    .sidebar-text { display: none; }
    .sidebar-item { justify-content: center; padding: 0; }
  }
}

// 响应式：手机隐藏侧边栏
@media (max-width: 767px) {
  .admin-sidebar {
    position: fixed;
    left: -240px;
    width: 240px;
    transition: left $uni-duration-base ease;
    box-shadow: $uni-shadow-lg;
    &.is-open { left: 0; }
  }
  .admin-main { padding: $uni-space-3; }
}
/* #endif */
```

### 容器响应式

```scss
/* #ifdef H5 */
// 内容区最大宽度（防止大屏拉伸过宽）
.page-content {
  max-width: 1400px;
  margin: 0 auto;
}

// 窄内容区（表单、详情页）
.page-content--narrow {
  max-width: 800px;
}

// 全宽内容区（仪表盘、数据表格）
.page-content--full {
  max-width: 100%;
}
/* #endif */
```

## 二、CSS Grid 高级布局

```scss
/* #ifdef H5 */
// Dashboard 自适应网格
.dashboard-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: $uni-space-4;
}

// Bento Grid（错落网格）
.bento-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: 200px;
  gap: 16px;
}
.bento-item--wide { grid-column: span 2; }
.bento-item--tall { grid-row: span 2; }
.bento-item--featured { grid-column: span 2; grid-row: span 2; }

// 12 列栅格
.grid-12 {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: $uni-space-4;
}

// 响应式列数变化
.responsive-grid {
  display: grid;
  // 手机 1 列，平板 2 列，桌面 3 列
  grid-template-columns: 1fr;
  gap: $uni-space-4;

  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }
  @media (min-width: 1200px) {
    grid-template-columns: repeat(3, 1fr);
  }
}
/* #endif */
```

## 三、表格响应式

表格是最棘手的响应式元素——窄屏放不下所有列。

### 策略一：横向滚动（推荐，数据表格）

```scss
/* #ifdef H5 */
.table-responsive {
  width: 100%;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;

  // 固定第一列
  .table-fixed-col {
    position: sticky;
    left: 0;
    background: $uni-bg-color;
    z-index: 1;
  }
}

@media (max-width: 767px) {
  .table-responsive {
    margin: 0 (-$uni-space-3);
    padding: 0 $uni-space-3;
  }
}
/* #endif */
```

### 策略二：卡片化（移动端列表）

```vue
<!-- 桌面显示表格 -->
<!-- #ifdef H5 -->
<uni-table v-if="isDesktop" :data="list">
  <!-- 表格列 -->
</uni-table>

<!-- 手机显示卡片列表 -->
<view v-else class="mobile-list">
  <view class="mobile-card" v-for="item in list" :key="item._id">
    <view class="mobile-card__row">
      <text class="mobile-card__label">名称</text>
      <text class="mobile-card__value">{{ item.name }}</text>
    </view>
    <view class="mobile-card__row">
      <text class="mobile-card__label">状态</text>
      <uni-tag :text="item.status ? '启用' : '禁用'" />
    </view>
  </view>
</view>
<!-- #endif -->
```

```js
// 桌面/手机判断
computed: {
  isDesktop() {
    // #ifdef H5
    return window.innerWidth >= 768
    // #endif
    return true
  }
}
```

### 策略三：隐藏次要列

```scss
/* #ifdef H5 */
// 小屏隐藏次要列
@media (max-width: 991px) {
  .col-hide-md { display: none; }
}
@media (max-width: 767px) {
  .col-hide-sm { display: none; }
}
/* #endif */
```

## 四、表单响应式

### 桌面多列 → 手机单列

```scss
/* #ifdef H5 */
.form-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: $uni-space-4;
}

// 平板 2 列
@media (min-width: 768px) {
  .form-grid {
    grid-template-columns: repeat(2, 1fr);
  }
  .form-grid__full { grid-column: 1 / -1; }
}

// 桌面 3 列
@media (min-width: 1200px) {
  .form-grid--3col {
    grid-template-columns: repeat(3, 1fr);
  }
}
/* #endif */
```

```vue
<!-- #ifdef H5 -->
<view class="form-grid">
  <view class="form-item">
    <text class="form-label">名称</text>
    <input v-model="form.name" />
  </view>
  <view class="form-item">
    <text class="form-label">分类</text>
    <input v-model="form.category" />
  </view>
  <view class="form-item">
    <text class="form-label">价格</text>
    <input v-model="form.price" />
  </view>
  <!-- 描述占满整行 -->
  <view class="form-item form-grid__full">
    <text class="form-label">描述</text>
    <textarea v-model="form.desc" />
  </view>
</view>
<!-- #endif -->
```

### 表单项标签位置

```scss
/* #ifdef H5 */
// 桌面：标签在左侧
@media (min-width: 768px) {
  .form-item {
    display: flex;
    align-items: center;
  }
  .form-label {
    width: 100px;
    flex-shrink: 0;
    text-align: right;
    padding-right: $uni-space-3;
  }
}

// 手机：标签在上方
@media (max-width: 767px) {
  .form-label {
    display: block;
    margin-bottom: $uni-space-1;
  }
}
/* #endif */
```

## 五、导航响应式

### 侧边栏导航

```scss
/* #ifdef H5 */
.sidebar-nav {
  padding: $uni-space-2 0;
}

.sidebar-item {
  display: flex;
  align-items: center;
  padding: $uni-space-2 $uni-space-4;
  color: $uni-text-color-secondary;
  cursor: pointer;
  transition: all $uni-duration-fast ease;
  border-radius: $uni-radius-base;
  margin: 2px $uni-space-2;

  &:hover {
    background: $uni-bg-color-hover;
    color: $uni-text-color;
  }

  &--active {
    background: rgba(99, 102, 241, 0.08);
    color: #6366f1;
    font-weight: 500;
  }

  &__icon {
    width: 20px;
    margin-right: 12px;
    flex-shrink: 0;
    text-align: center;
  }

  &__text {
    flex: 1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
}

// 折叠模式只显示图标
.sidebar--collapsed {
  .sidebar-item__text { display: none; }
  .sidebar-item__icon { margin-right: 0; }
  .sidebar-item { justify-content: center; }
}
/* #endif */
```

### 移动端汉堡菜单

```vue
<!-- #ifdef H5 -->
<view class="mobile-header" v-if="!isDesktop">
  <view class="hamburger" @click="toggleSidebar">
    <view class="hamburger-line" />
    <view class="hamburger-line" />
    <view class="hamburger-line" />
  </view>
  <text class="mobile-header__title">{{ pageTitle }}</text>
</view>

<!-- 遮罩层 -->
<view class="sidebar-mask" v-if="sidebarOpen" @click="closeSidebar" />
<!-- #endif -->
```

```scss
/* #ifdef H5 */
.hamburger {
  width: 24px;
  cursor: pointer;
  padding: 4px 0;
}

.hamburger-line {
  width: 100%;
  height: 2px;
  background: $uni-text-color;
  margin: 4px 0;
  border-radius: 1px;
  transition: all $uni-duration-fast ease;
}

.sidebar-mask {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.3);
  z-index: 99;
}

@media (min-width: 768px) {
  .mobile-header, .sidebar-mask { display: none; }
}
/* #endif */
```

## 六、组件响应式

### 卡片网格

```scss
/* #ifdef H5 */
.card-grid {
  display: grid;
  gap: $uni-space-4;
  // 手机 1 列，平板 2 列，桌面 3-4 列
  grid-template-columns: 1fr;

  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }
  @media (min-width: 1200px) {
    grid-template-columns: repeat(3, 1fr);
  }
  @media (min-width: 1600px) {
    grid-template-columns: repeat(4, 1fr);
  }
}
/* #endif */
```

### 统计卡片

```scss
/* #ifdef H5 */
.stats-row {
  display: grid;
  gap: $uni-space-4;
  // 手机 2 列，桌面 4 列
  grid-template-columns: repeat(2, 1fr);

  @media (min-width: 992px) {
    grid-template-columns: repeat(4, 1fr);
  }
}
/* #endif */
```

### 弹窗宽度

```scss
/* #ifdef H5 */
.modal-content {
  width: 90%;
  max-width: 500px;  // 信息确认
}

.modal-content--form {
  width: 90%;
  max-width: 700px;  // 表单弹窗
}

.modal-content--wide {
  width: 90%;
  max-width: 1000px;  // 大型弹窗
}

@media (max-width: 767px) {
  .modal-content,
  .modal-content--form,
  .modal-content--wide {
    width: 95%;
    max-width: none;
    max-height: 85dvh;
    overflow-y: auto;
  }
}
/* #endif */
```

## 七、交互特性

### Hover 状态

```scss
/* #ifdef H5 */
.list-item {
  transition: background-color $uni-duration-fast ease;
  &:hover { background-color: $uni-bg-color-hover; }
}

.button {
  cursor: pointer;
  transition: all $uni-duration-fast ease;
  &:hover { opacity: 0.9; transform: translateY(-1px); }
  &:active { transform: translateY(0); }
}
/* #endif */
```

### 输入框防缩放

```scss
/* #ifdef H5 */
input, textarea, select {
  font-size: 16px;  // iOS Safari 字号 < 16px 会自动放大
}
/* #endif */
```

### 自定义滚动条

```scss
/* #ifdef H5 */
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: transparent; }
::-webkit-scrollbar-thumb {
  background: rgba(0, 0, 0, 0.15);
  border-radius: 3px;
  &:hover { background: rgba(0, 0, 0, 0.25); }
}
/* #endif */
```

### 平滑滚动

```scss
/* #ifdef H5 */
html { scroll-behavior: smooth; }
/* #endif */
```

## 八、字体

```scss
// H5 端可以用更丰富的字体栈
$uni-font-family-h5: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI',
  Roboto, 'Helvetica Neue', Arial, sans-serif;
```

```js
// 自定义字体加载
// #ifdef H5
const font = new FontFace('CustomFont', 'url(/fonts/custom.woff2)')
font.load().then(() => { document.fonts.add(font) })
// #endif
```

## 九、单位选择

| 场景 | 单位 | 说明 |
|------|------|------|
| 管理系统布局 | `px` | 固定侧边栏宽度、header 高度 |
| 管理系统内容 | `px` | 表格、表单、卡片间距 |
| 移动端 H5 布局 | `rpx` | 响应式宽度、间距 |
| 移动端 H5 内容 | `rpx` | 字号、图标、间距 |
| 混合场景 | `px` 为主 | 管理系统优先用 px |

**管理系统用 px，移动端 H5 用 rpx。** 不要混用。

## 十、H5 专属 Checklist

### 通用
- [ ] `cursor: pointer` 加到所有可点击元素
- [ ] `min-height: 100dvh`（不用 `100vh`）
- [ ] 输入框字号 ≥ 16px（防 iOS 缩放）
- [ ] `overscroll-behavior: contain`（防滚动穿透）

### 管理系统（桌面端）
- [ ] 侧边栏 + header + main 三段式布局
- [ ] 平板（768-991px）侧边栏折叠为 icon 模式
- [ ] 手机（< 768px）侧边栏隐藏 + 汉堡菜单
- [ ] 表格窄屏可横向滚动
- [ ] 表单桌面多列 → 手机单列
- [ ] 弹窗窄屏宽度自适应
- [ ] 容器有 `max-width`（大屏不撑满）
- [ ] `sticky` 导航栏有 `z-index`

### 移动端 H5
- [ ] rpx 单位，750 设计稿
- [ ] 底部安全区 `env(safe-area-inset-bottom)`
- [ ] 触控区域 ≥ 48px
- [ ] 图片用 `lazy-load`
