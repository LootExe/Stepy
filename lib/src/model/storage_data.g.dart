// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StorageData<T> _$StorageDataFromJson<T>(Map<String, dynamic> json) =>
    StorageData<T>(
      data: _Converter<T?>().fromJson(json['data']),
    );

Map<String, dynamic> _$StorageDataToJson<T>(StorageData<T> instance) =>
    <String, dynamic>{
      'data': _$JsonConverterToJson<Object?, T>(
          instance.data, _Converter<T?>().toJson),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
