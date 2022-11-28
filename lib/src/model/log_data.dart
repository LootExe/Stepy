import 'package:hive/hive.dart';

part 'log_data.g.dart';

@HiveType(typeId: 1)
class LogData extends HiveObject {
  static const boxName = 'logData';

  @HiveField(0)
  String message = '';

  @HiveField(1)
  DateTime timestamp = DateTime.now();

  bool compareTo(LogData other) {
    return message == other.message && timestamp == other.timestamp;
  }
}
