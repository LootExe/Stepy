import 'package:stepy/src/provider/preferences_storage.dart';
import 'package:stepy/src/provider/storage_provider.dart';
import 'package:test/test.dart';

void main() {
  const key = 'testKey';
  late StorageProvider<int> storage;

  setUp(() async {
    storage = PreferencesStorage<int>();
  });

  test('Should return null if key does not exist', () async {
    final result = await storage.read(key);

    expect(result, isNull);
  });

  test('Write should return true on successful write', () async {
    final result = await storage.write(key, 1234);

    expect(result, true);
  });

  test('Should return value if key exist', () async {
    await storage.write(key, 1234);
    final result = await storage.read(key);

    expect(result, isNotNull);
    expect(result, 1234);
  });

  test('Delete should return true if key does not exist', () async {
    final result = await storage.delete(key);

    expect(result, true);
  });

  test('Delete should return true if key got removed', () async {
    await storage.write(key, 1234);
    final result = await storage.delete(key);

    expect(result, true);
  });

  test('Clear should delete all data', () async {
    await storage.write(key, 1234);
    final result = await storage.clear();

    expect(result, true);
  });
}
