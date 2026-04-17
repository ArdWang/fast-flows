/// RxList - Reactive List
part of 'rx_types.dart';

/// A reactive List that notifies listeners when modified
class RxList<T> extends ValueNotifier<List<T>> implements RxInterface<List<T>> {
  RxList(super.initial);

  List<T> get value {
    flxTrack(this);
    return super.value;
  }

  @override
  String toString() => value.toString();

  /// Adds an element to the list
  void add(T element) {
    value.add(element);
    notifyListeners();
  }

  /// Adds all elements to the list
  void addAll(Iterable<T> iterable) {
    value.addAll(iterable);
    notifyListeners();
  }

  /// Removes an element from the list
  bool remove(T element) {
    final removed = value.remove(element);
    if (removed) notifyListeners();
    return removed;
  }

  /// Removes all elements from the list
  void clear() {
    value.clear();
    notifyListeners();
  }

  /// Removes an element at index
  T removeAt(int index) {
    final removed = value.removeAt(index);
    notifyListeners();
    return removed;
  }

  /// Updates element at index and notifies
  void operator []=(int index, T value) {
    this.value[index] = value;
    notifyListeners();
  }

  /// Gets element at index
  T operator [](int index) => value[index];

  /// The length of the list
  int get length => value.length;

  /// Update the length of the list
  set length(int newLength) {
    value.length = newLength;
    notifyListeners();
  }
}
