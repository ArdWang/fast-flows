/// FlowState - Base state class
library;

/// Base class for state objects
abstract class FlowState {
  /// Called when state is created
  void onInit() {}

  /// Called when state is disposed
  void onClose() {}
}
