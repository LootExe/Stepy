import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider {
  static Future<Set<String>> readKeys() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getKeys();
  }

  static Future<String> readEntry(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(key) ?? '';
  }

  static Future<bool> writeEntry(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(key, value);
  }

  static Future<bool> removeEntry(String key) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.remove(key);
  }

  static Future<bool> clearStorage() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.clear();
  }
}
