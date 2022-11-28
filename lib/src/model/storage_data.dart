import 'package:json_annotation/json_annotation.dart';

import 'pedometer_data.dart';
import 'settings_data.dart';

part 'storage_data.g.dart';

@JsonSerializable()
class StorageData<T> {
  StorageData({this.data});

  @JsonKey(name: 'data')
  @_Converter()
  final T? data;

  factory StorageData.fromJson(Map<String, dynamic> json) =>
      _$StorageDataFromJson<T>(json);

  Map<String, dynamic> toJson() => _$StorageDataToJson(this);
}

class _Converter<T> implements JsonConverter<T, Object?> {
  const _Converter();

  @override
  T fromJson(Object? json) {
    if (json is Map<String, dynamic> &&
        json.containsKey('themeMode') &&
        json.containsKey('dailyStepGoal')) {
      return SettingsData.fromJson(json) as T;
    } else if (json is Map<String, dynamic> &&
        json.containsKey('stepsDaily') &&
        json.containsKey('lastSensorReading')) {
      return PedometerData.fromJson(json) as T;
    }
    // This will only work if `json` is a native JSON type:
    //   num, String, bool, null, etc
    // *and* is assignable to `T`.
    return json as T;
  }

  // This will only work if `object` is a native JSON type:
  //   num, String, bool, null, etc
  // Or if it has a `toJson()` function`.
  @override
  Object? toJson(T object) => object;
}
