/// Lifecycle Tests
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('FlowLifeCycleMixin', () {
    test('onInit is called only once', () {
      final controller = InitTestController();
      controller.init();
      controller.init();
      controller.init();

      expect(controller.initCount, equals(1));
    });

    test('onStart is called only once', () {
      final controller = StartTestController();
      controller.start();
      controller.start();
      controller.start();

      expect(controller.startCount, equals(1));
    });

    test('onReady is called only once', () {
      final controller = ReadyTestController();
      controller.ready();
      controller.ready();
      controller.ready();

      expect(controller.readyCount, equals(1));
    });

    test('onClose can be called multiple times', () {
      final controller = CloseCountController();
      controller.close();
      controller.close();

      expect(controller.closeCount, equals(2));
    });

    test('All lifecycle methods are called in order', () {
      final controller = OrderTestController();
      controller.init();
      controller.start();
      controller.ready();
      controller.close();

      expect(controller.lifecycleOrder, equals(['onInit', 'onStart', 'onReady', 'onClose']));
    });
  });
}

class InitTestController extends FlowController {
  int initCount = 0;

  @override
  void onInit() {
    initCount++;
    super.onInit();
  }
}

class StartTestController extends FlowController {
  int startCount = 0;

  @override
  void onStart() {
    startCount++;
    super.onStart();
  }
}

class ReadyTestController extends FlowController {
  int readyCount = 0;

  @override
  void onReady() {
    readyCount++;
    super.onReady();
  }
}

class CloseCountController extends FlowController {
  int closeCount = 0;

  @override
  void onClose() {
    closeCount++;
    super.onClose();
  }
}

class OrderTestController extends FlowController {
  final lifecycleOrder = <String>[];

  @override
  void onInit() {
    lifecycleOrder.add('onInit');
    super.onInit();
  }

  @override
  void onStart() {
    lifecycleOrder.add('onStart');
    super.onStart();
  }

  @override
  void onReady() {
    lifecycleOrder.add('onReady');
    super.onReady();
  }

  @override
  void onClose() {
    lifecycleOrder.add('onClose');
    super.onClose();
  }
}
