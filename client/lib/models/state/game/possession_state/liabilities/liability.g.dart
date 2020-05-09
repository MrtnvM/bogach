// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liability.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Liability _$_$_LiabilityFromJson(Map<String, dynamic> json) {
  return _$_Liability(
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$LiabilityTypeEnumMap, json['type']),
    monthlyPayment: (json['monthlyPayment'] as num)?.toDouble(),
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_LiabilityToJson(_$_Liability instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$LiabilityTypeEnumMap[instance.type],
      'monthlyPayment': instance.monthlyPayment,
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

const _$LiabilityTypeEnumMap = {
  LiabilityType.mortgage: 'mortgage',
  LiabilityType.businessCredit: 'business_credit',
  LiabilityType.other: 'other',
};
