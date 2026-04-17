# fast_flows

A light, modern and powerful Flutter framework combining state management, dependency injection, and route management - inspired by GetX but with a cleaner API.

[![Pub Version](https://img.shields.io/pub/v/fast_flows)](https://pub.dev/packages/fast_flows)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/fast-flows/fast-flows/blob/main/LICENSE)

## Features

- **Dependency Injection**: Simple and powerful DI with `Flow.put()` and `Flow.find()`
- **Reactive State Management**: Rx types (`Rx<T>`, `RxList`, `RxMap`) with `.obs` extension
- **Logic/State/View Architecture**: Clean separation of concerns
- **Route Management**: Easy navigation with `Flow.to()`, `Flow.toNamed()`, `Flow.back()`
- **Lifecycle Management**: `onInit`, `onStart`, `onReady`, `onClose` callbacks
- **Reactive Widgets**: `Flx` and `FlxValue` for automatic UI updates
- **Single-level Observation**: Performance-focused design

## Getting Started

### Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fast_flows: ^0.0.1
```

### Basic Usage

#### Dependency Injection

```dart
// Register
Flow.put(MyService());

// Find
final service = Flow.find<MyService>();

// Check if registered
if (Flow.isRegistered<MyService>()) {
  // ...
}

// Delete
Flow.delete<MyService>();
```

#### Reactive State

```dart
class CounterController extends FlowController {
  final count = 0.obs;
  
  void increment() {
    count.value++;
  }
}

// In your widget
Flx(() => Text('${controller.count.value}'));
```

#### Navigation

```dart
// Navigate
Flow.toNamed('/detail');

// Navigate with arguments
Flow.toNamed('/detail', arguments: {'id': 123});

// Go back
Flow.back();

// Go back with result
Flow.back('result');
```

#### FlowMaterialApp

```dart
FlowMaterialApp(
  pages: [
    FlowPage(name: '/home', page: () => HomePage()),
    FlowPage(name: '/detail', page: () => DetailPage()),
  ],
  initialRoute: '/home',
)
```

## Architecture

fast_flows follows a clean **Logic/State/View** architecture:

- **Logic** (`FlowController`): Business logic and state management
- **State** (`FlowState`): Data models
- **View** (Widgets): UI components using `Flx` for reactive updates

## Documentation

- [English Documentation](README.md)
- [中文文档](README_cn.md)
- [Changelog](CHANGELOG.md)
- [中文更新日志](CHANGELOG_cn.md)

## Example

See the [example](example) directory for a complete working application.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Inspired by [GetX](https://pub.dev/packages/get)
- Built with the Flutter framework
