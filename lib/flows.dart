/// Flows - A light, modern and powerful Flutter framework
///
/// Main features:
/// - Dependency Injection with Flow.put/Flow.find
/// - Reactive state management with Rx types and Flx widget
/// - Route management with Flow.to/Flow.toNamed
/// - Snackbar and Dialog utilities with Flow.snackbar/Flow.dialog
/// - Logic/State/View separation pattern
///
/// IMPORTANT: Flx is designed for SINGLE-LEVEL observation only.
library;

// Core - Dependency Injection, Lifecycle and Navigation
export 'core/flow.dart';
export 'core/lifecycle.dart';

// RX - Reactive types
export 'rx/rx.dart';

// State Manager
export 'state_manager/flow_controller.dart';
export 'state_manager/flow_state.dart';
export 'state_manager/flow_logic.dart';
export 'state_manager/flow_view.dart';
export 'state_manager/flx.dart';

// Navigation
export 'navigation/flow_page.dart';
export 'navigation/flow_app.dart';
export 'navigation/snackbar.dart';
export 'navigation/dialog.dart';
