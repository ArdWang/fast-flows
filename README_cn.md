# Fast Flows

[![Pub Version](https://img.shields.io/pub/v/fast_flows.svg)](https://pub.dev/packages/fast_flows)
[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.3.0-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.2.3-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Style](https://img.shields.io/badge/style-flutter__lints--yellow.svg)](https://pub.dev/packages/flutter_lints)

一个轻量级、现代化、强大的 Flutter 框架，结合了**状态管理**、**依赖注入**和**路由管理**，提供简洁、高性能且易用的 API。灵感来源于 GetX，但设计更简洁，专注于性能和简单性。

**0.0.3 新增：** Snackbar & Dialog 系统、增强的 RxList API、RxWorkers（ever、once、debounce）、Flow.context 访问。

## 目录

- [特性](#特性)
- [安装](#安装)
- [快速开始](#快速开始)
- [架构](#架构)
- [核心概念](#核心概念)
  - [依赖注入](#依赖注入)
  - [响应式状态管理](#响应式状态管理)
  - [路由管理](#路由管理)
- [API 参考](#api-参考)
- [从 GetX 迁移](#从-getx-迁移)
- [性能优化](#性能优化)
- [示例应用](#示例应用)
- [致谢](#致谢)
- [许可证](#许可证)

## 特性

- **依赖注入**：简单而强大的 DI，支持 `Flow.put`、`Flow.find` 和 `Flow.isRegistered`
- **响应式状态管理**：超快的响应式编程，支持 `Rx` 类型和 `Flx` 小组件
- **路由管理**：简洁的导航 API，支持 `Flow.to`、`Flow.toNamed` 和 `Flow.back`
- **Logic/State/View 模式**：清晰关注点分离，代码更易维护
- **零模板代码**：不需要 StreamControllers、ChangeNotifiers 或 InheritedWidgets
- **性能优化**：单层观察设计，最大化性能
- **类型安全**：完整的 Dart 类型系统支持
- **多平台**：支持 Android、iOS、Web、Windows、macOS 和 Linux
- **Snackbar & Dialog**：内置通知和对话框系统，支持 `Flow.snackbar()` 和 `Flow.dialog()`
- **RxWorkers**：响应式 worker，支持 `ever()`、`once()`、`debounce()` 和 `interval()`

## 安装

将此添加到您的 `pubspec.yaml`：

```yaml
dependencies:
  flutter:
    sdk: flutter
  fast_flows: ^0.0.3
```

然后运行：

```bash
flutter pub get
```

导入包：

```dart
import 'package:fast_flows/flows.dart';
```

## 快速开始

这是一个完整的计数器应用示例：

```dart
import 'package:flutter/material.dart';
import 'package:fast_flows/flows.dart';

// 1. 定义状态
class CounterState {
  final count = 0.obs;
}

// 2. 定义逻辑
class CounterLogic extends FlowController {
  CounterLogic() {
    state = CounterState();
  }

  void increment() => state.count.value++;
  void decrement() => state.count.value--;
  void reset() => state.count.value = 0;
}

// 3. 定义视图
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 注册逻辑（如果尚未注册）
    if (!Flow.isRegistered<CounterLogic>()) {
      Flow.put(CounterLogic());
    }
    final logic = Flow.find<CounterLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('计数器')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 自动更新的响应式文本
            Flx(() => Text(
              '计数：${logic.state.count.value}',
              style: const TextStyle(fontSize: 32),
            )),
            const SizedBox(height: 32),
            // 带响应式处理器的按钮
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: logic.decrement,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: logic.increment,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: logic.reset,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 4. 定义应用
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Flows 演示',
      pages: [
        FlowPage(name: '/counter', page: () => const CounterPage()),
      ],
      initialRoute: '/counter',
    );
  }
}

void main() {
  runApp(const MyApp());
}
```

## 架构

Fast Flows 使用 **Logic/State/View** 架构模式，提供清晰的关注点分离：

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    View     │────▶│    Logic    │────▶│    State    │
│  (小组件)    │◀────│  (业务逻辑)  │◀────│   (数据)    │
└─────────────┘     └─────────────┘     └─────────────┘
```

- **State**：保存响应式数据（`Rx` 类型）
- **Logic**：包含业务逻辑和状态变更
- **View**：显示状态并向逻辑分发操作

此模式提供：
- 清晰的关注点分离
- 易于测试业务逻辑
- 可复用的状态和逻辑
- 更好的代码组织

## 核心概念

### 依赖注入

Fast Flows 提供简单而强大的依赖注入系统：

```dart
// 注册依赖
Flow.put(MyService());

// 使用名称注册
Flow.put(MyService(), name: 'myService');

// 注册为懒加载（首次访问时创建）
Flow.putLazy(() => MyService());

// 查找依赖
final service = Flow.find<MyService>();

// 按名称查找
final service = Flow.find<MyService>(name: 'myService');

// 检查是否已注册
if (Flow.isRegistered<MyService>()) {
  // 执行操作
}

// 移除依赖
Flow.remove<MyService>();

// 移除所有依赖
Flow.disposeAll();
```

#### FlowController 生命周期

`FlowController` 提供生命周期方法：

```dart
class MyLogic extends FlowController {
  @override
  void onInit() {
    super.onInit();
    // 控制器创建时调用
  }

  @override
  void onClose() {
    // 控制器销毁时调用
    super.onClose();
  }
}
```

### 响应式状态管理

Fast Flows 使用响应式类型，当状态改变时自动更新 UI：

```dart
// 定义响应式状态
class MyState {
  final count = 0.obs;              // 响应式 int
  final name = ''.obs;              // 响应式 String
  final items = RxList<String>([]); // 响应式 List
  final user = Rxn<User>();         // 响应式可空对象
  final config = RxMap();           // 响应式 Map
  final isActive = false.obs;       // 响应式 bool
}
```

#### 使用 Flx 小组件

`Flx` 小组件在观察的状态改变时重建：

```dart
// 完整重建小组件树
Flx(() => Text('Count: ${logic.state.count.value}'));

// FlxValue 用于单值优化
FlxValue(
  logic.state.count,
  (count) => Text('Count: $count'),
);
```

#### Rx 类型

| 类型 | 描述 | 示例 |
|------|------|------|
| `Rx<T>` | 任意类型的响应式包装器 | `Rx<int>(0)` |
| `Rxn<T>` | 可空响应式包装器 | `Rxn<User>()` |
| `RxBool` | 响应式 bool | `false.obs` |
| `RxInt` | 响应式 int | `0.obs` |
| `RxDouble` | 响应式 double | `0.0.obs` |
| `RxString` | 响应式 String | `''.obs` |
| `RxList<T>` | 响应式 List | `RxList<String>([])` |
| `RxMap<K, V>` | 响应式 Map | `RxMap()` |
| `RxSet<T>` | 响应式 Set | `RxSet()` |

### 路由管理

Fast Flows 提供简洁的导航 API：

```dart
// 导航到命名路由
Flow.toNamed('/detail');

// 带参数导航
Flow.toNamed('/detail', arguments: {'id': 123});

// 导航到自定义页面
Flow.to(NextPage());

// 带参数导航到自定义页面
Flow.to(NextPage(), arguments: {'data': myData});

// 返回
Flow.back();

// 带结果返回
Flow.back({'result': 'success'});

// 替换当前路由
Flow.off(NextPage());

// 替换所有路由
Flow.offAll(NextPage());
```

#### FlowMaterialApp

```dart
FlowMaterialApp(
  debugShowCheckedModeBanner: false,
  title: '我的应用',
  // 浅色主题
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  ),
  // 深色主题
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system,
  // 定义路由
  pages: [
    FlowPage(name: '/home', page: () => HomePage()),
    FlowPage(name: '/detail', page: () => DetailPage()),
  ],
  initialRoute: '/home',
)
```

#### 接收路由参数

**视图级别（推荐）：**

```dart
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 从路由设置获取参数
    final args = ModalRoute.of(context)?.settings.arguments;
    final id = args is Map ? args['id'] as int? : null;
    final data = args is Map ? args['data'] : null;

    // 使用 id 和 data...
  }
}
```

### Snackbar & Dialog

**显示 Snackbar：**

```dart
// 简单 snackbar（默认顶部显示）
Flow.snackbar('标题', '消息内容');

// 底部显示
Flow.snackbar(
  '提示',
  '这是一条消息',
  snackPosition: SnackPosition.bottom,
  duration: const Duration(seconds: 3),
);

// 自定义 snackbar，带图标和颜色
Flow.snackbar(
  '成功！',
  '操作已完成',
  snackPosition: SnackPosition.top,
  backgroundColor: Colors.green,
  icon: const Icon(Icons.check_circle, color: Colors.white),
);

// 完全自定义的 snackbar
Flow.rawSnackbar(
  title: '自定义',
  message: '完全自定义的 snackbar',
  backgroundColor: Colors.blue,
  duration: const Duration(seconds: 5),
  mainButton: TextButton(
    onPressed: () => Flow.back(),
    child: const Text('操作'),
  ),
);

// 关闭所有 snackbar
Flow.closeAllSnackbars();
```

**显示 Dialog：**

```dart
// 自定义对话框
await Flow.dialog(
  Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.celebration, size: 64),
        const SizedBox(height: 16),
        const Text('自定义对话框', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => Flow.back(),
          child: const Text('关闭'),
        ),
      ],
    ),
  ),
);

// 默认警报对话框
await Flow.defaultDialog(
  title: '提示',
  middleText: '这是一个警报对话框',
  textConfirm: '确定',
  textCancel: '取消',
  onConfirm: () {
    // 处理确认
    Flow.back();
  },
  onCancel: () {
    // 处理取消
    Flow.back();
  },
);

// 关闭所有对话框
Flow.closeAllDialogs();

// 检查对话框是否打开
if (Flow.isDialogOpen) {
  // 对话框当前已打开
}
```

### RxWorkers

RxWorkers 提供响应式 worker 用于监听 observable 变化：

```dart
// ever() - 每次值变化时执行回调
final count = 0.obs;
Worker worker;

@override
void onInit() {
  worker = ever(count, (value) {
    print('Count 变为：$value');
  });
}

// once() - 仅在第一次变化时执行回调
Worker worker = once(count, (value) {
  print('Count 第一次变为：$value');
});

// debounce() - 在指定的防抖延迟后执行回调
final searchQuery = ''.obs;
Worker worker = debounce(searchQuery, (value) {
  print('搜索：$value');
}, time: const Duration(milliseconds: 500));

// interval() - 延迟执行回调
Worker worker = interval(count, (value) {
  print('延迟后的值：$value');
}, delay: const Duration(seconds: 1));

// workers() - 管理多个 worker 的容器
Workers myWorkers = workers();

@override
void onInit() {
  myWorkers.add(ever(count, (v) => print('count: $v')));
  myWorkers.add(ever(name, (v) => print('name: $v')));
}

@override
void onClose() {
  myWorkers.dispose(); // 一次性处理所有 worker
  super.onClose();
}

// Worker 扩展方法
count.onChanged((value) => print('changed: $value'));
count.onFirstChange((value) => print('first change: $value'));
```

## API 参考

### Flow（依赖注入）

| 方法 | 描述 |
|------|------|
| `Flow.put<T>(instance)` | 注册依赖 |
| `Flow.putLazy<T>(factory)` | 注册懒加载依赖 |
| `Flow.find<T>(name)` | 查找依赖 |
| `Flow.isRegistered<T>(name)` | 检查是否已注册 |
| `Flow.remove<T>(name)` | 移除依赖 |
| `Flow.disposeAll()` | 移除所有依赖 |
| `Flow.context` | 获取当前 BuildContext |
| `Flow.isDialogOpen` | 检查对话框是否打开 |

### FlowController

| 方法 | 描述 |
|------|------|
| `onInit()` | 控制器创建时调用 |
| `onClose()` | 控制器销毁时调用 |

### Rx 类型

| 构造函数 | 描述 |
|---------|------|
| `T.obs` | 创建响应式类型的扩展 |
| `Rx<T>(value)` | 创建响应式包装器 |
| `Rxn<T>()` | 创建可空响应式包装器 |
| `RxList<T>` 构造函数 | 创建响应式 List |
| `RxMap<K, V>` 构造函数 | 创建响应式 Map |

### RxList 扩展

| 方法 | 描述 |
|------|------|
| `isEmpty` | 如果列表为空返回 true |
| `isNotEmpty` | 如果列表不为空返回 true |
| `first` | 返回第一个元素 |
| `last` | 返回最后一个元素 |
| `firstWhereOrNull(test)` | 返回第一个匹配元素或 null |
| `lastWhereOrNull(test)` | 返回最后一个匹配元素或 null |
| `map(mapFn)` | 返回映射后的新 RxList |
| `where(test)` | 返回过滤后的新 RxList |
| `sort(compare)` | 排序列表 |
| `reversed()` | 反转列表 |
| `addNonNull(item)` | 仅在 item 不为 null 时添加 |
| `addIf(condition, item)` | 仅在 condition 为 true 时添加 |
| `assign(item)` | 用单个 item 替换所有元素 |
| `assignAll(items)` | 用列表替换所有元素 |

### Flx 小组件

| 小组件 | 描述 |
|--------|------|
| `Flx(builder)` | 响应式小组件构建器 |
| `FlxValue(rx, builder)` | 优化的单值响应式小组件 |

### 导航

| 方法 | 描述 |
|------|------|
| `Flow.to(page)` | 导航到页面 |
| `Flow.toNamed(name)` | 导航到命名路由 |
| `Flow.back()` | 返回 |
| `Flow.off(page)` | 替换当前路由 |
| `Flow.offAll(page)` | 替换所有路由 |

### Snackbar

| 方法 | 描述 |
|------|------|
| `Flow.snackbar(title, message)` | 显示自定义位置的 snackbar |
| `Flow.rawSnackbar(...)` | 显示完全自定义的 snackbar |
| `Flow.closeAllSnackbars()` | 关闭所有 snackbar |

### Dialog

| 方法 | 描述 |
|------|------|
| `Flow.dialog(widget)` | 显示自定义对话框 |
| `Flow.defaultDialog(...)` | 显示默认警报对话框 |
| `Flow.closeAllDialogs()` | 关闭所有对话框 |

### RxWorkers

| 函数 | 描述 |
|------|------|
| `ever(observable, callback)` | 每次变化时执行回调 |
| `once(observable, callback)` | 仅在第一次变化时执行回调 |
| `debounce(observable, callback, time)` | 防抖延迟后执行回调 |
| `interval(observable, callback, delay)` | 延迟后执行回调 |
| `everAll(observables, callback)` | 监听多个 observable |
| `workers()` | 创建 workers 容器 |

## 从 GetX 迁移

Fast Flows 灵感来源于 GetX，但 API 更简洁。以下是迁移方法：

### GetX 到 Fast Flows 迁移表

| GetX | Fast Flows |
|------|------------|
| `Get.put()` | `Flow.put()` |
| `Get.find()` | `Flow.find()` |
| `Get.isRegistered()` | `Flow.isRegistered()` |
| `Get.delete()` | `Flow.remove()` |
| `Get.to()` | `Flow.to()` |
| `Get.toNamed()` | `Flow.toNamed()` |
| `Get.back()` | `Flow.back()` |
| `Get.off()` | `Flow.off()` |
| `Get.offAll()` | `Flow.offAll()` |
| `GetX<Controller>` | `Flx(() => ...)` |
| `Obx(() => ...)` | `Flx(() => ...)` |
| `RxInt`, `RxString` 等 | 相同，使用 `.obs` 扩展 |
| `GetMaterialApp` | `FlowMaterialApp` |
| `GetPage` | `FlowPage` |

### 迁移示例

**GetX：**
```dart
class Controller extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;
}

Get.put(Controller());
GetX<Controller>(
  builder: (_) => Text('Count: ${_.count.value}'),
);
```

**Fast Flows：**
```dart
class Controller extends FlowController {
  final count = 0.obs;
  void increment() => count.value++;
}

Flow.put(Controller());
Flx(() => Text('Count: ${logic.state.count.value}'));
```

## 性能优化

1. **对单值使用 FlxValue**：比完整 `Flx` 重建更高效

```dart
// 效率较低
Flx(() => Text('Count: ${logic.state.count.value}'));

// 更高效
FlxValue(logic.state.count, (count) => Text('Count: $count'));
```

2. **单层观察**：Fast Flows 使用单层观察设计以获得更好性能

```dart
// 好 - 直接观察
final count = 0.obs;

// 避免 - 嵌套观察
final data = RxMap({'count': 0.obs}); // 不要这样做
```

3. **销毁控制器**：不再需要时始终销毁控制器

```dart
@override
void onClose() {
  // 清理
  super.onClose();
}
```

4. **使用命名路由**：命名路由比小组件导航更快

```dart
// 更快
Flow.toNamed('/detail', arguments: {'id': 123});

// 较慢
Flow.to(DetailPage(id: 123));
```

## 示例应用

`example/` 目录包含一个完整示例应用，展示所有功能：

- 使用 `Flow.put`/`Flow.find` 的依赖注入
- 使用 `Rx` 类型和 `Flx` 小组件的响应式状态管理
- 使用 `Flow.to`/`Flow.toNamed` 的路由管理
- Logic/State/View 分离模式
- 浅色/深色主题切换
- 路由间对象传递和编辑功能

运行示例：

```bash
cd example
flutter pub get
flutter run
```

## 测试

Fast Flows 包含全面的测试套件，涵盖所有核心功能模块：

```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/core/flow_test.dart
flutter test test/rx/rx_types_test.dart
flutter test test/state_manager/flx_test.dart

# 运行并生成覆盖率报告
flutter test --coverage
```

### 测试覆盖

| 模块 | 测试文件 | 测试数量 |
|------|----------|----------|
| 核心 - Flow | `test/core/flow_test.dart` | 17 |
| 核心 - 生命周期 | `test/core/lifecycle_test.dart` | 5 |
| RX 类型 | `test/rx/rx_types_test.dart` | 27 |
| RX List | `test/rx/rx_list_test.dart` | 14 |
| RX Map | `test/rx/rx_map_test.dart` | 13 |
| 状态管理 | `test/state_manager/flow_controller_test.dart` | 14 |
| Flx 小组件 | `test/state_manager/flx_test.dart` | 15 |
| 导航 | `test/navigation/flow_page_test.dart` | 13 |
| **总计** | | **281** |

所有测试均通过，确保库的稳定性和可靠性。

## 代码分析

使用以下命令进行代码静态分析：

```bash
flutter analyze
```

当前状态：✅ 无问题（No issues found）

## 致谢

Fast Flows 的灵感来源于 [GetX](https://pub.dev/packages/get) 的出色工作，作者 Jonny Borges。我们感谢 GetX 为 Flutter 开发带来的创新方法。Fast Flows 在这些理念的基础上构建，专注于性能优化和 API 简洁性。

特别感谢：
- [GetX](https://pub.dev/packages/get) - 开创了 Flutter 中的响应式状态管理和依赖注入
- Flutter 团队 - 构建了令人惊叹的 UI 框架

## 许可证

```
MIT License

Copyright (c) 2026 Fast Flows

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
