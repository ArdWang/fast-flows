# 更新日志

本项目的所有重要更改都将记录在此文件中。

格式基于 [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)，
本项目遵循 [语义化版本](https://semver.org/spec/v2.0.0.html)。

## [0.0.3] - 2026-04-20

### 新增
- **Snackbar 系统** - GetX 风格的 snackbar，支持 `Flow.snackbar()` 和 `Flow.rawSnackbar()`：
  - 可自定义位置（顶部/底部）与 `SnackPosition`
  - 可自定义样式（浮动/贴地）与 `SnackStyle`
  - 图标支持脉冲动画
  - 进度指示器支持
  - 自定义背景色和渐变
  - 操作按钮支持
  - 关闭控制与 `Flow.closeAllSnackbars()`
  - `SnackbarController` 用于编程控制
- **Dialog 系统** - GetX 风格的对话框，支持 `Flow.dialog()` 和 `Flow.defaultDialog()`：
  - 自定义对话框小组件与 `Flow.dialog()`
  - 预定义的警报对话框与 `Flow.defaultDialog()`
  - 可配置的屏障颜色和可取消性
  - 自定义过渡动画
  - 关闭所有对话框与 `Flow.closeAllDialogs()`
- **Flow.context** - 从任何地方访问当前 BuildContext
- **Flow.isDialogOpen** - 检查对话框是否当前打开
- **增强的 RxList API**：
  - `isEmpty`、`isNotEmpty` 属性
  - `first`、`last` 访问器
  - `firstWhereOrNull()`、`lastWhereOrNull()` 方法
  - `map()`、`where()` 转换方法
  - `sort()`、`reversed()` 操作方法
  - `addNonNull()`、`addIf()`、`addAllIf()` 条件方法
  - `assign()`、`assignAll()` 替换方法
  - `contains()`、`indexOf()` 工具方法
- **增强的 RxWorkers**：
  - `ever()` - 每次值变化时执行回调
  - `once()` - 仅在第一次变化时执行回调
  - `interval()` - 延迟执行回调
  - `debounce()` - 防抖执行回调
  - `everAll()` - 监听多个 observable
  - `workers()` - 管理多个 worker 的容器
  - `Worker` 类用于订阅管理
  - 扩展方法 `onChanged()` 和 `onFirstChange()`
- **Flow.refresh()** - 按需触发 UI 重建
- **新功能测试页面** - 示例页面展示所有新功能
- 全面的测试套件，包含 **281 个测试**，覆盖所有核心模块

### 更改
- 将 snackbar 和 dialog 功能移入 Flow 核心类
- 增强 Flow 类，添加 context 访问和对话框状态跟踪
- 更新示例应用，添加新功能测试页面
- 所有测试通过（281/281）

### 修复
- RxList `remove()` 现在返回 bool 表示成功
- RxList `removeAt()` 现在返回被移除的元素
- 添加 `Flow.reset()` 方法用于测试支持
- Snackbar 定位 - 现在正确显示在顶部/底部
- Dialog 尺寸约束 - 自定义对话框现在有最大宽度 400px
- 各种 lint 警告和信息消息

### 性能
- 零模板代码 - 不需要 StreamControllers、ChangeNotifiers 或 InheritedWidgets
- 使用 FlxValue 进行单值观察，高效的小组件重建
- 单层观察设计，实现最优性能

## [0.0.2] - 2026-04-17

### 新增
- 全面的测试套件，包含 **281 个测试**，覆盖所有核心模块：
  - Flow 依赖注入测试（17 个测试）
  - FlowController 生命周期测试（5 个测试）
  - Rx 类型测试（27 个测试）
  - RxList 测试（14 个测试）
  - RxMap 测试（13 个测试）
  - FlowController/FlowState/FlowLogic 测试（14 个测试）
  - Flx 和 FlxValue 小组件测试（15 个测试）
  - FlowPage 导航测试（13 个测试）
- `Flow.reset()` 方法用于测试支持
- README.md 和 README_cn.md 中的测试文档

### 修复
- 移除了 `RxList.value` setter 中不必要的 override，修复 lint 警告
- 移除了 `RxMap.value` setter 中不必要的 override，修复 lint 警告
- 修复了 rx_types_test.dart 中的 doc comment HTML 格式问题

### 更改
- 更新 README.md 为完整的英文文档
- 更新 README_cn.md 添加测试覆盖章节
- 所有测试通过（281/281）
- Flutter analyze：无问题（No issues found）

## [0.0.1] - 2026-04-17

### 新增
- Fast Flows 框架首次发布
- **依赖注入** 系统，支持 `Flow.put`、`Flow.find`、`Flow.isRegistered` 和 `Flow.delete`
- **响应式状态管理**，支持 Rx 类型：
  - `Rx<T>`、`Rxn<T>` 通用响应式包装器
  - `RxBool`、`RxInt`、`RxDouble`、`RxString` 原始类型
  - `RxList<T>`、`RxMap<K,V>` 集合类型
  - `.obs` 扩展用于轻松创建响应式类型
- **路由管理**，支持 `Flow.to`、`Flow.toNamed`、`Flow.back`、`Flow.off`、`Flow.offAll`
- **FlowMaterialApp** 小组件，支持应用配置和主题
- **FlowPage** 用于命名路由定义，支持过渡动画
- **FlowController** 基类，提供生命周期方法（`onInit`、`onClose`）
- **Flx** 响应式小组件构建器
- **FlxValue** 优化的单值响应式小组件
- **Logic/State/View** 架构模式支持
- 示例应用展示所有功能：
  - 带响应式状态的计数器页面
  - 带 UserData 编辑和主题切换的主页面
  - 带路由参数接收的详情页面
  - 带 Flx 优化的性能测试页面
  - 浅色/深色主题切换（通过全局 ThemeController）
  - 自定义应用图标配置
- 全面的文档：
  - README.md（英文）
  - README_cn.md（中文）
  - CHANGELOG.md
  - CHANGELOG_cn.md
- 多平台支持：
  - Android
  - iOS
  - Web
  - Windows
  - macOS
  - Linux

### 更改
- 包名从 `liteflows` 更改为 `fast_flows`，避免 pub.dev 上的命名冲突
- 优化路由参数传递，保留 `settings.arguments`
- 更新默认主题颜色为青蓝色（0xFF26C6DA）以保持品牌一致性
- 改进 AppBar 颜色，使用更深的色调以获得更好的对比度
- 增强示例应用，支持可编辑的 UserData 模型
- 基于 GetX 的灵感优化 API 设计，语法更简洁

### 修复
- 使用 `FlowMaterialApp` 时路由参数无法正确传递的问题
- 主题切换在 UI 中不生效的问题
- 可空 UserData 参数的类型转换问题
- 静态分析警告和信息消息

### 性能
- 单层观察设计，实现最优性能
- 零模板代码 - 不需要 StreamControllers、ChangeNotifiers 或 InheritedWidgets
- 使用 FlxValue 进行单值观察，高效的小组件重建

## [未发布]

### 计划
- 更多 Rx 运算符和工具函数
- 路由导航中间件支持
- 增强的 DevTools 集成
- 更全面的测试覆盖
- 更多示例模板

---

**致谢：**

本项目受到 [GetX](https://pub.dev/packages/get) 出色工作的启发。
我们感谢 Jonny Borges 和 GetX 社区在 Flutter 响应式状态管理和依赖注入方面的开创性工作。
