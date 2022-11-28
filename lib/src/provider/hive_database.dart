import 'package:hive_flutter/hive_flutter.dart';

import 'database_provider.dart';

class HiveDatabase<T extends HiveObject> implements DatabaseProvider<T> {
  HiveDatabase({required String boxName}) : _boxName = boxName;

  final String _boxName;
  Box<T>? _box;

  bool get isInitialized => _box?.isOpen ?? false;

  /// Open the hive box
  @override
  Future<bool> initialize() async {
    if (isInitialized) {
      return false;
    }

    _box = await Hive.openBox<T>(_boxName);
    return true;
  }

  /// Close the box if opened
  @override
  Future<void> close() async {
    await _box?.flush();
    await _box?.close();
    _box = null;
  }

  /// Creates a new entry in the database
  @override
  Future<bool> create(T entry) async {
    if (!isInitialized) {
      return false;
    }

    await _box!.add(entry);
    return true;
  }

  /// Read one entry with the specified [key]
  @override
  T? read(int key) {
    if (!isInitialized) {
      return null;
    }

    return _box!.get(key);
  }

  /// Read all entries from the box
  @override
  Iterable<T> readAll() {
    if (!isInitialized) {
      return [];
    }

    return _box!.values;
  }

  /// Clear all data of the box
  @override
  Future<void> clear() async => await _box?.clear();
}
