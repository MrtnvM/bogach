// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liability_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiabilityResponseModel _$LiabilityResponseModelFromJson(
    Map<String, dynamic> json) {
  return LiabilityResponseModel(
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$LiabilityTypeEnumMap, json['type']) ??
        LiabilityType.other,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$LiabilityResponseModelToJson(
        LiabilityResponseModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$LiabilityTypeEnumMap[instance.type],
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
