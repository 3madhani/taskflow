import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveStorage {
  const HiveStorage();

  Future<void> clear(String boxName) async {
    await _box(boxName).clear();
  }

  bool containsKey(String boxName, String key) {
    return _box(boxName).containsKey(key);
  }

  Future<void> delete(String boxName, String key) async {
    await _box(boxName).delete(key);
  }

  T? read<T>(String boxName, String key) {
    try {
      final value = _box(boxName).get(key);
      if (value == null) return null;
      return value as T;
    } catch (_) {
      return null;
    }
  }

  List<T> readAll<T>(String boxName) {
    return _box(boxName).values.cast<T>().toList();
  }

  Future<void> write<T>(String boxName, String key, T value) async {
    await _box(boxName).put(key, value);
  }

  Future<void> writeAll<T>(String boxName, Map<String, T> entries) async {
    await _box(boxName).putAll(entries);
  }

  Box _box(String boxName) => Hive.box(boxName);
}
