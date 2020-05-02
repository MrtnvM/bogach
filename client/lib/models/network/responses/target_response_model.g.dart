// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TargetResponseModel _$TargetResponseModelFromJson(Map<String, dynamic> json) {
  return TargetResponseModel(
    name: json['name'] as String ?? '',
    type: _$enumDecodeNullable(_$TargetTypeEnumMap, json['type']) ??
        TargetType.cash,
    value: (json['value'] as num)?.toDouble() ?? 0,
  );
}

Map<String, dynamic> _$TargetResponseModelToJson(
        TargetResponseModel instance) =>
    <String, dynamic>{
      'name': instance.name,
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
