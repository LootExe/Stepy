import 'dart:async';
import 'dart:convert';

import 'package:pedometer/pedometer.dart';

import '../extensions.dart';
import '../model/pedometer_data.dart';
import '../provider/storage_provider.dart';

/// Keeps track of current pedometer data
class PedometerRepository {
  static const String _storageKey = 'pedometer';

  var data = PedometerData();
  StreamSubscription<int>? _pedometer;

  /// Read [PedometerData] from the data provider
  Future<bool> readData() async {
    final jsonString = await StorageProvider.readEntry(_storageKey);

    if (jsonString.isEmpty) {
      return false;
    }

    try {
      final jsonObject = jsonDecode(jsonString) as Map<String, dynamic>;
      data = PedometerData.fromJson(jsonObject);
    } catch (e) {
      return false;
    }

    return true;
  }

  /// Saves [PedometerData] to the data provider
  Future<bool> writeData() async {
    final json = jsonEncode(data);
    return await StorageProvider.writeEntry(_storageKey, json);
  }

  /// Listen to the pedometer sensor data stream
  Future<void> listen({
    required void Function(int steps) onData,
    required void Function(String errror) onError,
  }) async {
    await cancel();

    const config = SensorConfiguration(samplingRate: SamplingRate.ui);

    _pedometer = Pedometer.getStepCountStream(configuration: config).listen(
      (event) => onData(_processRawSteps(event)),
      onError: (error) => onError(error.toString()),
      cancelOnError: true,
    );
  }

  /// Cancels the pedometer stream
  Future<void> cancel() async {
    await _pedometer?.cancel();
  }

  /// Returns the steps taken since the last sensor reading
  Future<int> get newSteps async {
    final sensorReading = await Pedometer.getStepCountStream()
        .first
        .onError((error, stackTrace) => data.lastSensorReading);

    return _processRawSteps(sensorReading);
  }

  int _processRawSteps(int rawSteps) {
    if (rawSteps == data.lastSensorReading) {
      return rawSteps;
    }

    int steps = 0;

    if (rawSteps < data.lastSensorReading) {
      // Device might have been rebooted
      steps = rawSteps;
    } else if (data.lastSensorReading > 0) {
      steps = rawSteps - data.lastSensorReading;
    }

    if (data.lastSensorTimestamp.isPastDay) {
      // Start new counting
      data.stepsToday = steps;
    } else {
      data.stepsToday += steps;
    }

    data.lastSensorReading = rawSteps;
    data.lastSensorTimestamp = DateTime.now();

    return steps;
  }
}
