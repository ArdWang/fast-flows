# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.4] - 2026-05-05

### Changed

- **BREAKING**: Renamed `Flow` class to `Flows` to avoid conflict with Flutter's built-in `Flow` widget
  - `Flow.put()` → `Flows.put()`
  - `Flow.find()` → `Flows.find()`
  - `Flow.to()` → `Flows.to()`
  - `Flow.back()` → `Flows.back()`
  - All other `Flow.*` methods renamed to `Flows.*`
- Renamed `FlowBinding` to `FlowsBinding`
- Renamed all `Flow*` prefixed classes to `Flows*`:
  - `FlowMaterialApp` → `FlowsMaterialApp`
  - `FlowCupertinoApp` → `FlowsCupertinoApp`
  - `FlowPage` → `FlowsPage`
  - `FlowSnackBar` → `FlowsSnackBar`
  - `FlowDialogRoute` → `FlowsDialogRoute`
- Removed `hide Flow` from all imports (no longer needed)
- Renamed all library files from `flow*.dart` to `flows*.dart`:
  - `lib/core/flow.dart` → `lib/core/flows.dart`
  - `lib/state_manager/flow_controller.dart` → `lib/state_manager/flows_controller.dart`
  - `lib/state_manager/flow_state.dart` → `lib/state_manager/flows_state.dart`
  - `lib/state_manager/flow_logic.dart` → `lib/state_manager/flows_logic.dart`
  - `lib/state_manager/flow_view.dart` → `lib/state_manager/flows_view.dart`
  - `lib/navigation/flow_page.dart` → `lib/navigation/flows_page.dart`
  - `lib/navigation/flow_app.dart` → `lib/navigation/flows_app.dart`
  - `test/core/flow_test.dart` → `test/core/flows_test.dart`
  - `test/navigation/flow_page_test.dart` → `test/navigation/flows_page_test.dart`
  - `test/state_manager/flow_controller_test.dart` → `test/state_manager/flows_controller_test.dart`

## [0.0.3] - 2026-04-20

### Added
- **Snackbar System** - GetX-like snackbar with `Flows.snackbar()` and `Flows.rawSnackbar()`:
  - Customizable position (top/bottom) with `SnackPosition`
  - Customizable style (floating/grounded) with `SnackStyle`
  - Icon support with pulse animation
  - Progress indicator support
  - Custom background colors and gradients
  - Action button support
  - Dismiss control with `Flows.closeAllSnackbars()`
  - `SnackbarController` for programmatic control
- **Dialog System** - GetX-like dialogs with `Flows.dialog()` and `Flows.defaultDialog()`:
  - Custom dialog widgets with `Flows.dialog()`
  - Pre-built alert dialogs with `Flows.defaultDialog()`
  - Configurable barrier color and dismissibility
  - Custom transition animations
  - Close all dialogs with `Flows.closeAllDialogs()`
- **Flows.context** - Access current BuildContext from anywhere
- **Flows.isDialogOpen** - Check if a dialog is currently open
- **Enhanced RxList API**:
  - `isEmpty`, `isNotEmpty` properties
  - `first`, `last` accessors
  - `firstWhereOrNull()`, `lastWhereOrNull()` methods
  - `map()`, `where()` transformation methods
  - `sort()`, `reversed()` operations
  - `addNonNull()`, `addIf()`, `addAllIf()` conditional methods
  - `assign()`, `assignAll()` replacement methods
  - `contains()`, `indexOf()` utility methods
- **Enhanced RxWorkers**:
  - `ever()` - Execute callback on every value change
  - `once()` - Execute callback only on first change
  - `interval()` - Execute callback after delay of no changes
  - `debounce()` - Execute callback after specified delay
  - `everAll()` - Listen to multiple observables
  - `workers()` - Container to manage multiple workers
  - `Worker` class for subscription management
  - Extension methods `onChanged()` and `onFirstChange()`
- **Flows.refresh()** - Trigger UI rebuild on demand
- **New Features Test Page** - Example page demonstrating all new features
- Comprehensive test suite with **281 tests** covering all core modules

### Changed
- Moved snackbar and dialog functionality into Flows core class
- Enhanced Flows class with context access and dialog state tracking
- Updated example app with new features test page
- All tests passing (281/281)

### Fixed
- RxList `remove()` now returns bool indicating success
- RxList `removeAt()` now returns the removed element
- Added `Flows.reset()` method for testing support
- Snackbar positioning - now correctly displays at top/bottom
- Dialog size constraint - custom dialogs now have max width of 400px
- Various lint warnings and info messages

### Performance
- Zero boilerplate - no StreamControllers, ChangeNotifiers, or InheritedWidgets required
- Efficient widget rebuilding with FlxValue for single-value observation
- Single-level observation design for optimal performance

## [0.0.2] - 2026-04-17

### Added
- **Snackbar System** - GetX-like snackbar with `Flows.snackbar()` and `Flows.rawSnackbar()`:
  - Customizable position (top/bottom) with `SnackPosition`
  - Customizable style (floating/grounded) with `SnackStyle`
  - Icon support with pulse animation
  - Progress indicator support
  - Custom background colors and gradients
  - Action button support
  - Dismiss control with `Flows.closeAllSnackbars()`
  - `SnackbarController` for programmatic control
- **Dialog System** - GetX-like dialogs with `Flows.dialog()` and `Flows.defaultDialog()`:
  - Custom dialog widgets with `Flows.dialog()`
  - Pre-built alert dialogs with `Flows.defaultDialog()`
  - Configurable barrier color and dismissibility
  - Custom transition animations
  - Close all dialogs with `Flows.closeAllDialogs()`
- **Flows.context** - Access current BuildContext from anywhere
- **Flows.isDialogOpen** - Check if a dialog is currently open
- **Enhanced RxList API**:
  - `isEmpty`, `isNotEmpty` properties
  - `first`, `last` accessors
  - `firstWhereOrNull()`, `lastWhereOrNull()` methods
  - `map()`, `where()` transformation methods
  - `sort()`, `reversed()` operations
  - `addNonNull()`, `addIf()`, `addAllIf()` conditional methods
  - `assign()`, `assignAll()` replacement methods
  - `contains()`, `indexOf()` utility methods
- **Enhanced RxWorkers**:
  - `ever()` - Execute callback on every value change
  - `once()` - Execute callback only on first change
  - `interval()` - Execute callback after delay of no changes
  - `debounce()` - Execute callback after specified delay
  - `everAll()` - Listen to multiple observables
  - `workers()` - Container to manage multiple workers
  - `Worker` class for subscription management
  - Extension methods `onChanged()` and `onFirstChange()`
- **Flows.refresh()** - Trigger UI rebuild on demand
- **New Features Test Page** - Example page demonstrating all new features
- Comprehensive test suite with **281 tests** covering all core modules

### Changed
- Moved snackbar and dialog functionality into Flows core class
- Enhanced Flows class with context access and dialog state tracking
- Updated example app with new features test page
- All tests passing (281/281)

### Fixed
- RxList `remove()` now returns bool indicating success
- RxList `removeAt()` now returns the removed element
- Added `Flows.reset()` method for testing support
- Various lint warnings and info messages

### Performance
- Zero boilerplate - no StreamControllers, ChangeNotifiers, or InheritedWidgets required
- Efficient widget rebuilding with FlxValue for single-value observation
- Single-level observation design for optimal performance

## [0.0.1] - 2026-04-17

### Added
- Initial release of Fast Flows framework
- **Dependency Injection** system with `Flows.put`, `Flows.find`, `Flows.isRegistered`, and `Flows.delete`
- **Reactive State Management** with Rx types:
  - `Rx<T>`, `Rxn<T>` for generic reactive wrappers
  - `RxBool`, `RxInt`, `RxDouble`, `RxString` for primitive types
  - `RxList<T>`, `RxMap<K,V>` for collections
  - `.obs` extension for easy reactive type creation
- **Route Management** with `Flows.to`, `Flows.toNamed`, `Flows.back`, `Flows.off`, `Flows.offAll`
- **FlowsMaterialApp** widget for app configuration with theme support
- **FlowsPage** for named route definitions with transition support
- **FlowController** base class with lifecycle methods (`onInit`, `onClose`)
- **Flx** reactive widget builder
- **FlxValue** optimized single-value reactive widget
- **Logic/State/View** architecture pattern support
- Example app demonstrating all features:
  - Counter page with reactive state
  - Home page with UserData editing and theme switching
  - Detail page with route parameter receiving
  - Performance test page with Flx optimization
  - Light/Dark theme switching via global ThemeController
  - Custom app icon configuration
- Comprehensive documentation:
  - README.md (English)
  - README_cn.md (Chinese)
  - CHANGELOG.md
  - CHANGELOG_cn.md
- Multi-platform support:
  - Android
  - iOS
  - Web
  - Windows
  - macOS
  - Linux

### Changed
- Package renamed from `liteflows` to `fast_flows` to avoid naming conflicts on pub.dev
- Optimized route argument passing to preserve `settings.arguments`
- Updated default theme colors to cyan/teal (0xFF26C6DA) for brand consistency
- Improved AppBar colors with darker shades for better contrast
- Enhanced example app with editable UserData model
- Refined API design based on GetX inspiration with cleaner syntax

### Fixed
- Route arguments not being passed correctly when using `FlowsMaterialApp`
- Theme switching not reflecting in UI
- Type casting issues with nullable UserData parameters
- Static analysis warnings and info messages

### Performance
- Single-level observation design for optimal performance
- Zero boilerplate - no StreamControllers, ChangeNotifiers, or InheritedWidgets required
- Efficient widget rebuilding with FlxValue for single-value observation

## [Unreleased]

### Planned
- Additional Rx operators and utilities
- Middleware support for route navigation
- Enhanced DevTools integration
- More comprehensive test coverage
- Additional example templates

---

**Acknowledgments:**

This project is inspired by the excellent work on [GetX](https://pub.dev/packages/get).
We want to express our gratitude to Jonny Borges and the GetX community for pioneering
reactive state management and dependency injection in Flutter.
