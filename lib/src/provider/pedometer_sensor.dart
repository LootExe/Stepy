import 'package:pedometer/pedometer.dart';

import 'sensor_provider.dart';

class PedometerSensor implements SensorProvider {
  @override
  Stream<int> getStepCountStream({
    SensorConfiguration configuration = const SensorConfiguration(),
  }) =>
      Pedometer.getStepCountStream(configuration: configuration);
}
