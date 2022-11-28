import 'dart:convert';

import 'package:stepy/src/model/pedometer_data.dart';
import 'package:stepy/src/model/storage_data.dart';
import 'package:test/test.dart';

void main() {
  test('PedometerData should be encoded to json', () {
    final data = PedometerData()
      ..stepsDaily = 1234
      ..lastSensorReading = 9999
      ..lastSensorTimestamp = DateTime(2022, 11, 10, 19, 38, 22);

    final storage = StorageData<PedometerData>(data: data);
    final jsonString = json.encode(storage);

    expect(jsonString, isNotNull);
    expect(jsonString, isNotEmpty);
  });

  test('PedometerData should be decoded from json', () {
    final original = PedometerData()
      ..stepsDaily = 1234
      ..lastSensorReading = 9999
      ..lastSensorTimestamp = DateTime(2022, 11, 10, 19, 38, 22);

    const jsonString =
        '{"data":{"stepsDaily":1234,"lastSensorReading":9999,"lastSensorTimestamp":"2022-11-10T19:38:22.000"}}';

    final jsonObject = json.decode(jsonString) as Map<String, dynamic>;
    final storage = StorageData<PedometerData>.fromJson(jsonObject);

    final result = storage.data?.compareTo(original);

    expect(storage, isNotNull);
    expect(storage.data, isNotNull);
    expect(result, true);
  });
}
