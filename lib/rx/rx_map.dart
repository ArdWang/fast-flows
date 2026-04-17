/// RxMap - Reactive Map
part of 'rx_types.dart';

/// A reactive Map that notifies listeners when modified
class RxMap<K, V> extends ValueNotifier<Map<K, V>> implements RxInterface<Map<K, V>> {
  RxMap(super.initial);

  Map<K, V> get value {
    flxTrack(this);
    return super.value;
  }

  @override
  String toString() => value.toString();

  /// Adds an entry to the map
  void addEntry(K key, V value) {
    this.value[key] = value;
    notifyListeners();
  }

  /// Adds all entries to the map
  void addAll(Map<K, V> entries) {
    value.addAll(entries);
    notifyListeners();
  }

  /// Removes an entry from the map
  V? remove(K key) {
    final removed = value.remove(key);
    if (removed != null) notifyListeners();
    return removed;
  }

  /// Removes all entries from the map
  void clear() {
    value.clear();
    notifyListeners();
  }

  /// Updates entry at key and notifies
  void operator []=(K key, V value) {
    this.value[key] = value;
    notifyListeners();
  }

  /// Gets entry at key
  V? operator [](K key) => value[key];

  /// The length of the map
  int get length => value.length;

  /// Checks if map contains key
  bool containsKey(K key) => value.containsKey(key);

  /// Checks if map contains value
  bool containsValue(V? value) => value != null && this.value.containsValue(value);
}
