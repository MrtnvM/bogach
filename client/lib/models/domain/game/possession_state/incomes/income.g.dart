// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Income _$_$_IncomeFromJson(Map<String, dynamic> json) {
  return _$_Income(
    name: json['name'] as String,
    value: (json['value'] as num)?.toDouble(),
    type: _$enumDecodeNullable(_$IncomeTypeEnumMap, json['type'],
        unknownValue: IncomeType.other),
  );
}

Map<String, dynamic> _$_$_IncomeToJson(_$_Income instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'type': _$IncomeTypeEnumMap[instance.type],
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
  IncomeType.salary: 'salary',
  IncomeType.realty: 'realty',
  IncomeType.investment: 'investment',
  IncomeType.business: 'business',
  IncomeType.other: 'other',
};
