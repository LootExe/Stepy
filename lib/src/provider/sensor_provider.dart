import 'package:pedometer/pedometer.dart';

abstract class SensorProvider {
  Stream<int> getStepCountStream({
    SensorConfiguration configuration = const SensorConfiguration(),
  });
}
