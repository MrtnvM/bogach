// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Target _$_$_TargetFromJson(Map<String, dynamic> json) {
  return _$_Target(
    type: _$enumDecodeNullable(_$TargetTypeEnumMap, json['type']),
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_TargetToJson(_$_Target instance) => <String, dynamic>{
      'type': _$TargetTypeEnumMap[instance.type],
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

const _$TargetTypeEnumMap = {
  TargetType.cash: 'cash',
  TargetType.passiveIncome: 'passive_income',
};
