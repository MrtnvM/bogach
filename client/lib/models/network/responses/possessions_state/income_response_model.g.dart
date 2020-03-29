// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeResponseModel _$IncomeResponseModelFromJson(Map<String, dynamic> json) {
  return IncomeResponseModel(
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$IncomeTypeEnumMap, json['type']),
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$IncomeResponseModelToJson(
        IncomeResponseModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$IncomeTypeEnumMap[instance.type],
      'value': instance.value,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$IncomeTypeEnumMap = {
  IncomeType.business: 'business',
  IncomeType.salary: 'salary',
  IncomeType.investment: 'investment',
  IncomeType.realty: 'realty',
  IncomeType.other: 'other',
};
