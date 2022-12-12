import 'package:pedometer/pedometer.dart';

import '../extensions.dart';
import '../model/pedometer_data.dart';

import '../provider/sensor_provider.dart';
import '../provider/storage_provider.dart';

class PedometerRepository {
  PedometerRepository({
    required StorageProvider<PedometerData> storage,
    required SensorProvider sensor,
  })  : _storage = storage,
        _sensor = sensor;

  static const String _storageKey = 'pedometer';
  static const int sensorError = -1;

  final StorageProvider<PedometerData> _storage;
  final SensorProvider _sensor;
  var _data = PedometerData();
  bool _isInitialized = false;

  /// Returns the steps taken the current day
  int get stepsCurrentDay => _isInitialized ? _data.stepsDaily : sensorError;

  /// Returns a stream that contains the current days step count
  Stream<int> get stepCountStream => _getStepCountStream();

  /// Initialize the repository
  Future<bool> initialize() async {
    final result = await _storage.read(_storageKey);

    if (result != null) {
      _data = result;
    }

    return _isInitialized = true;
  }

  Future<bool> registerSensor() async => await _sensor.register(
      configuration: const SensorConfiguration(samplingRate: SamplingRate.ui));

  Future<bool> unregisterSensor() async => await _sensor.unregister();

  /// Reads new data from the step sensor and updates step count values
  Future<int> fetch() async {
    if (!_isInitialized) {
      return -1;
    }

    final sensorReading = await _sensor.getStepCount();
    _updatePedometerData(sensorReading);
    await _storage.write(_storageKey, _data);

    return _data.stepsDaily;
  }

  Stream<int> _getStepCountStream() {
    if (!_isInitialized) {
      return Stream<int>.error('Repository not initialized');
    }

    return _sensor.getStepCountStream().asyncMap((sensorReading) async {
      _updatePedometerData(sensorReading);
      await _storage.write(_storageKey, _data);
      return _data.stepsDaily;
    });
  }

  void _updatePedometerData(int sensorReading) {
    int newSteps = 0;

    if (sensorReading < _data.lastSensorReading) {
      // Device might have been rebooted
      newSteps = sensorReading;
    } else if (_data.lastSensorReading > 0) {
      newSteps = sensorReading - _data.lastSensorReading;
    }

    if (_data.lastSensorTimestamp.isToday) {
      // Sum up current day
      _data.stepsDaily += newSteps;
    } else {
      // New day, reset to zero
      _data.stepsDaily = 0;
    }

    _data.lastSensorReading = sensorReading;
    _data.lastSensorTimestamp = DateTime.now();
  }
}
