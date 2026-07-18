---
name: uni-hbuilderx-cli
description: "HBuilderX CLI 操作规范。适用于编译、运行、日志捕获、发布的自动化操作。"
alwaysApply: false
---

# HBuilderX CLI 操作规范

AI agent 通过 HBuilderX CLI 自动化编译、运行、日志捕获和发布。

## 1. CLI 位置

| 平台 | 路径 |
|------|------|
| macOS | `/Applications/HBuilderX.app/Contents/MacOS/cli` |
| macOS Alpha | `/Applications/HBuilderX-Alpha.app/Contents/MacOS/cli` |
| Windows | `{HBuilderX安装目录}\cli.exe` |
| Linux | `{HBuilderX安装目录}/cli` |

环境变量 `HBUILDERX_CLI_PATH` 可手动指定路径。

### npm 桥接包（推荐 CI）

```bash
npm install @dcloudio/hbuilderx-cli --save-dev
```

提供：`hbuilderx`、`uni-launch`、`uni-logcat`、`uni-test` 四个 CLI。自动检测 HBuilderX 安装路径。

## 2. 编译运行

### 启动开发模式

```bash
# 运行到浏览器
cli launch web --project <项目名> [--browser Chrome]

# 运行到 Android 设备
cli launch app-android --project <项目名> [--deviceId <设备ID>]

# 运行到 iOS 模拟器
cli launch app-ios --project <项目名> [--deviceId <模拟器ID>]

# 运行到小程序（自动打开微信开发者工具）
cli launch mp-weixin --project <项目名>
```

参数说明：

| 参数 | 说明 |
|------|------|
| `--ui true` | 使用 HBuilderX 界面运行（默认 CLI 模式） |
| `--compile true` | 仅编译不运行 |
| `--continue-on-error true` | 编译错误后继续 |
| `--native-log` | 显示原生日志 |

### uni CLI（npm 项目）

```bash
# 开发模式（热更新）
npm run dev:h5
npm run dev:mp-weixin
npm run dev:app           # Vue 3
npm run dev:app-plus      # Vue 2

# 生产构建
npm run build:h5
npm run build:mp-weixin
npm run build:app
```

产物目录：
- dev 模式：`/dist/dev/<平台>/`
- build 模式：`/dist/build/<平台>/`

**注意：** uni CLI 的 App 构建只生成 wgt 资源包，不能云打包 APK/IPA。App 云打包必须用 HBuilderX CLI。

## 3. 日志捕获（logcat）

这是 AI 开发最重要的能力——实时拿到运行时 console.log、错误、警告。

### 命令格式

```bash
cli logcat <platform> --project <项目名> [--mode full|lastBuild|prevBuild] [--browser Chrome]

# npm 桥接
npx uni-logcat <platform> [--mode full|lastBuild|prevBuild]
```

### 平台支持

| 平台标识 | 说明 | 额外参数 |
|---------|------|---------|
| `web` | H5 | `--browser Built\|Chrome\|Firefox\|Safari` |
| `app-android` | Android | `--deviceId <id>` |
| `app-ios` | iOS | `--deviceId <id>` |
| `app-harmony` | 鸿蒙 | `--deviceId <id>` |
| `mp-weixin` | 微信小程序 | — |
| `mp-alipay` | 支付宝小程序 | — |
| `mp-baidu` / `mp-toutiao` / `mp-qq` | 其他小程序 | — |
| `mp-jd` / `mp-kuaishou` / `mp-xhs` / `mp-lark` | 更多小程序 | — |
| `pack` | App 云打包日志 | — |
| `unicloud` | uniCloud 日志 | — |

### 日志模式

| 模式 | 说明 |
|------|------|
| `prevBuild`（默认） | 最近一次构建的日志 |
| `lastBuild` | 最后一个构建周期 |
| `full` | 所有日志 |

### 日志格式

```
16:42:37.575 检查云端打包状态...
16:42:38.016 [LOG] pages/index/index.vue:42 用户登录成功
16:42:38.689 [WARN] pages/product/list.vue:15 废弃 API 调用
16:42:39.100 [ERROR] pages/order/detail.vue:88 TypeError: Cannot read property
```

### AI 开发中的使用

```bash
# 1. 启动开发模式
cli launch mp-weixin --project my-app &

# 2. 捕获日志到文件（后台）
cli logcat mp-weixin --project my-app --mode lastBuild > runtime.log 2>&1 &

# 3. 修改代码后，重新编译会自动触发热更新
# 4. 读取日志文件分析错误
cat runtime.log | grep -i error
```

## 4. 设备管理

```bash
# 列出已连接设备
cli devices list --platform android
cli devices list --platform ios-iPhone
cli devices list --platform ios-simulator
cli devices list --platform app-harmony
```

## 5. 发布

### H5 发布

```bash
cli publish --platform h5 --project <项目名>
# 或
cli publish web --project <项目名>
```

### 小程序发布

```bash
# 编译 + 上传到微信
cli publish --platform mp-weixin --project <项目名> \
  --upload true \
  --appid <AppID> \
  --privatekey <密钥路径>

# 仅编译不上传
cli publish --platform mp-weixin --project <项目名>
```

### App 云打包

```bash
# Android 云打包
cli pack --project <项目名> --platform android \
  --android.packagename com.example.app \
  --android.androidpacktype 0

# iOS 云打包
cli pack --project <项目名> --platform ios

# 查询打包状态
cli pack status --project <项目名>

# 取消打包
cli pack cancel --project <项目名> --platform android
```

参数说明：

| 参数 | 说明 |
|------|------|
| `--ui false` | 纯 CLI 模式（默认，适合 CI） |
| `--ignoreWarnings true` | 警告不阻塞 |
| `--dsyms true` | iOS 生成 dSYM 文件 |
| `--config <json-path>` | 打包配置文件 |

### 云打包 CI 示例

```bash
# 登录
cli user login --username <user> --password <pass>

# 打包
cli pack --project demo-app --platform android \
  --android.packagename com.example.app

# 监控日志（另开终端）
cli logcat pack

# 查询状态
cli pack status --project demo-app
```

## 6. 登录管理

```bash
# 登录
cli user login --username <用户名> --password <密码> [--global true]

# 查看登录状态
cli user info

# 退出
cli user logout
```

## 7. uni-test 自动化测试

详见 `skills/uni-testing/SKILL.md`。

```bash
# 运行测试
cli test mp-weixin --testcaseFile tests/login.test.js
cli test web --testcaseFile tests/login.test.js --browser Chrome
cli test app-android --testcaseFile tests/login.test.js --device_id emulator-5554

# npm 桥接
npx uni-test mp-weixin --testcaseFile tests/login.test.js
```

## 8. 版本要求

| 功能 | 最低版本 |
|------|---------|
| 基础 CLI | 3.1.5+ |
| 小程序发布 | 3.3.7+ |
| logcat + uni-test | 4.87+ |
| launch 命令 | 5.0+ |
| pack status / --ui | 5.11+ |
| pack cancel | 5.14+ |

## 9. 禁止事项

| 禁止 | 替代 |
|------|------|
| App 云打包用 uni CLI | 必须用 HBuilderX CLI |
| 手动查看日志 | `cli logcat` 自动捕获 |
| 不登录就打包 | 先 `cli user login` |
| iOS 真机测试 | 仅支持模拟器 |
| 忽略 logcat 输出 | 必须检查 error/warning |
