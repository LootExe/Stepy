import 'package:hive/hive.dart';
import 'package:stepy/src/model/step_data.dart';
import 'package:stepy/src/provider/hive_database.dart';
import 'package:stepy/src/repository/history_repository.dart';
import 'package:test/test.dart';

import 'hive_utils.dart';

void main() {
  late HiveDatabase<StepData> database;
  late HistoryRepository repository;

  setUp(() async {
    database = await setupHive();
    repository = HistoryRepository(database: database);
    await repository.initialize();
  });

  tearDown(() async => await Hive.deleteFromDisk());

  test('Empty database should return empty history', () async {
    final result = repository.dailyHistory.isEmpty;

    expect(result, true);
  });

  group('dailyAverage tests', () {
    test('Empty database should return zero average steps', () async {
      final result = repository.dailyAverage;

      expect(result, isZero);
    });

    test('One entry should return same value', () async {
      await repository.add(StepData()..steps = 1000);

      final result = repository.dailyAverage;

      expect(result, 1000);
    });

    test('One entry with 0 steps should return 0', () async {
      await repository.add(StepData()..steps = 0);

      final result = repository.dailyAverage;

      expect(result, 0);
    });

    test('Two entries with 0 steps should return 0', () async {
      await repository.add(StepData()..steps = 0);
      await repository.add(StepData()..steps = 0);

      final result = repository.dailyAverage;

      expect(result, 0);
    });

    test('dailyAverage should return average value', () async {
      await repository.add(StepData()..steps = 1000);
      await repository.add(StepData()..steps = 1500);
      await repository.add(StepData()..steps = 2000);
      await repository.add(StepData()..steps = 2500);

      final result = repository.dailyAverage;

      expect(result, 1750);
    });
  });

  group('dailyRecord tests', () {
    test('Empty database should return zero record steps', () async {
      final result = repository.dailyRecord;

      expect(result, isZero);
    });

    test('dailyRecord should return highest value', () async {
      await repository.add(StepData()..steps = 1000);
      await repository.add(StepData()..steps = 2000);

      final result = repository.dailyRecord;

      expect(result, 2000);
    });

    test('Double entry should return one of the values', () async {
      await repository.add(StepData()..steps = 2000);
      await repository.add(StepData()..steps = 2000);

      final result = repository.dailyRecord;

      expect(result, 2000);
    });

    test('Zero steps entry should return zero', () async {
      await repository.add(StepData()..steps = 0);

      final result = repository.dailyRecord;

      expect(result, 0);
    });
  });

  group('dailyHistory tests', () {
    test('dailyHistory should return a list of same database length', () async {
      await repository.add(StepData()..steps = 1500);
      await repository.add(StepData()..steps = 2000);
      await repository.add(StepData()..steps = 2500);

      final list1 = database.readAll();
      final list2 = repository.dailyHistory;

      final result = list2.length == list1.length;

      expect(result, true);
    });
  });

  test('Close() should close the database provider', () async {
    await repository.close();
    final result = database.isInitialized;

    expect(result, false);
  });

  test('add() should add an entry', () async {
    final operationResult = await repository.add(
      StepData()
        ..steps = 1234
        ..timestamp = DateTime(2022, 11, 10, 19, 38, 22),
    );

    final valueResult = database.readAll().last;

    expect(operationResult, true);
    expect(valueResult.steps, 1234);
    expect(valueResult.timestamp, DateTime(2022, 11, 10, 19, 38, 22));
  });
}

Future<HiveDatabase<StepData>> setupHive() async {
  final tempDir = await getTempDir();
  Hive.init(tempDir.path);

  final adapter = StepDataAdapter();

  if (!Hive.isAdapterRegistered(adapter.typeId)) {
    Hive.registerAdapter(adapter);
  }

  final database = HiveDatabase<StepData>(boxName: StepData.boxName);
  return database;
}
