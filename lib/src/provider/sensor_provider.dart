import 'package:pedometer/pedometer.dart';

abstract class SensorProvider {
  Future<bool> register({
    SensorConfiguration configuration = const SensorConfiguration(),
  });

  Future<bool> unregister();

  Future<int> getStepCount();

  Stream<int> getStepCountStream();
}
