// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_InsuranceAsset _$_$_InsuranceAssetFromJson(Map<String, dynamic> json) {
  return _$_InsuranceAsset(
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$AssetTypeEnumMap, json['type']),
    downPayment: (json['downPayment'] as num)?.toDouble(),
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_InsuranceAssetToJson(_$_InsuranceAsset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$AssetTypeEnumMap[instance.type],
      'downPayment': instance.downPayment,
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

const _$AssetTypeEnumMap = {
  AssetType.insurance: 'insurance',
  AssetType.debenture: 'debenture',
  AssetType.stock: 'stock',
  AssetType.realty: 'realty',
  AssetType.business: 'business',
  AssetType.cash: 'cash',
  AssetType.other: 'other',
};
