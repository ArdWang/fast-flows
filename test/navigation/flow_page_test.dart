/// FlowPage Tests
///
/// Tests for FlowPage and navigation functionality
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('FlowPage', () {
    test('FlowPage creates with name and page builder', () {
      final flowPage = FlowPage(
        name: '/home',
        page: () => const Scaffold(body: Text('Home')),
      );

      expect(flowPage.name, equals('/home'));
      expect(flowPage.page, isNotNull);
      expect(flowPage.transition, equals(TransitionType.none));
    });

    test('FlowPage with fade transition', () {
      final flowPage = FlowPage(
        name: '/fade',
        page: () => const Scaffold(),
        transition: TransitionType.fade,
      );

      expect(flowPage.transition, equals(TransitionType.fade));
    });

    test('FlowPage with slideLeft transition', () {
      final flowPage = FlowPage(
        name: '/slideLeft',
        page: () => const Scaffold(),
        transition: TransitionType.slideLeft,
      );

      expect(flowPage.transition, equals(TransitionType.slideLeft));
    });

    test('FlowPage with slideRight transition', () {
      final flowPage = FlowPage(
        name: '/slideRight',
        page: () => const Scaffold(),
        transition: TransitionType.slideRight,
      );

      expect(flowPage.transition, equals(TransitionType.slideRight));
    });

    test('FlowPage with slideUp transition', () {
      final flowPage = FlowPage(
        name: '/slideUp',
        page: () => const Scaffold(),
        transition: TransitionType.slideUp,
      );

      expect(flowPage.transition, equals(TransitionType.slideUp));
    });

    test('FlowPage with slideDown transition', () {
      final flowPage = FlowPage(
        name: '/slideDown',
        page: () => const Scaffold(),
        transition: TransitionType.slideDown,
      );

      expect(flowPage.transition, equals(TransitionType.slideDown));
    });

    test('FlowPage with zoom transition', () {
      final flowPage = FlowPage(
        name: '/zoom',
        page: () => const Scaffold(),
        transition: TransitionType.zoom,
      );

      expect(flowPage.transition, equals(TransitionType.zoom));
    });

    test('FlowPage createRoute returns MaterialPageRoute', () {
      final flowPage = FlowPage(
        name: '/home',
        page: () => const Scaffold(body: Text('Home')),
      );

      final route = flowPage.createRoute();
      expect(route, isA<MaterialPageRoute>());
    });

    test('FlowPage createPageRoute returns PageRouteBuilder for fade', () {
      final flowPage = FlowPage(
        name: '/fade',
        page: () => const Scaffold(),
        transition: TransitionType.fade,
      );

      final route = flowPage.createPageRoute();
      expect(route, isA<PageRouteBuilder>());
    });
  });

  group('FlowPage Navigation', () {
    testWidgets('FlowMaterialApp with FlowPage navigates', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowPage(
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

    testWidgets('Flow.back returns to previous page', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowPage(
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

  group('FlowPage Transitions', () {
    testWidgets('FlowPage with fade transition builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
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

    testWidgets('FlowPage with slideLeft transition builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
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

    testWidgets('FlowPage with zoom transition builds', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
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

  group('Flow Navigation Static Methods', () {
    testWidgets('Flow.toNamed navigates', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowPage(
              name: '/other',
              page: () => const Scaffold(body: Text('Other Page')),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      Flow.toNamed('/other');
      await tester.pumpAndSettle();

      expect(find.text('Other Page'), findsOneWidget);
    });

    testWidgets('Flow.back closes current route', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
              name: '/home',
              page: () => const HomePage(),
            ),
            FlowPage(
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
      Flow.back();
      await tester.pumpAndSettle();

      expect(find.text('Home Page'), findsOneWidget);
    });

    testWidgets('Flow.to with page builder', (WidgetTester tester) async {
      await tester.pumpWidget(
        FlowMaterialApp(
          pages: [
            FlowPage(
              name: '/home',
              page: () => const Scaffold(body: Text('Root')),
            ),
            FlowPage(
              name: '/new',
              page: () => const Scaffold(body: Text('New Page')),
            ),
          ],
          initialRoute: '/home',
        ),
      );

      // Push a new page
      Flow.toNamed('/new');
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
            onPressed: () => Flow.toNamed('/detail'),
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
            onPressed: () => Flow.back(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}
