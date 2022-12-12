import 'package:pedometer/pedometer.dart';
import 'package:stepy/src/model/pedometer_data.dart';

import 'package:stepy/src/provider/preferences_storage.dart';
import 'package:stepy/src/provider/sensor_provider.dart';
import 'package:stepy/src/repository/pedometer_repository.dart';
import 'package:test/test.dart';

void main() {
  late PreferencesStorage<PedometerData> storage;
  late PedometerRepository repository;
  final sensorReadings = [1000, 1100, 1200];

  setUp(() async {
    storage = PreferencesStorage<PedometerData>();

    repository = PedometerRepository(
      storage: storage,
      sensor: MockPedometer(sensorReadings),
    );
  });

  tearDown(() async {
    await storage.clear();
  });

  test('Initialize should initialize the repository', () async {
    final result = await repository.initialize();

    expect(result, true);
  });

  test('Fetch should return sensorError if not initialized', () async {
    final result = await repository.fetch();

    expect(result, PedometerRepository.sensorError);
  });

  test('Fetch should return a positive value', () async {
    await storage.write(
        'pedometer',
        PedometerData()
          ..stepsDaily = 500
          ..lastSensorReading = 500);

    await repository.initialize();

    final result = await repository.fetch();

    expect(result, sensorReadings[0]);
  });

  test('GetStepCountStream should return sensorError if not initialized',
      () async {
    final result = await repository.stepCountStream.first
        .onError((error, stackTrace) => PedometerRepository.sensorError);

    expect(result, PedometerRepository.sensorError);
  });

  test('GetStepCountStream should return a positive value', () async {
    await storage.write(
        'pedometer',
        PedometerData()
          ..stepsDaily = 500
          ..lastSensorReading = 500);

    await repository.initialize();

    final result = await repository.stepCountStream.first
        .onError((error, stackTrace) => PedometerRepository.sensorError);

    expect(result, sensorReadings[0]);
  });

  test('stepsCurrentDay should return sensorError if not initialized', () {
    final result = repository.stepsCurrentDay;

    expect(result, PedometerRepository.sensorError);
  });

  test('stepsCurrentDay should return a positive value', () async {
    const stepsDaily = 500;

    await storage.write(
      'pedometer',
      PedometerData()
        ..stepsDaily = stepsDaily
        ..lastSensorReading = 500,
    );

    await repository.initialize();

    final result = repository.stepsCurrentDay;

    expect(result, stepsDaily);
  });

  test('stepsCurrentDay should return raw sensor reading after reboot',
      () async {
    final rawSensor = sensorReadings[0];
    await storage.write(
        'pedometer',
        PedometerData()
          ..stepsDaily = 0
          ..lastSensorReading = 1500);

    await repository.initialize();
    await repository.fetch();

    final result = repository.stepsCurrentDay;

    expect(result, rawSensor);
  });
  test('stepsCurrentDay should increase after sensor reading', () async {
    await storage.write(
      'pedometer',
      PedometerData()
        ..lastSensorReading = 500
        ..stepsDaily = 500,
    );

    await repository.initialize();
    await repository.fetch();

    final result = repository.stepsCurrentDay;

    expect(result, sensorReadings[0]);
  });

  test('lastSensorTimestamp is yesterday should return stepsCurrentDay = 0',
      () async {
    await storage.write(
      'pedometer',
      PedometerData()
        ..lastSensorReading = 500
        ..stepsDaily = 500
        ..lastSensorTimestamp =
            DateTime.now().subtract(const Duration(days: 1)),
    );

    await repository.initialize();
    await repository.fetch();

    final result = repository.stepsCurrentDay;

    expect(result, 0);
  });

  test(
      'lastSensorTimestamp is couple days ago should return stepsCurrentDay = 0',
      () async {
    await storage.write(
      'pedometer',
      PedometerData()
        ..lastSensorReading = 500
        ..stepsDaily = 500
        ..lastSensorTimestamp =
            DateTime.now().subtract(const Duration(days: 3)),
    );

    await repository.initialize();
    await repository.fetch();

    final result = repository.stepsCurrentDay;

    expect(result, 0);
  });
}

class MockPedometer implements SensorProvider {
  MockPedometer(this.values);

  final List<int> values;

  @override
  Stream<int> getStepCountStream() {
    return Stream<int>.periodic(const Duration(seconds: 1), (x) => values[x])
        .take(values.length);
  }

  @override
  Future<bool> unregister() async {
    return true;
  }

  @override
  Future<int> getStepCount() async {
    return 1000;
  }

  @override
  Future<bool> register(
      {SensorConfiguration configuration = const SensorConfiguration()}) async {
    return true;
  }
}
