import 'package:stepy/src/model/step_data.dart';
import 'package:stepy/src/provider/hive_database.dart';
import 'package:test/test.dart';
import 'package:hive/hive.dart';

import 'hive_utils.dart';

void main() {
  late HiveDatabase<StepData> database;

  setUp(() async {
    final tempDir = await getTempDir();
    Hive.init(tempDir.path);

    final adapter = StepDataAdapter();

    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }

    database = HiveDatabase(boxName: StepData.boxName);
    await database.initialize();
  });

  tearDown(() async => await Hive.deleteFromDisk());

  test('Database should be initialized and opened', () async {
    final result = database.isInitialized;

    expect(result, true);
  });

  test('Database should be closed', () async {
    await database.close();

    final result = database.isInitialized;

    expect(result, false);
  });

  test('Create() should add an entry', () async {
    final data = StepData()
      ..steps = 1234
      ..timestamp = DateTime(2022, 11, 10, 19, 38, 22);

    final result = await database.create(data);

    expect(result, true);
  });

  test('Calling create() after close should return false', () async {
    final data = StepData()
      ..steps = 1234
      ..timestamp = DateTime.now();
    await database.close();

    final result = await database.create(data);

    expect(result, false);
  });

  test('Read() should return an entry', () async {
    final data = StepData()..steps = 1234;

    await database.create(data);

    final result = database.read(0);
    final equal = result?.compareTo(data);

    expect(result, isNotNull);
    expect(equal, true);
  });

  test('ReadAll() should return all entries', () async {
    final data1 = StepData()
      ..steps = 1234
      ..timestamp = DateTime(2022, 11, 10, 19, 38, 22);
    final data2 = StepData()
      ..steps = 5678
      ..timestamp = DateTime(2021, 11, 10, 19, 38, 22);

    await database.create(data1);
    await database.create(data2);

    final result = database.readAll().toList(growable: false);

    expect(result, isNotEmpty);
    expect(result.length, 2);
    expect(result[0].steps, 1234);
    expect(result[1].steps, 5678);
  });

  test('Save() should update an entry', () async {
    final data = StepData()..steps = 1234;

    await database.create(data);

    data.steps = 9999;
    await data.save();

    final result = database.read(data.key);

    expect(result, isNotNull);
    expect(result?.steps, 9999);
  });

  test('Delete() should remove an entry', () async {
    final data = StepData()..steps = 1234;

    await database.create(data);
    await data.delete();

    final result = database.read(0);

    expect(result, isNull);
  });
}
