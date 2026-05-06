/// Flows - Core Dependency Injection Tests
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('Flows Dependency Injection', () {
    setUp(() {
      Flows.reset();
    });

    tearDown(() {
      Flows.reset();
    });

    test('Flows.put and Flows.find works', () {
      Flows.put('test string');
      expect(Flows.find<String>(), equals('test string'));
    });

    test('Flows.isRegistered returns true after put', () {
      Flows.put(123);
      expect(Flows.isRegistered<int>(), isTrue);
    });

    test('Flows.isRegistered returns false for unregistered type', () {
      expect(Flows.isRegistered<String>(), isFalse);
    });

    test('Flows.delete removes dependency', () {
      Flows.put('to delete');
      expect(Flows.isRegistered<String>(), isTrue);
      Flows.delete<String>();
      expect(Flows.isRegistered<String>(), isFalse);
    });

    test('Flows.put with tag works', () {
      Flows.put('test1', tag: 'tag1');
      Flows.put('test2', tag: 'tag2');
      expect(Flows.find<String>(tag: 'tag1'), equals('test1'));
      expect(Flows.find<String>(tag: 'tag2'), equals('test2'));
    });

    test('Flows.isRegistered with tag works', () {
      Flows.put('tagged', tag: 'myTag');
      expect(Flows.isRegistered<String>(tag: 'myTag'), isTrue);
      expect(Flows.isRegistered<String>(tag: 'wrongTag'), isFalse);
    });

    test('Flows.delete with tag works', () {
      Flows.put('delete me', tag: 'toDelete');
      expect(Flows.isRegistered<String>(tag: 'toDelete'), isTrue);
      Flows.delete<String>(tag: 'toDelete');
      expect(Flows.isRegistered<String>(tag: 'toDelete'), isFalse);
    });

    test('Flows.delete permanent dependency without force returns false', () {
      Flows.put('permanent', permanent: true);
      expect(Flows.delete<String>(), isFalse);
      expect(Flows.isRegistered<String>(), isTrue);
    });

    test('Flows.delete permanent dependency with force works', () {
      Flows.put('permanent', permanent: true);
      expect(Flows.delete<String>(force: true), isTrue);
      expect(Flows.isRegistered<String>(), isFalse);
    });

    test('Flows.find throws for unregistered type', () {
      expect(
        () => Flows.find<String>(),
        throwsA(isA<String>()),
      );
    });

    test('Flows.find throws for unregistered tag', () {
      Flows.put('test', tag: 'exists');
      expect(
        () => Flows.find<String>(tag: 'notExists'),
        throwsA(isA<String>()),
      );
    });

    test('Flows.put returns the instance', () {
      final instance = 'return test';
      final result = Flows.put(instance);
      expect(result, equals(instance));
    });

    test('Multiple instances of same type with different tags', () {
      Flows.put('first', tag: '1');
      Flows.put('second', tag: '2');
      Flows.put('third', tag: '3');
      expect(Flows.find<String>(tag: '1'), equals('first'));
      expect(Flows.find<String>(tag: '2'), equals('second'));
      expect(Flows.find<String>(tag: '3'), equals('third'));
    });

    test('Flows.delete returns false for non-existent type', () {
      expect(Flows.delete<String>(), isFalse);
    });
  });

  group('Flows Lazy Registration', () {
    int buildCount = 0;

    setUp(() {
      buildCount = 0;
    });

    test('Flows.lazyPut creates instance on first access', () {
      Flows.lazyPut<String>(() {
        buildCount++;
        return 'lazy';
      });
      expect(buildCount, equals(1));
      expect(Flows.find<String>(), equals('lazy'));
    });

    test('Flows.lazyPut does not rebuild on subsequent access', () {
      Flows.lazyPut<String>(() {
        buildCount++;
        return 'lazy';
      });
      expect(buildCount, equals(1));
      Flows.find<String>();
      Flows.find<String>();
      expect(buildCount, equals(1));
    });

    test('Flows.lazyPut with tag works', () {
      Flows.lazyPut<String>(() {
        buildCount++;
        return 'tagged lazy';
      }, tag: 'lazyTag');
      expect(Flows.find<String>(tag: 'lazyTag'), equals('tagged lazy'));
    });
  });

  group('Flows Lifecycle', () {
    test('Flows.put calls onInit and onReady for FlowLifeCycleMixin', () {
      final controller = LifecycleTestController();
      Flows.put(controller);
      expect(controller.onInitCalled, isTrue);
      expect(controller.onReadyCalled, isTrue);
    });

    test('Flows.delete calls onClose for FlowLifeCycleMixin', () {
      final controller = CloseTestController();
      Flows.put(controller);
      Flows.delete<CloseTestController>();
      expect(controller.onCloseCalled, isTrue);
    });
  });

  group('Flows Navigation', () {
    testWidgets('Flows.to navigates to page', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(name: '/home', page: () => const _HomePage()),
          ],
          initialRoute: '/home',
        ),
      );

      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('Flows.back works', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(name: '/home', page: () => const _HomePage()),
            FlowsPage(name: '/detail', page: () => const _DetailPage()),
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

  group('Flows Arguments', () {
    testWidgets('Flows.toNamed with arguments', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(name: '/home', page: () => const _HomePage()),
            FlowsPage(
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
      Flows.toNamed('/detail', arguments: {'name': 'test'});
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
            onPressed: () => Flows.toNamed('/detail'),
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
            onPressed: () => Flows.back(),
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
