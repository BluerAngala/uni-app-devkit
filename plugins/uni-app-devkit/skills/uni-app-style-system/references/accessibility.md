# 无障碍规范

本文件定义 uni-app 项目的无障碍（Accessibility）标准。

## 一、色彩对比度

### WCAG AA 标准

| 元素 | 最低对比度 | 说明 |
|------|-----------|------|
| 正文文字（< 18px） | 4.5:1 | 正文、标签、按钮文字 |
| 大文字（≥ 18px 或 ≥ 14px 加粗） | 3:1 | 标题、大按钮文字 |
| 图标/图形 | 3:1 | 功能性图标 |
| 边框/分割线 | 3:1 | 表单边框、分割线 |

### 常见颜色对比度参考（白色背景 #fff）

| 文字色 | 对比度 | 是否达标 |
|--------|--------|---------|
| `#333` | 12.6:1 | ✅ AA + AAA |
| `#666` | 5.7:1 | ✅ AA |
| `#999` | 2.8:1 | ❌ 不达标 |
| `#1e293b` | 14.5:1 | ✅ AA + AAA |
| `#475569` | 7.0:1 | ✅ AA |
| `#94a3b8` | 3.2:1 | ⚠️ 仅大文字达标 |

### 深色模式对比度参考（深色背景 #111827）

| 文字色 | 对比度 | 是否达标 |
|--------|--------|---------|
| `#e5e7eb` | 13.7:1 | ✅ AA + AAA |
| `#9ca3af` | 6.2:1 | ✅ AA |
| `#6b7280` | 4.0:1 | ⚠️ 仅大文字达标 |
| `#4b5563` | 2.5:1 | ❌ 不达标 |

### 检查规则

- [ ] 所有正文文字对比度 ≥ 4.5:1
- [ ] 所有大文字对比度 ≥ 3:1
- [ ] 所有功能性图标对比度 ≥ 3:1
- [ ] 浅色和深色模式分别检查
- [ ] 不依赖颜色 alone 传递信息（加图标/文字/形状）

## 二、触控区域

### 最小尺寸

| 平台 | 最小尺寸 | 说明 |
|------|---------|------|
| iOS | 44×44pt | Apple HIG 推荐 |
| Android | 48×48dp | Material Design 推荐 |
| uni-app 统一 | 48px（96rpx） | 取较大值 |

### 实现方式

```scss
// 方式一：元素本身足够大
.btn-min {
  min-height: 96rpx;
  min-width: 96rpx;
}

// 方式二：元素小但增加点击区域
.icon-small {
  width: 40rpx;
  height: 40rpx;
  position: relative;
  &::after {
    content: '';
    position: absolute;
    top: -28rpx;
    right: -28rpx;
    bottom: -28rpx;
    left: -28rpx;
  }
}
```

### 间距要求

| 场景 | 最小间距 |
|------|---------|
| 相邻可点击元素 | 16rpx (8px) |
| 按钮组内按钮 | 16rpx (8px) |
| 列表项之间 | 0（用分割线区分） |

## 三、焦点状态

### 焦点环

```scss
// 所有可交互元素必须有焦点状态
.focusable {
  &:focus-visible {
    outline: 2px solid $primary-color;
    outline-offset: 2px;
    border-radius: $uni-radius-base;
  }
}

// 按钮焦点
button {
  &:focus-visible {
    box-shadow: 0 0 0 3px rgba($primary-color, 0.3);
  }
}

// 输入框焦点
input, textarea {
  &:focus {
    border-color: $primary-color;
    box-shadow: 0 0 0 3px rgba($primary-color, 0.1);
  }
}
```

### 焦点顺序

- 焦点顺序必须与视觉顺序一致（左→右，上→下）
- Tab 键顺序：地址栏 → 导航 → 主内容 → 侧边栏
- 不要用 `tabindex` > 0（打乱自然顺序）

## 四、键盘导航

### 可聚焦元素

| 元素 | 是否默认可聚焦 | 说明 |
|------|-------------|------|
| `<button>` | ✅ | 原生可聚焦 |
| `<input>` | ✅ | 原生可聚焦 |
| `<textarea>` | ✅ | 原生可聚焦 |
| `<a href>` | ✅ | 原生可聚焦 |
| `<view>` | ❌ | 需要 `tabindex="0"` |
| `<text>` | ❌ | 需要 `tabindex="0"` |

### 自定义元素键盘支持

```vue
<!-- 可点击的 view 需要加键盘支持 -->
<view
  class="list-item"
  tabindex="0"
  role="button"
  @click="handleClick"
  @keydown.enter="handleClick"
  @keydown.space="handleClick"
>
  列表项内容
</view>
```

### 快捷键

| 操作 | 按键 | 说明 |
|------|------|------|
| 下一个元素 | Tab | 正向遍历 |
| 上一个元素 | Shift + Tab | 反向遍历 |
| 激活按钮 | Enter / Space | 按钮激活 |
| 关闭弹窗 | Escape | 关闭模态框 |
| 选择列表项 | Enter | 列表项激活 |
| 全选 | Ctrl + A | 列表全选 |

## 五、语义化

### ARIA 角色

```vue
<!-- 导航 -->
<view role="navigation" aria-label="主导航">
  <!-- 导航内容 -->
</view>

<!-- 按钮（自定义元素） -->
<view role="button" aria-label="关闭" @click="close">
  <uni-icons type="close" />
</view>

<!-- 状态 -->
<view role="alert" aria-live="assertive">
  {{ errorMessage }}
</view>

<!-- 进度 -->
<view role="progressbar" :aria-valuenow="progress" aria-valuemin="0" aria-valuemax="100">
  {{ progress }}%
</view>

<!-- 标签页 -->
<view role="tablist">
  <view
    v-for="tab in tabs" :key="tab.id"
    role="tab"
    :aria-selected="activeTab === tab.id"
    @click="switchTab(tab.id)"
  >
    {{ tab.name }}
  </view>
</view>
```

### ARIA 属性

| 属性 | 用途 | 示例 |
|------|------|------|
| `aria-label` | 元素描述（无可见文字时） | 图标按钮 |
| `aria-labelledby` | 关联描述元素 ID | 表单标题 |
| `aria-describedby` | 关联补充说明 | 错误提示 |
| `aria-hidden` | 对屏幕阅读器隐藏 | 装饰性图标 |
| `aria-live` | 动态内容更新通知 | Toast、错误提示 |
| `aria-expanded` | 展开/折叠状态 | 折叠面板 |
| `aria-selected` | 选中状态 | Tab、列表项 |
| `aria-disabled` | 禁用状态 | 禁用按钮 |
| `aria-busy` | 加载中状态 | 骨架屏 |

## 六、表单无障碍

### 标签关联

```vue
<!-- ✅ 正确：label 关联 input -->
<view class="form-item">
  <label for="name" class="form-label">商品名称</label>
  <input id="name" v-model="form.name" aria-required="true" />
  <text id="name-error" class="form-error" v-if="errors.name" role="alert">
    {{ errors.name }}
  </text>
</view>

<!-- ❌ 错误：没有关联 -->
<view class="form-item">
  <text>商品名称</text>
  <input v-model="form.name" />
</view>
```

### 表单校验提示

```vue
<input
  v-model="form.phone"
  aria-invalid="!!errors.phone"
  aria-describedby="phone-error"
  @blur="validatePhone"
/>
<text
  v-if="errors.phone"
  id="phone-error"
  class="form-error"
  role="alert"
  aria-live="polite"
>
  {{ errors.phone }}
</text>
```

## 七、图片无障碍

```vue
<!-- 有意义的图片：描述图片内容 -->
<image src="/static/product.jpg" alt="红色运动鞋，侧面视图" />

<!-- 装饰性图片：空 alt -->
<image src="/static/decoration.png" alt="" aria-hidden="true" />

<!-- 功能性图片（图标按钮）：描述功能 -->
<image src="/static/icons/close.png" alt="关闭" @click="close" />
```

## 八、动态内容通知

```vue
<!-- Toast 通知 -->
<view
  v-if="toastVisible"
  role="alert"
  aria-live="assertive"
  class="toast"
>
  {{ toastMessage }}
</view>

<!-- 加载状态 -->
<view v-if="loading" role="status" aria-live="polite">
  <text>加载中...</text>
</view>

<!-- 搜索结果数量 -->
<view role="status" aria-live="polite">
  <text>找到 {{ total }} 条结果</text>
</view>
```

## 九、小程序无障碍

小程序有自己独立的无障碍属性体系，**不支持 Web 标准 ARIA**。

| Web ARIA | 小程序替代 | 说明 |
|----------|----------|------|
| `role="button"` | `aria-role="button"` | 属性名不同 |
| `aria-label` | `aria-label` | 相同 |
| `aria-live` | ❌ 不支持 | 用条件编译 `#ifdef H5` |
| `aria-expanded` | ❌ 不支持 | 用条件编译 |
| `aria-describedby` | ❌ 不支持 | 用条件编译 |
| `aria-invalid` | ❌ 不支持 | 用条件编译 |
| `tabindex` | ❌ 不支持 | 小程序自动处理焦点 |
| `@keydown` | ❌ 不支持 | 小程序无键盘事件 |

**规则：** Web ARIA 属性必须用 `#ifdef H5` 保护，小程序端用 `aria-role` + `aria-label` 基础属性。

## 十、无障碍 Checklist

### 色彩
- [ ] 正文对比度 ≥ 4.5:1
- [ ] 大文字对比度 ≥ 3:1
- [ ] 不依赖颜色 alone 传递信息
- [ ] 浅色/深色模式分别验证

### 触控
- [ ] 可点击元素 ≥ 48px（96rpx）
- [ ] 相邻可点击元素间距 ≥ 8px（16rpx）

### 焦点
- [ ] 所有可交互元素有焦点状态
- [ ] 焦点顺序与视觉顺序一致
- [ ] 弹窗打开时焦点 trap 在弹窗内

### 语义
- [ ] 图标按钮有 `aria-label`
- [ ] 装饰性图片 `aria-hidden="true"`
- [ ] 动态内容用 `aria-live` 通知
- [ ] 表单 `label` 关联 `input`

### 键盘
- [ ] Tab 可遍历所有可交互元素
- [ ] Enter/Space 可激活按钮
- [ ] Escape 可关闭弹窗
