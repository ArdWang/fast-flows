/// Flx Widget Tests
///
/// Tests for Flx and FlxValue reactive widgets
library;

import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('Flx Widget', () {
    testWidgets('Flx builds with initial value', (WidgetTester tester) async {
      final rxString = RxString('initial');

      await tester.pumpWidget(
        MaterialApp(
          home: Flx(() => Text(rxString.value)),
        ),
      );

      expect(find.text('initial'), findsOneWidget);
    });

    testWidgets('Flx rebuilds when value changes', (WidgetTester tester) async {
      final rxString = RxString('initial');

      await tester.pumpWidget(
        MaterialApp(
          home: Flx(() => Text(rxString.value)),
        ),
      );

      expect(find.text('initial'), findsOneWidget);

      rxString.value = 'updated';
      await tester.pump();

      expect(find.text('updated'), findsOneWidget);
      expect(find.text('initial'), findsNothing);
    });

    testWidgets('Flx rebuilds multiple times', (WidgetTester tester) async {
      final rxInt = RxInt(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Flx(() => Text('Count: ${rxInt.value}')),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      rxInt.increment();
      await tester.pump();
      expect(find.text('Count: 1'), findsOneWidget);

      rxInt.increment();
      await tester.pump();
      expect(find.text('Count: 2'), findsOneWidget);

      rxInt.increment();
      await tester.pump();
      expect(find.text('Count: 3'), findsOneWidget);
    });

    testWidgets('Flx with RxList rebuilds on add', (WidgetTester tester) async {
      final rxList = RxList<String>([]);

      await tester.pumpWidget(
        MaterialApp(
          home: Flx(() {
            return Column(
              children: rxList.value.map((item) => Text(item)).toList(),
            );
          }),
        ),
      );

      expect(find.textContaining(''), findsNothing);

      rxList.add('Item 1');
      await tester.pump();
      expect(find.text('Item 1'), findsOneWidget);

      rxList.add('Item 2');
      await tester.pump();
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('Flx with RxList rebuilds on remove', (WidgetTester tester) async {
      final rxList = RxList<String>(['A', 'B', 'C']);

      await tester.pumpWidget(
        MaterialApp(
          home: Flx(() {
            return Column(
              children: rxList.value.map((item) => Text(item)).toList(),
            );
          }),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);

      rxList.remove('B');
      await tester.pump();
      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsNothing);
      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('Flx with RxMap rebuilds on update', (WidgetTester tester) async {
      final rxMap = RxMap<String, int>({'score': 100});

      await tester.pumpWidget(
        MaterialApp(
          home: Flx(() => Text('Score: ${rxMap['score']}')),
        ),
      );

      expect(find.text('Score: 100'), findsOneWidget);

      rxMap['score'] = 200;
      await tester.pump();
      expect(find.text('Score: 200'), findsOneWidget);
    });

    testWidgets('Flx with RxBool toggle', (WidgetTester tester) async {
      final rxBool = RxBool(false);

      await tester.pumpWidget(
        MaterialApp(
          home: Flx(() => Text(rxBool.value ? 'ON' : 'OFF')),
        ),
      );

      expect(find.text('OFF'), findsOneWidget);

      rxBool.toggle();
      await tester.pump();
      expect(find.text('ON'), findsOneWidget);

      rxBool.toggle();
      await tester.pump();
      expect(find.text('OFF'), findsOneWidget);
    });

    testWidgets('Multiple Flx widgets update independently', (WidgetTester tester) async {
      final rx1 = RxInt(0);
      final rx2 = RxInt(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              Flx(() => Text('A: ${rx1.value}')),
              Flx(() => Text('B: ${rx2.value}')),
            ],
          ),
        ),
      );

      expect(find.text('A: 0'), findsOneWidget);
      expect(find.text('B: 0'), findsOneWidget);

      rx1.increment();
      await tester.pump();
      expect(find.text('A: 1'), findsOneWidget);
      expect(find.text('B: 0'), findsOneWidget);

      rx2.increment();
      await tester.pump();
      expect(find.text('A: 1'), findsOneWidget);
      expect(find.text('B: 1'), findsOneWidget);
    });
  });

  group('FlxValue Widget', () {
    testWidgets('FlxValue builds with initial value', (WidgetTester tester) async {
      final rxString = RxString('hello');

      await tester.pumpWidget(
        MaterialApp(
          home: FlxValue(
            rxString,
            (value) => Text(value),
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('FlxValue rebuilds when value changes', (WidgetTester tester) async {
      final rxString = RxString('first');

      await tester.pumpWidget(
        MaterialApp(
          home: FlxValue(
            rxString,
            (value) => Text(value),
          ),
        ),
      );

      expect(find.text('first'), findsOneWidget);

      rxString.value = 'second';
      await tester.pump();

      expect(find.text('second'), findsOneWidget);
      expect(find.text('first'), findsNothing);
    });

    testWidgets('FlxValue with RxInt', (WidgetTester tester) async {
      final rxInt = RxInt(42);

      await tester.pumpWidget(
        MaterialApp(
          home: FlxValue(
            rxInt,
            (value) => Text('Value: $value'),
          ),
        ),
      );

      expect(find.text('Value: 42'), findsOneWidget);

      rxInt.value = 100;
      await tester.pump();

      expect(find.text('Value: 100'), findsOneWidget);
    });

    testWidgets('FlxValue with nullable Rxn', (WidgetTester tester) async {
      final rxn = Rxn<String>(null);

      await tester.pumpWidget(
        MaterialApp(
          home: FlxValue(
            rxn,
            (value) => Text(value ?? 'NULL'),
          ),
        ),
      );

      expect(find.text('NULL'), findsOneWidget);

      rxn.value = 'loaded';
      await tester.pump();

      expect(find.text('loaded'), findsOneWidget);
    });

    testWidgets('FlxValue with RxList length', (WidgetTester tester) async {
      final rxList = RxList<int>([]);

      await tester.pumpWidget(
        MaterialApp(
          home: FlxValue(
            rxList,
            (list) => Text('Count: ${list.length}'),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      rxList.addAll([1, 2, 3]);
      await tester.pump();

      expect(find.text('Count: 3'), findsOneWidget);
    });

    testWidgets('Multiple FlxValue widgets update independently', (WidgetTester tester) async {
      final rx1 = RxInt(0);
      final rx2 = RxInt(0);

      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: [
              FlxValue(
                rx1,
                (v) => Text('X: $v'),
              ),
              FlxValue(
                rx2,
                (v) => Text('Y: $v'),
              ),
            ],
          ),
        ),
      );

      expect(find.text('X: 0'), findsOneWidget);
      expect(find.text('Y: 0'), findsOneWidget);

      rx1.value = 5;
      await tester.pump();
      expect(find.text('X: 5'), findsOneWidget);
      expect(find.text('Y: 0'), findsOneWidget);

      rx2.value = 10;
      await tester.pump();
      expect(find.text('X: 5'), findsOneWidget);
      expect(find.text('Y: 10'), findsOneWidget);
    });

    testWidgets('FlxValue with complex builder', (WidgetTester tester) async {
      final rxBool = RxBool(false);

      await tester.pumpWidget(
        MaterialApp(
          home: FlxValue(
            rxBool,
            (value) => value
                ? const Text('Active', style: TextStyle(color: Colors.green))
                : const Text('Inactive', style: TextStyle(color: Colors.red)),
          ),
        ),
      );

      expect(find.text('Inactive'), findsOneWidget);

      rxBool.value = true;
      await tester.pump();

      expect(find.text('Active'), findsOneWidget);
    });
  });

  group('FlxBuilder Widget', () {
    testWidgets('FlxBuilder builds with initial value', (WidgetTester tester) async {
      final rxString = RxString('hello');

      await tester.pumpWidget(
        MaterialApp(
          home: FlxBuilder(
            observable: rxString,
            builder: (value) => Text(value),
          ),
        ),
      );

      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets('FlxBuilder rebuilds when value changes', (WidgetTester tester) async {
      final rxString = RxString('first');

      await tester.pumpWidget(
        MaterialApp(
          home: FlxBuilder(
            observable: rxString,
            builder: (value) => Text(value),
          ),
        ),
      );

      expect(find.text('first'), findsOneWidget);

      rxString.value = 'second';
      await tester.pump();

      expect(find.text('second'), findsOneWidget);
    });
  });
}
