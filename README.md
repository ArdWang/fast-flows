# Fast Flows

[![Pub Version](https://img.shields.io/pub/v/fast_flows.svg)](https://pub.dev/packages/fast_flows)
[![Flutter Version](https://img.shields.io/badge/Flutter-%3E%3D3.3.0-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-%3E%3D3.2.3-blue.svg)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Style](https://img.shields.io/badge/style-flutter__lints--yellow.svg)](https://pub.dev/packages/flutter_lints)

A lightweight, modern, and powerful Flutter framework combining **state management**, **dependency injection**, and **route management** with a clean, high-performance, and easy-to-use API. Inspired by GetX, but with a cleaner design focused on performance and simplicity.

**New in 0.0.3:** Snackbar & Dialog system, enhanced RxList API, RxWorkers (ever, once, debounce), and Flow.context access.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Core Concepts](#core-concepts)
  - [Dependency Injection](#dependency-injection)
  - [Reactive State Management](#reactive-state-management)
  - [Route Management](#route-management)
- [API Reference](#api-reference)
- [Migrating from GetX](#migrating-from-getx)
- [Performance Optimization](#performance-optimization)
- [Example Application](#example-application)
- [Testing](#testing)
- [Code Analysis](#code-analysis)
- [Acknowledgments](#acknowledgments)
- [License](#license)

## Features

- **Dependency Injection**: Simple yet powerful DI with `Flow.put`, `Flow.find`, and `Flow.isRegistered`
- **Reactive State Management**: Ultra-fast reactive programming with `Rx` types and `Flx` widgets
- **Route Management**: Clean navigation API with `Flow.to`, `Flow.toNamed`, and `Flow.back`
- **Logic/State/View Pattern**: Clear separation of concerns for maintainable code
- **Zero Boilerplate**: No StreamControllers, ChangeNotifiers, or InheritedWidgets needed
- **Performance Optimized**: Single-level observation design for maximum performance
- **Type Safe**: Full Dart type system support
- **Multi-platform**: Supports Android, iOS, Web, Windows, macOS, and Linux
- **Snackbar & Dialog**: Built-in notification and dialog system with `Flow.snackbar()` and `Flow.dialog()`
- **RxWorkers**: Reactive workers with `ever()`, `once()`, `debounce()`, and `interval()`

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  fast_flows: ^0.0.3
```

Then run:

```bash
flutter pub get
```

Import the package:

```dart
import 'package:fast_flows/flows.dart';
```

## Quick Start

Here's a complete counter app example:

```dart
import 'package:flutter/material.dart';
import 'package:fast_flows/flows.dart';

// 1. Define State
class CounterState {
  final count = 0.obs;
}

// 2. Define Logic
class CounterLogic extends FlowController {
  CounterLogic() {
    state = CounterState();
  }

  void increment() => state.count.value++;
  void decrement() => state.count.value--;
  void reset() => state.count.value = 0;
}

// 3. Define View
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Register logic (if not already registered)
    if (!Flow.isRegistered<CounterLogic>()) {
      Flow.put(CounterLogic());
    }
    final logic = Flow.find<CounterLogic>();

    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Auto-updating reactive text
            Flx(() => Text(
              'Count: ${logic.state.count.value}',
              style: const TextStyle(fontSize: 32),
            )),
            const SizedBox(height: 32),
            // Buttons with reactive handlers
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

// 4. Define App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Flows Demo',
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

## Architecture

Fast Flows uses the **Logic/State/View** architecture pattern, providing clear separation of concerns:

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│    View     │────▶│    Logic    │────▶│    State    │
│  (Widgets)  │◀────│ (Business)  │◀────│   (Data)    │
└─────────────┘     └─────────────┘     └─────────────┘
```

- **State**: Holds reactive data (`Rx` types)
- **Logic**: Contains business logic and state changes
- **View**: Displays state and dispatches actions to logic

This pattern provides:
- Clear separation of concerns
- Easy testing of business logic
- Reusable state and logic
- Better code organization

## Core Concepts

### Dependency Injection

Fast Flows provides a simple yet powerful dependency injection system:

```dart
// Register a dependency
Flow.put(MyService());

// Register with a name
Flow.put(MyService(), name: 'myService');

// Register as lazy (created on first access)
Flow.putLazy(() => MyService());

// Find a dependency
final service = Flow.find<MyService>();

// Find by name
final service = Flow.find<MyService>(name: 'myService');

// Check if registered
if (Flow.isRegistered<MyService>()) {
  // Do something
}

// Remove a dependency
Flow.remove<MyService>();

// Remove all dependencies
Flow.disposeAll();
```

#### FlowController Lifecycle

`FlowController` provides lifecycle methods:

```dart
class MyLogic extends FlowController {
  @override
  void onInit() {
    super.onInit();
    // Called when controller is created
  }

  @override
  void onClose() {
    // Called when controller is destroyed
    super.onClose();
  }
}
```

### Reactive State Management

Fast Flows uses reactive types that automatically update the UI when state changes:

```dart
// Define reactive state
class MyState {
  final count = 0.obs;              // Reactive int
  final name = ''.obs;              // Reactive String
  final items = RxList<String>([]); // Reactive List
  final user = Rxn<User>();         // Reactive nullable object
  final config = RxMap();           // Reactive Map
  final isActive = false.obs;       // Reactive bool
}
```

#### Using Flx Widgets

`Flx` widgets rebuild when observed state changes:

```dart
// Full widget tree rebuild
Flx(() => Text('Count: ${logic.state.count.value}'));

// FlxValue for single-value optimization
FlxValue(
  logic.state.count,
  (count) => Text('Count: $count'),
);
```

#### Rx Types

| Type | Description | Example |
|------|-------------|---------|
| `Rx<T>` | Reactive wrapper for any type | `Rx<int>(0)` |
| `Rxn<T>` | Nullable reactive wrapper | `Rxn<User>()` |
| `RxBool` | Reactive bool | `false.obs` |
| `RxInt` | Reactive int | `0.obs` |
| `RxDouble` | Reactive double | `0.0.obs` |
| `RxString` | Reactive String | `''.obs` |
| `RxList<T>` | Reactive List | `RxList<String>([])` |
| `RxMap<K, V>` | Reactive Map | `RxMap()` |
| `RxSet<T>` | Reactive Set | `RxSet()` |

### Route Management

Fast Flows provides a clean navigation API:

```dart
// Navigate to named route
Flow.toNamed('/detail');

// Navigate with arguments
Flow.toNamed('/detail', arguments: {'id': 123});

// Navigate to custom page
Flow.to(NextPage());

// Navigate to custom page with arguments
Flow.to(NextPage(), arguments: {'data': myData});

// Go back
Flow.back();

// Go back with result
Flow.back({'result': 'success'});

// Replace current route
Flow.off(NextPage());

// Replace all routes
Flow.offAll(NextPage());
```

#### FlowMaterialApp

```dart
FlowMaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'My App',
  // Light theme
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  ),
  // Dark theme
  darkTheme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blue,
      brightness: Brightness.dark,
    ),
  ),
  themeMode: ThemeMode.system,
  // Define routes
  pages: [
    FlowPage(name: '/home', page: () => HomePage()),
    FlowPage(name: '/detail', page: () => DetailPage()),
  ],
  initialRoute: '/home',
)
```

#### Receiving Route Arguments

**At View level (recommended):**

```dart
class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get arguments from route settings
    final args = ModalRoute.of(context)?.settings.arguments;
    final id = args is Map ? args['id'] as int? : null;
    final data = args is Map ? args['data'] : null;

    // Use id and data...
  }
}
```

### Snackbar & Dialog

**Show a Snackbar:**

```dart
// Simple snackbar (displays at top by default)
Flow.snackbar('Title', 'Message content');

// Snackbar at bottom
Flow.snackbar(
  'Info',
  'This is a message',
  snackPosition: SnackPosition.bottom,
  duration: const Duration(seconds: 3),
);

// Custom snackbar with icon and colors
Flow.snackbar(
  'Success!',
  'Operation completed successfully',
  snackPosition: SnackPosition.top,
  backgroundColor: Colors.green,
  icon: const Icon(Icons.check_circle, color: Colors.white),
);

// Raw snackbar with full customization
Flow.rawSnackbar(
  title: 'Custom',
  message: 'Fully customized snackbar',
  backgroundColor: Colors.blue,
  duration: const Duration(seconds: 5),
  mainButton: TextButton(
    onPressed: () => Flow.back(),
    child: const Text('ACTION'),
  ),
);

// Close all snackbars
Flow.closeAllSnackbars();
```

**Show a Dialog:**

```dart
// Custom dialog
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
        const Text('Custom Dialog', style: TextStyle(fontSize: 24)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => Flow.back(),
          child: const Text('Close'),
        ),
      ],
    ),
  ),
);

// Default alert dialog
await Flow.defaultDialog(
  title: 'Alert',
  middleText: 'This is an alert dialog',
  textConfirm: 'OK',
  textCancel: 'Cancel',
  onConfirm: () {
    // Handle confirm
    Flow.back();
  },
  onCancel: () {
    // Handle cancel
    Flow.back();
  },
);

// Close all dialogs
Flow.closeAllDialogs();

// Check if dialog is open
if (Flow.isDialogOpen) {
  // Dialog is currently open
}
```

### RxWorkers

RxWorkers provide reactive workers for listening to observable changes:

```dart
// ever() - Execute callback on every value change
final count = 0.obs;
Worker worker;

@override
void onInit() {
  worker = ever(count, (value) {
    print('Count changed to: $value');
  });
}

// once() - Execute callback only on first change
Worker worker = once(count, (value) {
  print('Count first changed to: $value');
});

// debounce() - Execute callback after specified delay of no changes
final searchQuery = ''.obs;
Worker worker = debounce(searchQuery, (value) {
  print('Search for: $value');
}, time: const Duration(milliseconds: 500));

// interval() - Execute callback after delay
Worker worker = interval(count, (value) {
  print('Value after interval: $value');
}, delay: const Duration(seconds: 1));

// workers() - Container to manage multiple workers
Workers myWorkers = workers();

@override
void onInit() {
  myWorkers.add(ever(count, (v) => print('count: $v')));
  myWorkers.add(ever(name, (v) => print('name: $v')));
}

@override
void onClose() {
  myWorkers.dispose(); // Dispose all workers at once
  super.onClose();
}

// Worker extension methods
count.onChanged((value) => print('changed: $value'));
count.onFirstChange((value) => print('first change: $value'));
```

## API Reference

### Flow (Dependency Injection)

| Method | Description |
|--------|-------------|
| `Flow.put<T>(instance)` | Register a dependency |
| `Flow.putLazy<T>(factory)` | Register a lazy dependency |
| `Flow.find<T>(name)` | Find a dependency |
| `Flow.isRegistered<T>(name)` | Check if registered |
| `Flow.remove<T>(name)` | Remove a dependency |
| `Flow.disposeAll()` | Remove all dependencies |
| `Flow.context` | Get current BuildContext |
| `Flow.isDialogOpen` | Check if dialog is open |

### FlowController

| Method | Description |
|--------|-------------|
| `onInit()` | Called when controller is created |
| `onClose()` | Called when controller is destroyed |

### Rx Types

| Constructor | Description |
|-------------|-------------|
| `T.obs` | Extension to create reactive type |
| `Rx<T>(value)` | Create reactive wrapper |
| `Rxn<T>()` | Create nullable reactive wrapper |
| `RxList<T>` constructor | Create reactive List |
| `RxMap<K, V>` constructor | Create reactive Map |

### RxList Extensions

| Method | Description |
|--------|-------------|
| `isEmpty` | Returns true if list is empty |
| `isNotEmpty` | Returns true if list is not empty |
| `first` | Returns first element |
| `last` | Returns last element |
| `firstWhereOrNull(test)` | Returns first matching element or null |
| `lastWhereOrNull(test)` | Returns last matching element or null |
| `map(mapFn)` | Returns new RxList with mapped values |
| `where(test)` | Returns new RxList with filtered values |
| `sort(compare)` | Sorts the list |
| `reversed()` | Reverses the list |
| `addNonNull(item)` | Adds item only if not null |
| `addIf(condition, item)` | Adds item only if condition is true |
| `assign(item)` | Replaces all items with single item |
| `assignAll(items)` | Replaces all items with list |

### Flx Widgets

| Widget | Description |
|--------|-------------|
| `Flx(builder)` | Reactive widget builder |
| `FlxValue(rx, builder)` | Optimized single-value reactive widget |

### Navigation

| Method | Description |
|--------|-------------|
| `Flow.to(page)` | Navigate to page |
| `Flow.toNamed(name)` | Navigate to named route |
| `Flow.back()` | Go back |
| `Flow.off(page)` | Replace current route |
| `Flow.offAll(page)` | Replace all routes |

### Snackbar

| Method | Description |
|--------|-------------|
| `Flow.snackbar(title, message)` | Show snackbar with custom position |
| `Flow.rawSnackbar(...)` | Show fully customized snackbar |
| `Flow.closeAllSnackbars()` | Close all open snackbars |

### Dialog

| Method | Description |
|--------|-------------|
| `Flow.dialog(widget)` | Show custom dialog |
| `Flow.defaultDialog(...)` | Show default alert dialog |
| `Flow.closeAllDialogs()` | Close all open dialogs |

### RxWorkers

| Function | Description |
|----------|-------------|
| `ever(observable, callback)` | Execute callback on every change |
| `once(observable, callback)` | Execute callback on first change only |
| `debounce(observable, callback, time)` | Execute callback after delay of no changes |
| `interval(observable, callback, delay)` | Execute callback after delay |
| `everAll(observables, callback)` | Listen to multiple observables |
| `workers()` | Create workers container |

## Migrating from GetX

Fast Flows is inspired by GetX but with a cleaner API. Here's how to migrate:

### GetX to Fast Flows Migration Table

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
| `RxInt`, `RxString`, etc. | Same, using `.obs` extension |
| `GetMaterialApp` | `FlowMaterialApp` |
| `GetPage` | `FlowPage` |

### Migration Example

**GetX:**
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

**Fast Flows:**
```dart
class Controller extends FlowController {
  final count = 0.obs;
  void increment() => count.value++;
}

Flow.put(Controller());
Flx(() => Text('Count: ${logic.state.count.value}'));
```

## Performance Optimization

1. **Use FlxValue for single values**: More efficient than full `Flx` rebuild

```dart
// Less efficient
Flx(() => Text('Count: ${logic.state.count.value}'));

// More efficient
FlxValue(logic.state.count, (count) => Text('Count: $count'));
```

2. **Single-level observation**: Fast Flows uses single-level observation for better performance

```dart
// Good - direct observation
final count = 0.obs;

// Avoid - nested observation
final data = RxMap({'count': 0.obs}); // Don't do this
```

3. **Dispose controllers**: Always dispose controllers when no longer needed

```dart
@override
void onClose() {
  // Cleanup
  super.onClose();
}
```

4. **Use named routes**: Named routes are faster than widget navigation

```dart
// Faster
Flow.toNamed('/detail', arguments: {'id': 123});

// Slower
Flow.to(DetailPage(id: 123));
```

## Example Application

The `example/` directory contains a complete sample application demonstrating all features:

- Dependency Injection with `Flow.put`/`Flow.find`
- Reactive State Management with `Rx` types and `Flx` widgets
- Route Management with `Flow.to`/`Flow.toNamed`
- Logic/State/View separation pattern
- Light/Dark theme switching
- Passing and editing objects between routes

Run the example:

```bash
cd example
flutter pub get
flutter run
```

## Testing

Fast Flows includes a comprehensive test suite covering all core functionality modules:

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/core/flow_test.dart
flutter test test/rx/rx_types_test.dart
flutter test test/state_manager/flx_test.dart

# Run with coverage report
flutter test --coverage
```

### Test Coverage

| Module | Test File | Tests |
|--------|-----------|-------|
| Core - Flow | `test/core/flow_test.dart` | 17 |
| Core - Lifecycle | `test/core/lifecycle_test.dart` | 5 |
| RX Types | `test/rx/rx_types_test.dart` | 27 |
| RX List | `test/rx/rx_list_test.dart` | 14 |
| RX Map | `test/rx/rx_map_test.dart` | 13 |
| State Management | `test/state_manager/flow_controller_test.dart` | 14 |
| Flx Widgets | `test/state_manager/flx_test.dart` | 15 |
| Navigation | `test/navigation/flow_page_test.dart` | 13 |
| **Total** | | **281** |

All tests pass, ensuring library stability and reliability.

## Code Analysis

Run static code analysis with:

```bash
flutter analyze
```

Current status: ✅ No issues found

## Acknowledgments

Fast Flows is inspired by the excellent work of [GetX](https://pub.dev/packages/get) by Jonny Borges. We thank GetX for bringing innovative approaches to Flutter development. Fast Flows builds on these ideas with a focus on performance optimization and API simplicity.

Special thanks:
- [GetX](https://pub.dev/packages/get) - Pioneered reactive state management and dependency injection in Flutter
- The Flutter team - For building an amazing UI framework

## License

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
