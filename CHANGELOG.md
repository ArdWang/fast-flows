# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.3] - 2026-04-20

### Added
- **Snackbar System** - GetX-like snackbar with `Flow.snackbar()` and `Flow.rawSnackbar()`:
  - Customizable position (top/bottom) with `SnackPosition`
  - Customizable style (floating/grounded) with `SnackStyle`
  - Icon support with pulse animation
  - Progress indicator support
  - Custom background colors and gradients
  - Action button support
  - Dismiss control with `Flow.closeAllSnackbars()`
  - `SnackbarController` for programmatic control
- **Dialog System** - GetX-like dialogs with `Flow.dialog()` and `Flow.defaultDialog()`:
  - Custom dialog widgets with `Flow.dialog()`
  - Pre-built alert dialogs with `Flow.defaultDialog()`
  - Configurable barrier color and dismissibility
  - Custom transition animations
  - Close all dialogs with `Flow.closeAllDialogs()`
- **Flow.context** - Access current BuildContext from anywhere
- **Flow.isDialogOpen** - Check if a dialog is currently open
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
- **Flow.refresh()** - Trigger UI rebuild on demand
- **New Features Test Page** - Example page demonstrating all new features
- Comprehensive test suite with **281 tests** covering all core modules

### Changed
- Moved snackbar and dialog functionality into Flow core class
- Enhanced Flow class with context access and dialog state tracking
- Updated example app with new features test page
- All tests passing (281/281)

### Fixed
- RxList `remove()` now returns bool indicating success
- RxList `removeAt()` now returns the removed element
- Added `Flow.reset()` method for testing support
- Snackbar positioning - now correctly displays at top/bottom
- Dialog size constraint - custom dialogs now have max width of 400px
- Various lint warnings and info messages

### Performance
- Zero boilerplate - no StreamControllers, ChangeNotifiers, or InheritedWidgets required
- Efficient widget rebuilding with FlxValue for single-value observation
- Single-level observation design for optimal performance

## [0.0.2] - 2026-04-17

### Added
- **Snackbar System** - GetX-like snackbar with `Flow.snackbar()` and `Flow.rawSnackbar()`:
  - Customizable position (top/bottom) with `SnackPosition`
  - Customizable style (floating/grounded) with `SnackStyle`
  - Icon support with pulse animation
  - Progress indicator support
  - Custom background colors and gradients
  - Action button support
  - Dismiss control with `Flow.closeAllSnackbars()`
  - `SnackbarController` for programmatic control
- **Dialog System** - GetX-like dialogs with `Flow.dialog()` and `Flow.defaultDialog()`:
  - Custom dialog widgets with `Flow.dialog()`
  - Pre-built alert dialogs with `Flow.defaultDialog()`
  - Configurable barrier color and dismissibility
  - Custom transition animations
  - Close all dialogs with `Flow.closeAllDialogs()`
- **Flow.context** - Access current BuildContext from anywhere
- **Flow.isDialogOpen** - Check if a dialog is currently open
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
- **Flow.refresh()** - Trigger UI rebuild on demand
- **New Features Test Page** - Example page demonstrating all new features
- Comprehensive test suite with **281 tests** covering all core modules

### Changed
- Moved snackbar and dialog functionality into Flow core class
- Enhanced Flow class with context access and dialog state tracking
- Updated example app with new features test page
- All tests passing (281/281)

### Fixed
- RxList `remove()` now returns bool indicating success
- RxList `removeAt()` now returns the removed element
- Added `Flow.reset()` method for testing support
- Various lint warnings and info messages

### Performance
- Zero boilerplate - no StreamControllers, ChangeNotifiers, or InheritedWidgets required
- Efficient widget rebuilding with FlxValue for single-value observation
- Single-level observation design for optimal performance

## [0.0.1] - 2026-04-17

### Added
- Initial release of Fast Flows framework
- **Dependency Injection** system with `Flow.put`, `Flow.find`, `Flow.isRegistered`, and `Flow.delete`
- **Reactive State Management** with Rx types:
  - `Rx<T>`, `Rxn<T>` for generic reactive wrappers
  - `RxBool`, `RxInt`, `RxDouble`, `RxString` for primitive types
  - `RxList<T>`, `RxMap<K,V>` for collections
  - `.obs` extension for easy reactive type creation
- **Route Management** with `Flow.to`, `Flow.toNamed`, `Flow.back`, `Flow.off`, `Flow.offAll`
- **FlowMaterialApp** widget for app configuration with theme support
- **FlowPage** for named route definitions with transition support
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
- Route arguments not being passed correctly when using `FlowMaterialApp`
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
