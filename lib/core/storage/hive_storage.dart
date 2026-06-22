import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@singleton
class HiveStorage {
  const HiveStorage();

  Box<T> _box<T>(String boxName) => Hive.box<T>(boxName);

  T? read<T>(String boxName, String key) {
    try {
      return _box<T>(boxName).get(key);
    } catch (_) {
      return null;
    }
  }

  Future<void> write<T>(String boxName, String key, T value) async {
    await _box<T>(boxName).put(key, value);
  }

  Future<void> delete(String boxName, String key) async {
    await _box(boxName).delete(key);
  }

  Future<void> clear(String boxName) async {
    await _box(boxName).clear();
  }

  List<T> readAll<T>(String boxName) {
    return _box<T>(boxName).values.toList();
  }

  Future<void> writeAll<T>(String boxName, Map<String, T> entries) async {
    await _box<T>(boxName).putAll(entries);
  }

  bool containsKey(String boxName, String key) {
    return _box(boxName).containsKey(key);
  }
}
