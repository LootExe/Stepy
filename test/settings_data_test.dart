import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stepy/src/model/settings_data.dart';
import 'package:stepy/src/model/storage_data.dart';
import 'package:test/test.dart';

void main() {
  test('SettingsData should be encoded to json', () {
    final data = SettingsData()
      ..dailyStepGoal = 10000
      ..isFirstStart = false
      ..themeMode = ThemeMode.dark;

    final storage = StorageData<SettingsData>(data: data);
    final jsonString = json.encode(storage);

    expect(jsonString, isNotNull);
    expect(jsonString, isNotEmpty);
  });

  test('SettingsData should be decoded from json', () {
    final original = SettingsData()
      ..dailyStepGoal = 10000
      ..isFirstStart = false
      ..themeMode = ThemeMode.dark;

    const jsonString =
        '{"data": {"themeMode": "dark","isFirstStart": false,"dailyStepGoal": 10000}}';

    final jsonObject = json.decode(jsonString) as Map<String, dynamic>;
    final storage = StorageData<SettingsData>.fromJson(jsonObject);

    final result = storage.data?.compareTo(original);

    expect(storage, isNotNull);
    expect(storage.data, isNotNull);
    expect(result, true);
  });
}
