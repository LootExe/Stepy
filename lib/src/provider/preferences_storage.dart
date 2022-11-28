import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/storage_data.dart';
import 'storage_provider.dart';

class PreferencesStorage<T> implements StorageProvider<T> {
  @override
  Future<T?> read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(key);

    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    try {
      final jsonObject = json.decode(jsonString) as Map<String, dynamic>;
      final storage = StorageData<T>.fromJson(jsonObject);
      return storage.data;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> write(String key, T data) async {
    try {
      final jsonString = json.encode(StorageData<T>(data: data));
      final prefs = await SharedPreferences.getInstance();

      return await prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> delete(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }

  @override
  Future<bool> clear() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
