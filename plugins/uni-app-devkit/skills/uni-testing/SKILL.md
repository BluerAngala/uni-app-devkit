---
name: uni-testing
description: "uni-app 测试策略规范。适用于单元测试、E2E 测试、HBuilderX CLI 日志捕获的编写和审查。"
alwaysApply: false
---

# 测试策略

## 1. 测试分层

| 层级 | 工具 | 覆盖目标 | 优先级 |
|------|------|---------|--------|
| **单元测试** | Jest | 工具函数、Store action、纯逻辑 | 必须 |
| **E2E 测试** | `uni-test`（HBuilderX 插件） | 页面跳转、表单提交、完整流程 | 按需 |
| **运行日志** | `cli logcat` / `uni-logcat` | 实时捕获运行时日志 | 调试必备 |

> **注意：** 旧版 `uni-automator` 独立包已被替代。当前测试体系基于 HBuilderX 插件 + `@dcloudio/hbuilderx-cli`。

## 2. 环境准备

### HBuilderX CLI 位置

| 平台 | 路径 |
|------|------|
| macOS | `/Applications/HBuilderX.app/Contents/MacOS/cli` |
| Windows | `{HBuilderX安装目录}\cli.exe` |
| Linux | `{HBuilderX安装目录}/cli` |

### npm 桥接包（推荐 CI 使用）

```bash
npm install @dcloudio/hbuilderx-cli --save-dev
```

提供 4 个 CLI：

| 命令 | 用途 |
|------|------|
| `hbuilderx` | 通用 HBuilderX CLI 入口 |
| `uni-launch` | 编译并运行到设备/浏览器 |
| `uni-logcat` | 查看运行时日志 |
| `uni-test` | 运行自动化测试 |

版本要求：HBuilderX 4.87+（logcat/uni-test），5.0+（launch）。

### 安装测试插件

在 HBuilderX 中安装 [uni-app 自动化测试插件](https://ext.dcloud.net.cn/plugin?id=5708)。

## 3. 运行日志捕获（logcat）

logcat 是 AI 开发最重要的能力——实时拿到运行时 console.log、错误、警告。

### 命令格式

```bash
# HBuilderX CLI 直接调用
./cli logcat <platform> --project <项目名> [--mode full|lastBuild|prevBuild]

# npm 桥接包
npx uni-logcat <platform> [--mode full|lastBuild|prevBuild]
```

### 平台支持

| 平台标识 | 说明 |
|---------|------|
| `web` | H5（支持 `--browser Chrome\|Firefox\|Safari\|Built`） |
| `app-android` | Android（支持 `--deviceId`） |
| `app-ios` | iOS（支持 `--deviceId`） |
| `app-harmony` | 鸿蒙 |
| `mp-weixin` | 微信小程序 |
| `mp-alipay` | 支付宝小程序 |
| `mp-baidu` / `mp-toutiao` / `mp-qq` / `mp-jd` / `mp-kuaishou` / `mp-xhs` / `mp-lark` | 其他小程序 |
| `pack` | App 云打包日志 |
| `unicloud` | uniCloud 日志 |

### 日志模式

| 模式 | 说明 |
|------|------|
| `prevBuild`（默认） | 最近一次构建的日志 |
| `lastBuild` | 最后一个构建周期的日志 |
| `full` | 所有日志（含早期构建） |

### 使用示例

```bash
# 查看 H5 Chrome 运行日志
./cli logcat web --project my-app --browser Chrome --mode lastBuild

# 查看微信小程序日志
./cli logcat mp-weixin --project my-app --mode prevBuild

# 查看 Android 设备日志
./cli logcat app-android --project my-app --deviceId emulator-5554

# 查看云打包日志
./cli logcat pack
```

### 日志格式

输出为带时间戳的实时流：

```
16:42:37.575 检查云端打包状态...
16:42:38.016 [LOG] pages/index/index.vue:42 用户登录成功
16:42:38.689 [WARN] pages/product/list.vue:15 废弃 API 调用
16:42:39.100 [ERROR] pages/order/detail.vue:88 TypeError: Cannot read property 'id' of undefined
```

### CI 中捕获日志

```bash
# 日志重定向到文件
./cli logcat mp-weixin --project my-app --mode lastBuild > build.log 2>&1

# 后台捕获 + 跑测试
./cli logcat mp-weixin --project my-app --mode lastBuild > runtime.log &
npx uni-test mp-weixin --testcaseFile tests/login.test.js
```

## 4. 单元测试（Jest）

### 配置

```js
// jest.config.js（项目根目录）
module.exports = {
  testEnvironment: 'jsdom',
  moduleFileExtensions: ['js', 'json', 'vue'],
  transform: {
    '^.+\\.vue$': '@vue/vue2-jest',
    '^.+\\.js$': 'babel-jest',
  },
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  testMatch: ['**/__tests__/**/*.{spec,test}.js'],
  collectCoverageFrom: [
    'src/utils/**/*.js',
    'src/store/**/*.js',
    'src/mixins/**/*.js',
  ],
}
```

### 工具函数测试

```js
// utils/__tests__/format.test.js
import { formatPrice, formatDate } from '../format'

describe('formatPrice', () => {
  test('整数保留两位小数', () => {
    expect(formatPrice(100)).toBe('100.00')
  })
  test('分为单位转元', () => {
    expect(formatPrice(100, { fromCent: true })).toBe('1.00')
  })
})
```

### Store 测试

```js
// store/__tests__/user.test.js
import { setActivePinia, createPinia } from 'pinia'
import { useUserStore } from '../user'

global.uni = {
  getStorageSync: jest.fn(() => ''),
  setStorageSync: jest.fn(),
  removeStorageSync: jest.fn(),
  reLaunch: jest.fn(),
}

describe('useUserStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    jest.clearAllMocks()
  })

  test('初始状态未登录', () => {
    const store = useUserStore()
    expect(store.isLoggedIn).toBe(false)
  })
})
```

### Mock 策略

| 对象 | Mock 方式 |
|------|----------|
| `uni.*` API | `jest.fn()` 全局 mock |
| uniCloud 云对象 | `jest.mock()` 返回假数据 |
| 路由 `uni.navigateTo` | `jest.fn()` 断言调用路径 |

## 5. E2E 测试（uni-test）

### 运行命令

```bash
# 直接调用
./cli test <platform> --testcaseFile tests/login.test.js [--deviceId <id>] [--browser Chrome]

# npm 桥接
npx uni-test mp-weixin --testcaseFile tests/login.test.js
npx uni-test web --testcaseFile tests/login.test.js --browser Chrome
npx uni-test app-android --testcaseFile tests/login.test.js --device_id emulator-5554
```

### 测试示例

```js
// tests/login.test.js
describe('登录流程', () => {
  let page

  beforeAll(async () => {
    page = await automator.launch({
      projectPath: './dist/dev/mp-weixin',
    })
  })

  afterAll(async () => {
    await page.close()
  })

  test('输入账号密码能登录', async () => {
    await page.setData({ username: 'admin', password: '123456' })
    await page.callMethod('handleLogin')
    const text = await page.$('.welcome-text')
    expect(await text.text()).toContain('欢迎')
  })
})
```

### 平台支持

| 平台 | 设备支持 | 说明 |
|------|---------|------|
| web | Chrome、Safari、Firefox | 默认 Chrome |
| app-android | 真机 + 模拟器 | 需 `--device_id` |
| app-ios | 仅模拟器 | 不支持真机 |
| app-harmony | 真机 + 模拟器 | 需鸿蒙环境 |
| mp-weixin 等 | — | 编译后自动测试 |

### 完整 CI 流程

```bash
#!/bin/bash
# ci/test.sh
set -e

echo "=== 1. 编译微信小程序 ==="
npx uni build -p mp-weixin

echo "=== 2. 运行单元测试 ==="
npx jest  # 使用根目录 jest.config.js

echo "=== 3. 启动日志捕获 ==="
npx uni-logcat mp-weixin --mode lastBuild > runtime.log 2>&1 &
LOGPID=$!

echo "=== 4. 运行 E2E 测试 ==="
npx uni-test mp-weixin --testcaseFile tests/e2e.test.js

echo "=== 5. 停止日志捕获 ==="
kill $LOGPID 2>/dev/null

echo "=== 全部通过 ==="
```

### package.json

```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:e2e": "npx uni build -p mp-weixin && npx uni-test mp-weixin --testcaseFile tests/e2e.test.js",
    "test:all": "npm run test && npm run test:e2e",
    "log:web": "npx uni-logcat web --browser Chrome",
    "log:mp": "npx uni-logcat mp-weixin",
    "log:android": "npx uni-logcat app-android"
  }
}
```

## 7. 测试文件组织

```
src/
├── utils/
│   ├── format.js
│   └── __tests__/
│       └── format.test.js
├── store/
│   ├── user.js
│   └── __tests__/
│       └── user.test.js
├── components/
│   ├── PriceTag.vue
│   └── __tests__/
│       └── PriceTag.test.js
tests/
├── e2e/
│   ├── login.test.js
│   └── product.test.js
└── jest.config.js
```

## 8. 测试覆盖要求

| 区域 | 最低覆盖率 | 说明 |
|------|-----------|------|
| `utils/` | 90% | 纯函数，必须充分测试 |
| `store/` | 80% | 状态管理逻辑 |
| `components/` | 60% | 关键交互路径 |
| 页面 | 不强制 | 用 E2E 覆盖核心流程 |

## 9. 禁止事项

| 禁止 | 替代 |
|------|------|
| 用 Vitest（与 uni-test 不兼容） | Jest |
| 用旧版 uni-automator 独立包 | `@dcloudio/hbuilderx-cli` 的 uni-test |
| 测试依赖真实网络 | mock 所有 API 调用 |
| 测试之间共享状态 | `beforeEach` 重置 |
| 不构建就跑 E2E | 先 `npx uni build` 再跑测试 |
| 手动查看日志 | 用 `uni-logcat` 自动捕获 |
| iOS 真机测试 | 仅支持模拟器 |
