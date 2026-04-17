# Fast Flows Example

This example application demonstrates all the features of the Fast Flows framework:

- **Dependency Injection** with `Flow.put`/`Flow.find`
- **Reactive state management** with `Rx` types and `Flx` widgets
- **Route management** with `Flow.to`/`Flow.toNamed`
- **Logic/State/View separation pattern**
- **Light/Dark theme switching**
- **Custom app icon** (flows.png)

## Supported Platforms

- Android
- iOS
- Web
- Windows
- macOS
- Linux

## Running the Example

```bash
cd example
flutter pub get
flutter run
```

## Features Demonstrated

1. **Home Page**: Shows reactive state management with counter and theme toggling
2. **Counter Page**: Simple counter example with FlowController
3. **Detail Page**: Demonstrates receiving route arguments
4. **Performance Test Page**: Tests Flx widget performance with 100 items

## Project Structure

```
example/
├── lib/
│   ├── bindings/         # Route bindings
│   │   └── home_binding.dart
│   ├── controllers/      # Controllers
│   │   └── home_controller.dart
│   ├── logic/            # Business logic
│   │   └── home_logic.dart
│   ├── pages/            # UI pages
│   │   ├── home_page.dart
│   │   ├── counter_page.dart
│   │   ├── detail_page.dart
│   │   └── perf_test_page.dart
│   ├── state/            # State classes
│   │   └── home_state.dart
│   ├── utils/            # Utilities
│   │   └── pretty_print.dart
│   ├── views/            # View widgets
│   │   └── home_list_view.dart
│   └── main.dart         # App entry point
├── assets/
│   └── images/
│       └── flows.png     # App icon
└── pubspec.yaml
```
