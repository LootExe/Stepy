import '../model/settings_data.dart';
import '../provider/storage_provider.dart';

class SettingsRepository {
  SettingsRepository({
    required StorageProvider<SettingsData> storage,
  }) : _storage = storage;

  static const String _storageKey = 'settings';

  final StorageProvider<SettingsData> _storage;
  var settings = SettingsData();

  Future<bool> readSettings() async {
    final result = await _storage.read(_storageKey);

    if (result == null) {
      return false;
    }

    settings = result;
    return true;
  }

  Future<bool> writeSettings() async =>
      await _storage.write(_storageKey, settings);
}
