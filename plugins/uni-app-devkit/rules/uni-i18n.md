---
name: uni-i18n
description: "uni-app 国际化规范。适用于 i18n key 命名、翻译文件组织、日期/货币格式化、复数处理的编写和审查。"
alwaysApply: true
---

# 国际化规范

## 1. i18n 基础

- 所有用户可见文本必须用 `$t('key')` 包裹
- 禁止硬编码中文/英文字符串出现在模板中
- 例外：调试日志、开发工具中的文本

```vue
<!-- ✅ -->
<text>{{ $t('user.name') }}</text>
<button @click="submit">{{ $t('common.button.submit') }}</button>
<uni-easyinput :placeholder="$t('common.placeholder.input')" />

<!-- ❌ -->
<text>用户名</text>
<button @click="submit">提交</button>
```

## 2. Key 命名规范

采用 `模块.语义` 的两级命名，用 `.` 分隔。

```
common.button.add          — 通用按钮
common.button.edit         — 通用按钮
common.button.delete       — 通用按钮
common.button.submit       — 通用按钮
common.button.cancel       — 通用按钮
common.button.search       — 通用按钮
common.button.batchDelete  — 通用按钮
common.placeholder.query   — 通用占位符
common.placeholder.input   — 通用占位符
common.empty               — 空状态提示
common.loading             — 加载中提示
user.name                  — 用户模块-姓名
user.email                 — 用户模块-邮箱
user.status                — 用户模块-状态
product.price              — 商品模块-价格
product.stock              — 商品模块-库存
msg.login.success          — 消息-登录成功
msg.delete.confirm         — 消息-删除确认
```

规则：
- 全小写，单词间用 `.` 分隔（不用驼峰、不用下划线）
- 最多三级：`模块.子模块.语义`，超过三级说明模块拆分有问题
- 通用模块统一用 `common`

## 3. 翻译文件结构

```
i18n/
├── zh-Hans.json       # 简体中文（基准语言）
├── zh-Hant.json       # 繁体中文
└── en.json            # 英文
```

```json
// i18n/zh-Hans.json
{
  "common": {
    "button": {
      "add": "新增",
      "edit": "编辑",
      "delete": "删除",
      "submit": "提交",
      "cancel": "取消",
      "search": "搜索",
      "batchDelete": "批量删除"
    },
    "placeholder": {
      "query": "请输入搜索关键词",
      "input": "请输入"
    },
    "empty": "暂无数据",
    "loading": "加载中..."
  },
  "user": {
    "name": "姓名",
    "email": "邮箱",
    "status": "状态"
  },
  "msg": {
    "login": {
      "success": "登录成功",
      "fail": "登录失败"
    },
    "delete": {
      "confirm": "确定删除吗？此操作不可恢复"
    }
  }
}
```

```json
// i18n/en.json
{
  "common": {
    "button": {
      "add": "Add",
      "edit": "Edit",
      "delete": "Delete",
      "submit": "Submit",
      "cancel": "Cancel",
      "search": "Search",
      "batchDelete": "Batch Delete"
    },
    "placeholder": {
      "query": "Enter search keywords",
      "input": "Please enter"
    },
    "empty": "No data",
    "loading": "Loading..."
  }
}
```

## 4. 带参数的文本

```js
// i18n/zh-Hans.json
{
  "msg": {
    "greeting": "你好，{name}",
    "itemCount": "共 {count} 条记录",
    "deleteConfirm": "确定删除「{name}」吗？"
  }
}

// 模板中使用
{{ $t('msg.greeting', { name: userInfo.nickname }) }}
{{ $t('msg.itemCount', { count: pagination.total }) }}
```

## 5. 日期与货币格式化

不要在翻译文本中拼接日期/货币格式，使用专用格式化函数。

```js
// utils/i18n.js

/**
 * 格式化日期（跟随当前语言）
 */
export function formatDate(timestamp, format = 'date') {
  const locale = uni.getStorageSync('app_language') || 'zh-Hans'
  const date = new Date(timestamp)

  if (locale === 'en') {
    return format === 'datetime'
      ? date.toLocaleString('en-US')
      : date.toLocaleDateString('en-US')
  }
  return format === 'datetime'
    ? date.toLocaleString('zh-CN')
    : date.toLocaleDateString('zh-CN')
}

/**
 * 格式化货币（跟随当前语言）
 */
export function formatCurrency(amount, currency = 'CNY') {
  const symbolMap = { CNY: '\u00a5', USD: '$', EUR: '\u20ac', GBP: '\u00a3' }
  const symbol = symbolMap[currency] || currency
  const value = (amount / 100).toFixed(2)
  // 简单千分位格式化（三端兼容，不依赖 Intl）
  const parts = value.split('.')
  parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',')
  return symbol + parts.join('.')
}
```

## 6. 语言切换

```js
// store/app.js
export const useAppStore = defineStore('app', {
  state: () => ({
    locale: uni.getStorageSync('app_language') || 'zh-Hans',
  }),
  actions: {
    setLocale(locale) {
      this.locale = locale
      uni.setStorageSync('app_language', locale)
      // uni-app 的 i18n 切换方式取决于使用的方案：
      // vue-i18n: this.$i18n.locale = locale
      // uni-app 内置: 通过 store 的 locale 驱动模板中的 $t()
    },
  },
})
```

## 7. 新增文本流程

1. 在 `i18n/zh-Hans.json` 中添加 key（基准语言）
2. 同步到 `zh-Hant.json`、`en.json`（至少这两个）
3. 模板中使用 `$t('key')`
4. 代码中使用 `this.$t('key')` 或 `uni.$t('key')`

## 8. 禁止事项

| 禁止 | 替代 |
|------|------|
| 模板中硬编码文本 | `$t('key')` |
| key 用驼峰或下划线 | 全小写 + `.` 分隔 |
| 翻译文本中拼接变量 | `$t('key', { param })` |
| 只写中文翻译 | 至少中英两份 |
| 日期/货币用字符串拼接 | `Intl` API 或专用格式化函数 |
| 翻译文件超过 500 行不拆分 | 按模块拆分子文件 |
