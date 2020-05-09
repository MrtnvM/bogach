// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realty_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RealtyAsset _$_$_RealtyAssetFromJson(Map<String, dynamic> json) {
  return _$_RealtyAsset(
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$AssetTypeEnumMap, json['type']),
    downPayment: (json['downPayment'] as num)?.toDouble(),
    cost: (json['cost'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_RealtyAssetToJson(_$_RealtyAsset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$AssetTypeEnumMap[instance.type],
      'downPayment': instance.downPayment,
      'cost': instance.cost,
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
