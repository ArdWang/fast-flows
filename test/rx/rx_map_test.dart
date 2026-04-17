/// RxMap Tests
///
/// Tests for reactive map: RxMap
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('RxMap', () {
    test('RxMap creates with initial value', () {
      final rxMap = RxMap<String, int>({'a': 1, 'b': 2});
      expect(rxMap.value, equals({'a': 1, 'b': 2}));
      expect(rxMap.length, equals(2));
    });

    test('RxMap creates empty', () {
      final rxMap = RxMap<String, int>({});
      expect(rxMap.value, isEmpty);
    });

    test('RxMap addEntry notifies listeners', () {
      int notifyCount = 0;
      final rxMap = RxMap<String, int>({});
      rxMap.addListener(() => notifyCount++);

      rxMap.addEntry('key1', 100);
      expect(notifyCount, equals(1));
      expect(rxMap['key1'], equals(100));
    });

    test('RxMap operator []= notifies listeners', () {
      int notifyCount = 0;
      final rxMap = RxMap<String, int>({});
      rxMap.addListener(() => notifyCount++);

      rxMap['test'] = 42;
      expect(notifyCount, equals(1));
      expect(rxMap['test'], equals(42));
    });

    test('RxMap operator []= update existing key notifies listeners', () {
      int notifyCount = 0;
      final rxMap = RxMap<String, int>({'key': 1});
      rxMap.addListener(() => notifyCount++);

      rxMap['key'] = 99;
      expect(notifyCount, equals(1));
      expect(rxMap['key'], equals(99));
    });

    test('RxMap addAll notifies listeners once', () {
      int notifyCount = 0;
      final rxMap = RxMap<String, int>({});
      rxMap.addListener(() => notifyCount++);

      rxMap.addAll({'a': 1, 'b': 2, 'c': 3});
      expect(notifyCount, equals(1));
      expect(rxMap.length, equals(3));
    });

    test('RxMap remove notifies listeners', () {
      int notifyCount = 0;
      final rxMap = RxMap<String, int>({'a': 1, 'b': 2, 'c': 3});
      rxMap.addListener(() => notifyCount++);

      final removed = rxMap.remove('b');
      expect(removed, equals(2));
      expect(notifyCount, equals(1));
      expect(rxMap.length, equals(2));
      expect(rxMap.containsKey('b'), isFalse);
    });

    test('RxMap remove returns null for non-existent key', () {
      final rxMap = RxMap<String, int>({'a': 1});
      final removed = rxMap.remove('nonexistent');
      expect(removed, isNull);
    });

    test('RxMap clear notifies listeners', () {
      int notifyCount = 0;
      final rxMap = RxMap<String, int>({'a': 1, 'b': 2, 'c': 3});
      rxMap.addListener(() => notifyCount++);

      rxMap.clear();
      expect(notifyCount, equals(1));
      expect(rxMap.length, equals(0));
    });

    test('RxMap operator [] access', () {
      final rxMap = RxMap<String, int>({'x': 10, 'y': 20, 'z': 30});
      expect(rxMap['x'], equals(10));
      expect(rxMap['y'], equals(20));
      expect(rxMap['z'], equals(30));
    });

    test('RxMap containsKey', () {
      final rxMap = RxMap<String, int>({'key': 123});
      expect(rxMap.containsKey('key'), isTrue);
      expect(rxMap.containsKey('nonexistent'), isFalse);
    });

    test('RxMap containsValue', () {
      final rxMap = RxMap<String, int>({'a': 1, 'b': 2, 'c': 3});
      expect(rxMap.containsValue(2), isTrue);
      expect(rxMap.containsValue(99), isFalse);
      expect(rxMap.containsValue(null), isFalse);
    });

    test('RxMap keys and values', () {
      final rxMap = RxMap<String, int>({'a': 1, 'b': 2, 'c': 3});
      expect(rxMap.value.keys, contains('a'));
      expect(rxMap.value.keys, contains('b'));
      expect(rxMap.value.keys, contains('c'));
      expect(rxMap.value.values, contains(1));
      expect(rxMap.value.values, contains(2));
      expect(rxMap.value.values, contains(3));
    });

    test('RxMap toString returns value', () {
      final rxMap = RxMap<String, int>({'a': 1});
      expect(rxMap.toString(), equals('{a: 1}'));
    });
  });
}
