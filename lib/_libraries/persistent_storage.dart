import 'package:shared_preferences/shared_preferences.dart';

class PersistentStorage {
  Future<PersistentStorage> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    return this;
  }

  late final SharedPreferences _sharedPreferences;

  Future<void> reload() => _sharedPreferences.reload();

  bool containsKey(String key) => _sharedPreferences.containsKey(key);

  dynamic get(String key) => _sharedPreferences.get(key);
  int? getInt(String key) => _sharedPreferences.getInt(key);
  double? getDouble(String key) => _sharedPreferences.getDouble(key);
  bool? getBool(String key) => _sharedPreferences.getBool(key);
  String? getString(String key) => _sharedPreferences.getString(key);
  List<String>? getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  Future<bool> setInt(String key, int value) =>
      _sharedPreferences.setInt(key, value);
  Future<bool> setDouble(String key, double value) =>
      _sharedPreferences.setDouble(key, value);
  Future<bool> setBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);
  Future<bool> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);
  Future<bool> setStringList(String key, List<String> value) =>
      _sharedPreferences.setStringList(key, value);

  Future<bool> remove(String key) => _sharedPreferences.remove(key);
  Future<bool> clearData() => _sharedPreferences.clear();

  T? fetchData<T>(String key) {
    debugAssertType<T>();
    return switch (T) {
      const (int) => getInt(key),
      const (double) => getDouble(key),
      const (bool) => getBool(key),
      const (String) => getString(key),
      const (List<String>) => getStringList(key),
      _ => null,
    } as T?;
  }

  Future<bool> storeData<T>(String key, T data) {
    debugAssertType<T>();
    return switch (data) {
      int() => setInt(key, data),
      double() => setDouble(key, data),
      bool() => setBool(key, data),
      String() => setString(key, data),
      List<String>() => setStringList(key, data),
      _ => Future.value(false),
    };
  }

  static void debugAssertType<T>() {
    assert(
      (T == int ||
          T == double ||
          T == bool ||
          T == String ||
          T == List<String>),
      'Type Not Supported',
    );
  }
}

class PersistentData<T> {
  PersistentData(
    PersistentStorage storage, {
    required this.key,
  }) : _storage = storage {
    PersistentStorage.debugAssertType();
  }

  final String key;
  final PersistentStorage _storage;

  T? get fetchData => _storage.fetchData<T>(key);
  Future<bool> storeData(T data) => _storage.storeData<T>(key, data);
  Future<bool> clearData() => _storage.remove(key);
}
