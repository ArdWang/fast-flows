/// Rx Types Tests
///
/// Tests for reactive types: Rx, Rxn, RxBool, RxInt, RxDouble, RxString
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fast_flows/flows.dart';

void main() {
  group('Rx<T>', () {
    test('Rx creates with initial value', () {
      final rx = Rx(10);
      expect(rx.value, equals(10));
    });

    test('Rx value setter notifies listeners', () {
      int notifyCount = 0;
      final rx = Rx(0);
      rx.addListener(() => notifyCount++);

      rx.value = 1;
      expect(notifyCount, equals(1));
      expect(rx.value, equals(1));
    });

    test('Rx update callback is called', () {
      final rx = RxInt(5);
      rx.update((val) => val! * 2);
      expect(rx.value, equals(10));
    });

    test('Rx trigger forces rebuild', () {
      final rx = Rx(0);
      // trigger just sets the value - same value should still update
      rx.trigger(5);
      expect(rx.value, equals(5));
    });

    test('Rx toString returns value', () {
      final rx = Rx(42);
      expect(rx.toString(), equals('42'));
    });

    test('Rx with object that has toJson', () {
      final rx = Rx(_TestModel(10));
      expect(rx.toJson(), equals(10));
    });
  });

  group('Rxn<T>', () {
    test('Rxn creates with nullable value', () {
      final rxn = Rxn<String>(null);
      expect(rxn.value, isNull);
    });

    test('Rxn can be assigned null', () {
      final rxn = Rxn<String>('initial');
      expect(rxn.value, equals('initial'));

      rxn.value = null;
      expect(rxn.value, isNull);
    });

    test('Rxn.value or operator works', () {
      final rxn = Rxn<String>(null);
      final result = rxn.value ?? 'default';
      expect(result, equals('default'));
    });
  });

  group('RxBool', () {
    test('RxBool creates with initial value', () {
      final rxBool = RxBool(true);
      expect(rxBool.value, isTrue);
    });

    test('RxBool toggle works', () {
      final rxBool = RxBool(true);
      rxBool.toggle();
      expect(rxBool.value, isFalse);
      rxBool.toggle();
      expect(rxBool.value, isTrue);
    });

    test('RxBool value setter works', () {
      final rxBool = RxBool(false);
      rxBool.value = true;
      expect(rxBool.value, isTrue);
    });

    test('RxBool extension on bool', () {
      final rxBool = true.obs;
      expect(rxBool, isA<RxBool>());
      expect(rxBool.value, isTrue);
    });

    test('RxBool isTrue and isFalse', () {
      final rxBool = RxBool(true);
      expect(rxBool.isTrue, isTrue);
      expect(rxBool.isFalse, isFalse);
    });

    test('RxBool operators', () {
      final rxBool = RxBool(true);
      expect(rxBool & true, isTrue);
      expect(rxBool & false, isFalse);
      expect(rxBool | false, isTrue);
      expect(rxBool ^ true, isFalse);
      expect(rxBool ^ false, isTrue);
    });

    test('RxnBool nullable operations', () {
      final rxnBool = RxnBool(null);
      expect(rxnBool.isTrue, isNull);
      expect(rxnBool.isFalse, isNull);

      rxnBool.value = true;
      expect(rxnBool & true, isTrue);
    });
  });

  group('RxInt', () {
    test('RxInt creates with initial value', () {
      final rxInt = RxInt(42);
      expect(rxInt.value, equals(42));
    });

    test('RxInt increment works', () {
      final rxInt = RxInt(0);
      rxInt.increment();
      expect(rxInt.value, equals(1));
      rxInt.increment();
      expect(rxInt.value, equals(2));
    });

    test('RxInt increment by value', () {
      final rxInt = RxInt(0);
      rxInt.increment(5);
      expect(rxInt.value, equals(5));
    });

    test('RxInt decrement works', () {
      final rxInt = RxInt(5);
      rxInt.decrement();
      expect(rxInt.value, equals(4));
    });

    test('RxInt decrement by value', () {
      final rxInt = RxInt(10);
      rxInt.decrement(3);
      expect(rxInt.value, equals(7));
    });

    test('RxInt value setter works', () {
      final rxInt = RxInt(0);
      rxInt.value = 100;
      expect(rxInt.value, equals(100));
    });

    test('RxInt extension on int', () {
      final rxInt = 10.obs;
      expect(rxInt, isA<RxInt>());
      expect(rxInt.value, equals(10));
    });

    test('RxInt operators', () {
      final rxInt = RxInt(10);
      expect(rxInt + 5, equals(15));
      expect(rxInt - 3, equals(7));
      expect(rxInt * 2, equals(20));
      expect(rxInt / 4, equals(2.5));
      expect(rxInt % 3, equals(1));
    });
  });

  group('RxDouble', () {
    test('RxDouble creates with initial value', () {
      final rxDouble = RxDouble(3.14);
      expect(rxDouble.value, equals(3.14));
    });

    test('RxDouble value setter works', () {
      final rxDouble = RxDouble(0.0);
      rxDouble.value = 2.5;
      expect(rxDouble.value, equals(2.5));
    });

    test('RxDouble extension on double', () {
      final rxDouble = 1.5.obs;
      expect(rxDouble, isA<RxDouble>());
      expect(rxDouble.value, equals(1.5));
    });

    test('RxDouble operators', () {
      final rxDouble = RxDouble(6.0);
      expect(rxDouble + 2.0, equals(8.0));
      expect(rxDouble - 2.0, equals(4.0));
      expect(rxDouble * 2.0, equals(12.0));
      expect(rxDouble / 2.0, equals(3.0));
    });
  });

  group('RxString', () {
    test('RxString creates with initial value', () {
      final rxString = RxString('hello');
      expect(rxString.value, equals('hello'));
    });

    test('RxString value setter works', () {
      final rxString = RxString('');
      rxString.value = 'world';
      expect(rxString.value, equals('world'));
    });

    test('RxString toString returns value', () {
      final rxString = RxString('test');
      expect(rxString.toString(), equals('test'));
    });

    test('RxString extension on String', () {
      final rxString = 'test'.obs;
      expect(rxString, isA<RxString>());
      expect(rxString.value, equals('test'));
    });
  });

  group('RxT extension on Object', () {
    test('RxT extension creates Rx<T>', () {
      final rx = 'hello'.obs;
      expect(rx, isA<Rx<String>>());
      expect(rx.value, equals('hello'));
    });
  });
}

class _TestModel {
  final int value;
  _TestModel(this.value);

  int toJson() => value;
}
