import 'package:stepy/src/provider/preferences_storage.dart';
import 'package:stepy/src/repository/settings_repository.dart';
import 'package:test/test.dart';

void main() {
  late SettingsRepository repository;

  setUp(() => repository = SettingsRepository(storage: PreferencesStorage()));

  test('ReadSettings should return false if settings does not exist', () async {
    final result = await repository.readSettings();

    expect(result, false);
  });

  test('WriteSettings should return true after successful write', () async {
    final result = await repository.writeSettings();

    expect(result, true);
  });

  test('ReadSettings should return true after successful write', () async {
    await repository.writeSettings();
    final result = await repository.readSettings();

    expect(result, true);
  });

  test('Setting should change after successful write', () async {
    repository.settings.dailyStepGoal = 1234;
    await repository.writeSettings();

    repository.settings.dailyStepGoal = 5678;
    await repository.readSettings();

    expect(repository.settings.dailyStepGoal, 1234);
  });
}
