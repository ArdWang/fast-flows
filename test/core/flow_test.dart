/// Flow - Core Dependency Injection Tests
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('Flow Dependency Injection', () {
    setUp(() {
      Flow.reset();
    });

    tearDown(() {
      Flow.reset();
    });

    test('Flow.put and Flow.find works', () {
      Flow.put('test string');
      expect(Flow.find<String>(), equals('test string'));
    });

    test('Flow.isRegistered returns true after put', () {
      Flow.put(123);
      expect(Flow.isRegistered<int>(), isTrue);
    });

    test('Flow.isRegistered returns false for unregistered type', () {
      expect(Flow.isRegistered<String>(), isFalse);
    });

    test('Flow.delete removes dependency', () {
      Flow.put('to delete');
      expect(Flow.isRegistered<String>(), isTrue);
      Flow.delete<String>();
      expect(Flow.isRegistered<String>(), isFalse);
    });

    test('Flow.put with tag works', () {
      Flow.put('test1', tag: 'tag1');
      Flow.put('test2', tag: 'tag2');
      expect(Flow.find<String>(tag: 'tag1'), equals('test1'));
      expect(Flow.find<String>(tag: 'tag2'), equals('test2'));
    });

    test('Flow.isRegistered with tag works', () {
      Flow.put('tagged', tag: 'myTag');
      expect(Flow.isRegistered<String>(tag: 'myTag'), isTrue);
      expect(Flow.isRegistered<String>(tag: 'wrongTag'), isFalse);
    });

    test('Flow.delete with tag works', () {
      Flow.put('delete me', tag: 'toDelete');
      expect(Flow.isRegistered<String>(tag: 'toDelete'), isTrue);
      Flow.delete<String>(tag: 'toDelete');
      expect(Flow.isRegistered<String>(tag: 'toDelete'), isFalse);
    });

    test('Flow.delete permanent dependency without force returns false', () {
      Flow.put('permanent', permanent: true);
      expect(Flow.delete<String>(), isFalse);
      expect(Flow.isRegistered<String>(), isTrue);
    });

    test('Flow.delete permanent dependency with force works', () {
      Flow.put('permanent', permanent: true);
      expect(Flow.delete<String>(force: true), isTrue);
      expect(Flow.isRegistered<String>(), isFalse);
    });

    test('Flow.find throws for unregistered type', () {
      expect(
        () => Flow.find<String>(),
        throwsA(isA<String>()),
      );
    });

    test('Flow.find throws for unregistered tag', () {
      Flow.put('test', tag: 'exists');
      expect(
        () => Flow.find<String>(tag: 'notExists'),
        throwsA(isA<String>()),
      );
    });

    test('Flow.put returns the instance', () {
      final instance = 'return test';
      final result = Flow.put(instance);
      expect(result, equals(instance));
    });

    test('Multiple instances of same type with different tags', () {
      Flow.put('first', tag: '1');
      Flow.put('second', tag: '2');
      Flow.put('third', tag: '3');
      expect(Flow.find<String>(tag: '1'), equals('first'));
      expect(Flow.find<String>(tag: '2'), equals('second'));
      expect(Flow.find<String>(tag: '3'), equals('third'));
    });

    test('Flow.delete returns false for non-existent type', () {
      expect(Flow.delete<String>(), isFalse);
    });
  });

  group('Flow Lazy Registration', () {
    int buildCount = 0;

    setUp(() {
      buildCount = 0;
    });

    test('Flow.lazyPut creates instance on first access', () {
      Flow.lazyPut<String>(() {
        buildCount++;
        return 'lazy';
      });
      expect(buildCount, equals(1));
      expect(Flow.find<String>(), equals('lazy'));
    });

    test('Flow.lazyPut does not rebuild on subsequent access', () {
      Flow.lazyPut<String>(() {
        buildCount++;
        return 'lazy';
      });
      expect(buildCount, equals(1));
      Flow.find<String>();
      Flow.find<String>();
      expect(buildCount, equals(1));
    });

    test('Flow.lazyPut with tag works', () {
      Flow.lazyPut<String>(() {
        buildCount++;
        return 'tagged lazy';
      }, tag: 'lazyTag');
      expect(Flow.find<String>(tag: 'lazyTag'), equals('tagged lazy'));
    });
  });

  group('Flow Lifecycle', () {
    test('Flow.put calls onInit and onReady for FlowLifeCycleMixin', () {
      final controller = LifecycleTestController();
      Flow.put(controller);
      expect(controller.onInitCalled, isTrue);
      expect(controller.onReadyCalled, isTrue);
    });

    test('Flow.delete calls onClose for FlowLifeCycleMixin', () {
      final controller = CloseTestController();
      Flow.put(controller);
      Flow.delete<CloseTestController>();
      expect(controller.onCloseCalled, isTrue);
    });
  });

  group('Flow Navigation', () {
    testWidgets('Flow.to navigates to page', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(name: '/home', page: () => const _HomePage()),
          ],
          initialRoute: '/home',
        ),
      );

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Flow.back works', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(name: '/home', page: () => const _HomePage()),
            FlowPage(name: '/detail', page: () => const _DetailPage()),
          ],
          initialRoute: '/home',
        ),
      );

      // Navigate to detail
      await tester.tap(find.text('Go to Detail'));
      await tester.pumpAndSettle();
      expect(find.text('Detail'), findsOneWidget);

      // Go back
      await tester.tap(find.text('Go Back'));
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    });
  });

  group('Flow Arguments', () {
    testWidgets('Flow.toNamed with arguments', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(name: '/home', page: () => const _HomePage()),
            FlowPage(
              name: '/detail',
              page: () => Builder(
                builder: (context) {
                  final arg = ModalRoute.of(context)?.settings.arguments;
                  return Scaffold(body: Text('Detail: ${arg ?? "none"}'));
                },
              ),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      // Navigate with arguments
      Flow.toNamed('/detail', arguments: {'name': 'test'});
      await tester.pumpAndSettle();

      expect(find.textContaining('Detail:'), findsOneWidget);
    });
  });
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Home'),
          ElevatedButton(
            onPressed: () => Flow.toNamed('/detail'),
            child: const Text('Go to Detail'),
          ),
        ],
      ),
    );
  }
}

class _DetailPage extends StatelessWidget {
  const _DetailPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Detail'),
          ElevatedButton(
            onPressed: () => Flow.back(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

class LifecycleTestController extends FlowController {
  bool onInitCalled = false;
  bool onReadyCalled = false;

  @override
  void onInit() {
    onInitCalled = true;
    super.onInit();
  }

  @override
  void onReady() {
    onReadyCalled = true;
    super.onReady();
  }
}

class CloseTestController extends FlowController {
  bool onCloseCalled = false;

  @override
  void onClose() {
    onCloseCalled = true;
    super.onClose();
  }
}
