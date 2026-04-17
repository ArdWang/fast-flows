/// RxList Tests
///
/// Tests for reactive list: RxList
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('RxList', () {
    test('RxList creates with initial value', () {
      final rxList = RxList<int>([1, 2, 3]);
      expect(rxList.value, equals([1, 2, 3]));
      expect(rxList.length, equals(3));
    });

    test('RxList creates empty', () {
      final rxList = RxList<int>([]);
      expect(rxList.value, isEmpty);
    });

    test('RxList add notifies listeners', () {
      int notifyCount = 0;
      final rxList = RxList<int>([]);
      rxList.addListener(() => notifyCount++);

      rxList.add(1);
      expect(notifyCount, equals(1));
      expect(rxList.length, equals(1));
      expect(rxList.value.first, equals(1));
    });

    test('RxList addAll notifies listeners once', () {
      int notifyCount = 0;
      final rxList = RxList<int>([]);
      rxList.addListener(() => notifyCount++);

      rxList.addAll([1, 2, 3]);
      expect(notifyCount, equals(1));
      expect(rxList.length, equals(3));
    });

    test('RxList remove notifies listeners', () {
      int notifyCount = 0;
      final rxList = RxList<int>([1, 2, 3]);
      rxList.addListener(() => notifyCount++);

      final result = rxList.remove(2);
      expect(result, isTrue);
      expect(notifyCount, equals(1));
      expect(rxList.length, equals(2));
    });

    test('RxList remove returns false for non-existent element', () {
      final rxList = RxList<int>([1, 2, 3]);
      final result = rxList.remove(99);
      expect(result, isFalse);
    });

    test('RxList removeAt notifies listeners', () {
      int notifyCount = 0;
      final rxList = RxList<int>([1, 2, 3]);
      rxList.addListener(() => notifyCount++);

      final removed = rxList.removeAt(1);
      expect(removed, equals(2));
      expect(notifyCount, equals(1));
      expect(rxList.length, equals(2));
    });

    test('RxList clear notifies listeners', () {
      int notifyCount = 0;
      final rxList = RxList<int>([1, 2, 3]);
      rxList.addListener(() => notifyCount++);

      rxList.clear();
      expect(notifyCount, equals(1));
      expect(rxList.length, equals(0));
    });

    test('RxList operator [] access', () {
      final rxList = RxList<int>([10, 20, 30]);
      expect(rxList[0], equals(10));
      expect(rxList[1], equals(20));
      expect(rxList[2], equals(30));
    });

    test('RxList operator []= update notifies listeners', () {
      int notifyCount = 0;
      final rxList = RxList<int>([1, 2, 3]);
      rxList.addListener(() => notifyCount++);

      rxList[1] = 99;
      expect(notifyCount, equals(1));
      expect(rxList[1], equals(99));
    });

    test('RxList length setter', () {
      final rxList = RxList<int>([1, 2, 3, 4, 5]);
      rxList.length = 3;
      expect(rxList.length, equals(3));
      expect(rxList.value, equals([1, 2, 3]));
    });

    test('RxList extension on List', () {
      final rxList = [1, 2, 3].obs;
      expect(rxList, isA<Rx<List<int>>>());
      expect(rxList.value, equals([1, 2, 3]));
    });

    test('RxList value getter tracks with flx', () {
      final rxList = RxList<int>([1, 2, 3]);
      // Accessing value should work
      expect(rxList.value.length, equals(3));
    });

    test('RxList toString returns value', () {
      final rxList = RxList<int>([1, 2, 3]);
      expect(rxList.toString(), equals('[1, 2, 3]'));
    });
  });
}
