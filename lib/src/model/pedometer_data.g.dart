// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pedometer_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PedometerData _$PedometerDataFromJson(Map<String, dynamic> json) =>
    PedometerData()
      ..stepsDaily = json['stepsDaily'] as int
      ..lastSensorReading = json['lastSensorReading'] as int
      ..lastSensorTimestamp =
          DateTime.parse(json['lastSensorTimestamp'] as String);

Map<String, dynamic> _$PedometerDataToJson(PedometerData instance) =>
    <String, dynamic>{
      'stepsDaily': instance.stepsDaily,
      'lastSensorReading': instance.lastSensorReading,
      'lastSensorTimestamp': instance.lastSensorTimestamp.toIso8601String(),
    };
