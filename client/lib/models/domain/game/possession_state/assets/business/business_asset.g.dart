// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_BusinessAsset _$_$_BusinessAssetFromJson(Map<String, dynamic> json) {
  return _$_BusinessAsset(
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$AssetTypeEnumMap, json['type']),
    buyPrice: (json['buyPrice'] as num)?.toDouble(),
    downPayment: (json['downPayment'] as num)?.toDouble(),
    fairPrice: (json['fairPrice'] as num)?.toDouble(),
    passiveIncomePerMonth: (json['passiveIncomePerMonth'] as num)?.toDouble(),
    payback: (json['payback'] as num)?.toDouble(),
    sellProbability: (json['sellProbability'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_BusinessAssetToJson(_$_BusinessAsset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$AssetTypeEnumMap[instance.type],
      'buyPrice': instance.buyPrice,
      'downPayment': instance.downPayment,
      'fairPrice': instance.fairPrice,
      'passiveIncomePerMonth': instance.passiveIncomePerMonth,
      'payback': instance.payback,
      'sellProbability': instance.sellProbability,
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
