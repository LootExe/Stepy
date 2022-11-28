import 'package:hive/hive.dart';

part 'step_data.g.dart';

@HiveType(typeId: 0)
class StepData extends HiveObject {
  static const boxName = 'stepData';

  @HiveField(1)
  int steps = 0;

  @HiveField(2)
  DateTime timestamp = DateTime.now();

  bool compareTo(StepData other) {
    return steps == other.steps && timestamp == other.timestamp;
  }
}
