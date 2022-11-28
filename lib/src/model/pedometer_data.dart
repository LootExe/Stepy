import 'package:json_annotation/json_annotation.dart';

part 'pedometer_data.g.dart';

@JsonSerializable()
class PedometerData {
  PedometerData();

  /// Total steps counted for the current day in local time
  int stepsDaily = 0;

  /// Last step value from the sensor
  int lastSensorReading = 0;

  /// Timestamp of the last sensor reading
  DateTime lastSensorTimestamp = DateTime.now();

  factory PedometerData.fromJson(Map<String, dynamic> json) =>
      _$PedometerDataFromJson(json);
  Map<String, dynamic> toJson() => _$PedometerDataToJson(this);

  bool compareTo(PedometerData other) {
    return stepsDaily == other.stepsDaily &&
        lastSensorReading == other.lastSensorReading &&
        lastSensorTimestamp == other.lastSensorTimestamp;
  }
}
