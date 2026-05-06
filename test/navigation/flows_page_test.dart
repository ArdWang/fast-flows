/// FlowsPage Tests
///
/// Tests for FlowsPage and navigation functionality
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('FlowsPage', () {
    test('FlowsPage creates with name and page builder', () {
      final flowPage = FlowsPage(
        name: '/home',
        page: () => const Scaffold(body: Text('Home')),
      );

      expect(flowPage.name, equals('/home'));
      expect(flowPage.page, isNotNull);
      expect(flowPage.transition, equals(TransitionType.none));
    });

    test('FlowsPage with fade transition', () {
      final flowPage = FlowsPage(
        name: '/fade',
        page: () => const Scaffold(),
        transition: TransitionType.fade,
      );

      expect(flowPage.transition, equals(TransitionType.fade));
    });

    test('FlowsPage with slideLeft transition', () {
      final flowPage = FlowsPage(
        name: '/slideLeft',
        page: () => const Scaffold(),
        transition: TransitionType.slideLeft,
      );

      expect(flowPage.transition, equals(TransitionType.slideLeft));
    });

    test('FlowsPage with slideRight transition', () {
      final flowPage = FlowsPage(
        name: '/slideRight',
        page: () => const Scaffold(),
        transition: TransitionType.slideRight,
      );

      expect(flowPage.transition, equals(TransitionType.slideRight));
    });

    test('FlowsPage with slideUp transition', () {
      final flowPage = FlowsPage(
        name: '/slideUp',
        page: () => const Scaffold(),
        transition: TransitionType.slideUp,
      );

      expect(flowPage.transition, equals(TransitionType.slideUp));
    });

    test('FlowsPage with slideDown transition', () {
      final flowPage = FlowsPage(
        name: '/slideDown',
        page: () => const Scaffold(),
        transition: TransitionType.slideDown,
      );

      expect(flowPage.transition, equals(TransitionType.slideDown));
    });

    test('FlowsPage with zoom transition', () {
      final flowPage = FlowsPage(
        name: '/zoom',
        page: () => const Scaffold(),
        transition: TransitionType.zoom,
      );

      expect(flowPage.transition, equals(TransitionType.zoom));
    });

    test('FlowsPage createRoute returns MaterialPageRoute', () {
      final flowPage = FlowsPage(
        name: '/home',
        page: () => const Scaffold(body: Text('Home')),
      );

      final route = flowPage.createRoute();
      expect(route, isA<MaterialPageRoute>());
    });

    test('FlowsPage createPageRoute returns PageRouteBuilder for fade', () {
      final flowPage = FlowsPage(
        name: '/fade',
        page: () => const Scaffold(),
        transition: TransitionType.fade,
      );

      final route = flowPage.createPageRoute();
      expect(route, isA<PageRouteBuilder>());
    });
  });

  group('FlowsPage Navigation', () {
    testWidgets('FlowsMaterialApp with FlowsPage navigates', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowsPage(
              name: '/detail',
              page: () => const DetailPage(),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      expect(find.text('Home Page'), findsOneWidget);
      expect(find.text('Detail Page'), findsNothing);

      // Navigate to detail
      await tester.tap(find.byKey(const Key('navigateButton')));
      await tester.pumpAndSettle();

      expect(find.text('Detail Page'), findsOneWidget);
    });

    testWidgets('Flows.back returns to previous page', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowsPage(
              name: '/detail',
              page: () => const DetailPage(),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      // Navigate to detail
      await tester.tap(find.byKey(const Key('navigateButton')));
      await tester.pumpAndSettle();
      expect(find.text('Detail Page'), findsOneWidget);

      // Go back
      await tester.tap(find.byKey(const Key('backButton')));
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
      expect(find.text('Detail Page'), findsNothing);
    });
  });

  group('FlowsPage Transitions', () {
    testWidgets('FlowsPage with fade transition builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/fade',
              page: () => const Scaffold(body: Text('Fade Page')),
              transition: TransitionType.fade,
            ),
          ],
          initialRoute: '/fade',
        ),
      );

      expect(find.text('Fade Page'), findsOneWidget);
    });

    testWidgets('FlowsPage with slideLeft transition builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/slideLeft',
              page: () => const Scaffold(body: Text('SlideLeft Page')),
              transition: TransitionType.slideLeft,
            ),
          ],
          initialRoute: '/slideLeft',
        ),
      );

      expect(find.text('SlideLeft Page'), findsOneWidget);
    });

    testWidgets('FlowsPage with zoom transition builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/zoom',
              page: () => const Scaffold(body: Text('Zoom Page')),
              transition: TransitionType.zoom,
            ),
          ],
          initialRoute: '/zoom',
        ),
      );

      expect(find.text('Zoom Page'), findsOneWidget);
    });
  });

  group('Flows Navigation Static Methods', () {
    testWidgets('Flows.toNamed navigates', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowsPage(
              name: '/other',
              page: () => const Scaffold(body: Text('Other Page')),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      Flows.toNamed('/other');
      await tester.pumpAndSettle();

      expect(find.text('Other Page'), findsOneWidget);
    });

    testWidgets('Flows.back closes current route', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowsPage(
              name: '/detail',
              page: () => const DetailPage(),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      // Navigate first
      await tester.tap(find.byKey(const Key('navigateButton')));
      await tester.pumpAndSettle();

      // Then go back
      Flows.back();
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('Flows.to with page builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowsMaterialApp(
          pages: [
            FlowsPage(
              name: '/home',
              page: () => const Scaffold(body: Text('Root')),
            ),
            FlowsPage(
              name: '/new',
              page: () => const Scaffold(body: Text('New Page')),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      // Push a new page
      Flows.toNamed('/new');
      await tester.pumpAndSettle();

      expect(find.text('New Page'), findsOneWidget);
    });
  });
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Home Page'),
          ElevatedButton(
            key: const Key('navigateButton'),
            onPressed: () => Flows.toNamed('/detail'),
            child: const Text('Go to Detail'),
          ),
        ],
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Detail Page'),
          ElevatedButton(
            key: const Key('backButton'),
            onPressed: () => Flows.back(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
