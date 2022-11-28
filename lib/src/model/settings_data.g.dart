// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsData _$SettingsDataFromJson(Map<String, dynamic> json) => SettingsData()
  ..themeMode = $enumDecode(_$ThemeModeEnumMap, json['themeMode'])
  ..isFirstStart = json['isFirstStart'] as bool
  ..dailyStepGoal = json['dailyStepGoal'] as int;

Map<String, dynamic> _$SettingsDataToJson(SettingsData instance) =>
    <String, dynamic>{
      'themeMode': _$ThemeModeEnumMap[instance.themeMode]!,
      'isFirstStart': instance.isFirstStart,
      'dailyStepGoal': instance.dailyStepGoal,
    };

const _$ThemeModeEnumMap = {
  ThemeMode.system: 'system',
  ThemeMode.light: 'light',
  ThemeMode.dark: 'dark',
};
