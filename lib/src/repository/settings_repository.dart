import 'dart:convert';

import '../model/settings_data.dart';
import '../provider/storage_provider.dart';

class SettingsRepository {
  static const String _storageKey = 'settings';

  var settings = SettingsData();

  Future<bool> readSettings() async {
    final string = await StorageProvider.readEntry(_storageKey);

    if (string.isEmpty) {
      return false;
    }

    try {
      final data = jsonDecode(string) as Map<String, dynamic>;
      settings = SettingsData.fromJson(data);
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> writeSettings() async {
    final json = jsonEncode(settings);
    return await StorageProvider.writeEntry(_storageKey, json);
  }
}
