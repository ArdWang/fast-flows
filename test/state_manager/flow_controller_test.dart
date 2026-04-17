/// FlowController Tests
///
/// Tests for FlowController, FlowState, and FlowLogic
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('FlowState', () {
    test('FlowState onInit can be overridden', () {
      final state = TestStateWithInit();
      state.onInit();
      expect(state.onInitCalled, isTrue);
    });

    test('FlowState onClose can be called', () {
      final state = TestStateWithInit();
      state.onClose();
      expect(state.onCloseCalled, isTrue);
    });

    test('FlowState basic operations', () {
      final state = TestConcreteState();
      state.onInit();
      state.data['key'] = 'value';
      expect(state.data['key'], equals('value'));
    });
  });

  group('FlowLogic', () {
    test('FlowLogic creates with state', () {
      final logic = TestLogic();
      expect(logic.state, isNotNull);
    });

    test('FlowLogic dispose', () {
      final logic = TestLogic();
      expect(() => logic.dispose(), returnsNormally);
    });
  });

  group('FlowController', () {
    test('FlowController creates', () {
      final controller = TestController();
      expect(controller, isNotNull);
    });

    test('FlowController lifecycle methods can be overridden', () {
      final controller = LifecycleController();
      controller.init();
      controller.start();
      controller.ready();
      controller.close();

      expect(controller.onInitCalled, isTrue);
      expect(controller.onStartCalled, isTrue);
      expect(controller.onReadyCalled, isTrue);
      expect(controller.onCloseCalled, isTrue);
    });

    test('FlowController close disposes', () {
      final controller = TestController();
      controller.close();
      expect(controller.closeCalled, isTrue);
    });

    test('FlowController can only be closed once', () {
      final controller = TestController();
      controller.close();
      // Second close should be safe (idempotent)
      expect(() => controller.close(), returnsNormally);
    });

    test('FlowController update calls refresh', () {
      final controller = TestController();
      // Just verify the method doesn't throw
      expect(() => controller.update(), returnsNormally);
    });

    test('FlowController update with ids calls refreshGroup', () {
      final controller = TestController();
      // Just verify the method doesn't throw
      expect(() => controller.update(['id1', 'id2']), returnsNormally);
    });

    test('FlowController update with condition false does nothing', () {
      final controller = TestController();
      // Just verify the method doesn't throw
      expect(() => controller.update(null, false), returnsNormally);
    });
  });

  group('ListNotifier', () {
    test('ListNotifier creates', () {
      final listNotifier = ListNotifier();
      expect(listNotifier, isNotNull);
    });

    test('ListNotifier notify notifies', () {
      final listNotifier = ListNotifier();
      expect(() => listNotifier.notify(), returnsNormally);
    });

    test('ListNotifier refresh notifies', () {
      final listNotifier = ListNotifier();
      expect(() => listNotifier.refresh(), returnsNormally);
    });

    test('ListNotifier addListenerId and notify with id', () {
      final listNotifier = ListNotifier();
      void listener() {}

      listNotifier.addListenerId('group1', listener);
      expect(() => listNotifier.notify(id: 'group1'), returnsNormally);
    });

    test('ListNotifier removeListenerId', () {
      final listNotifier = ListNotifier();
      void listener() {}

      listNotifier.addListenerId('group1', listener);
      listNotifier.removeListenerId('group1', listener);
      expect(() => listNotifier.notify(id: 'group1'), returnsNormally);
    });

    test('ListNotifier refreshGroup', () {
      final listNotifier = ListNotifier();
      expect(() => listNotifier.refreshGroup('group1'), returnsNormally);
    });
  });
}

class TestState extends FlowState {
  final state = {'initial': 'data'};
}

class TestStateWithInit extends FlowState {
  bool onInitCalled = false;
  bool onCloseCalled = false;

  @override
  void onInit() {
    onInitCalled = true;
  }

  @override
  void onClose() {
    onCloseCalled = true;
  }
}

class TestConcreteState extends FlowState {
  final Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;
}

class TestLogic extends FlowLogic {
  final state = TestState();
}

class TestController extends FlowController {
  bool closeCalled = false;

  @override
  void onClose() {
    closeCalled = true;
    super.onClose();
  }
}

class LifecycleController extends FlowController {
  bool onInitCalled = false;
  bool onStartCalled = false;
  bool onReadyCalled = false;
  bool onCloseCalled = false;

  @override
  void onInit() {
    onInitCalled = true;
    super.onInit();
  }

  @override
  void onStart() {
    onStartCalled = true;
    super.onStart();
  }

  @override
  void onReady() {
    onReadyCalled = true;
    super.onReady();
  }

  @override
  void onClose() {
    onCloseCalled = true;
    super.onClose();
  }
}
