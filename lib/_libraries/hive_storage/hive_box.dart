import 'package:hive_flutter/hive_flutter.dart';

import 'hive_type_adapter.dart';

class HiveBox<T> implements Box<T> {
  HiveBox(this.hive, this.name, {this.adapter}) {
    if (adapter != null) hive.registerAdapter(adapter!);
  }

  final HiveInterface hive;
  final HiveTypeAdapter<T>? adapter;

  @override
  final String name;

  Box<T>? _box;
  Box<T> get box {
    if (_box == null) {
      throw Exception("Box $name is not initialized."
          " Box must be initialized before access.");
    }
    return _box!;
  }

  Future<void> init() async {
    if (_box != null) await close();
    await open();
  }

  Future<void> open() async {
    _box = await hive.openBox<T>(name);
  }

  @override
  Future<void> close() async {
    _box?.close();
  }

  @override
  Future<int> add(T value) => box.add(value);

  @override
  Future<Iterable<int>> addAll(Iterable<T> values) => box.addAll(values);

  @override
  Future<int> clear() => box.clear();

  @override
  Future<void> compact() => box.compact();

  @override
  bool containsKey(key) => box.containsKey(key);

  @override
  Future<void> delete(key) => box.delete(key);

  @override
  Future<void> deleteAll(Iterable keys) => box.deleteAll(keys);

  @override
  Future<void> deleteAt(int index) => box.deleteAt(index);

  @override
  Future<void> deleteFromDisk() => box.deleteFromDisk();

  @override
  Future<void> flush() => box.flush();

  @override
  T? get(key, {T? defaultValue}) => box.get(key, defaultValue: defaultValue);

  @override
  T? getAt(int index) => box.getAt(index);

  @override
  bool get isEmpty => box.isEmpty;

  @override
  bool get isNotEmpty => box.isNotEmpty;

  @override
  bool get isOpen => box.isOpen;

  @override
  keyAt(int index) => box.keyAt(index);

  @override
  Iterable get keys => box.keys;

  @override
  bool get lazy => box.lazy;

  @override
  int get length => box.length;

  @override
  String? get path => box.path;

  @override
  Future<void> put(key, T value) => box.put(key, value);

  @override
  Future<void> putAll(Map<dynamic, T> entries) => box.putAll(entries);

  @override
  Future<void> putAt(int index, T value) => box.putAt(index, value);

  @override
  Map<dynamic, T> toMap() => box.toMap();

  @override
  Iterable<T> get values => box.values;

  @override
  Iterable<T> valuesBetween({startKey, endKey}) =>
      box.valuesBetween(startKey: startKey, endKey: endKey);

  @override
  Stream<BoxEvent> watch({key}) => box.watch(key: key);
}
