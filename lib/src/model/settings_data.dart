import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings_data.g.dart';

@JsonSerializable()
class SettingsData {
  SettingsData();

  ThemeMode themeMode = ThemeMode.system;
  bool isFirstStart = true;
  int dailyStepGoal = 10000;

  bool get isEmpty {
    return themeMode == ThemeMode.system &&
        isFirstStart == true &&
        dailyStepGoal == 10000;
  }

  factory SettingsData.fromJson(Map<String, dynamic> json) =>
      _$SettingsDataFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsDataToJson(this);

  bool compareTo(SettingsData other) {
    return themeMode == other.themeMode &&
        isFirstStart == other.isFirstStart &&
        dailyStepGoal == other.dailyStepGoal;
  }
}
