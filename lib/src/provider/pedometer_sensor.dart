import 'package:pedometer/pedometer.dart';

import 'sensor_provider.dart';

class PedometerSensor implements SensorProvider {
  @override
  Future<bool> register({
    SensorConfiguration configuration = const SensorConfiguration(),
  }) async =>
      await Pedometer.registerSensor(configuration: configuration);

  @override
  Future<bool> unregister() async => await Pedometer.unregisterSensor();

  @override
  Stream<int> getStepCountStream() => Pedometer.getStepCountStream();

  @override
  Future<int> getStepCount() async => await Pedometer.getStepCount();
}
