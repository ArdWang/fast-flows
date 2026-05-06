/// Flows - A light, modern and powerful Flutter framework
///
/// Main features:
/// - Dependency Injection with Flows.put/Flows.find
/// - Reactive state management with Rx types and Flx widget
/// - Route management with Flows.to/Flows.toNamed
/// - Snackbar and Dialog utilities with Flows.snackbar/Flows.dialog
/// - Logic/State/View separation pattern
///
/// IMPORTANT: Flx is designed for SINGLE-LEVEL observation only.
library;

// Core - Dependency Injection, Lifecycle and Navigation
export 'core/flows.dart';
export 'core/lifecycle.dart';

// RX - Reactive types
export 'rx/rx.dart';

// State Manager
export 'state_manager/flows_controller.dart';
export 'state_manager/flows_state.dart';
export 'state_manager/flows_logic.dart';
export 'state_manager/flows_view.dart';
export 'state_manager/flx.dart';

// Navigation
export 'navigation/flows_page.dart';
export 'navigation/flows_app.dart';
export 'navigation/snackbar.dart';
export 'navigation/dialog.dart';
