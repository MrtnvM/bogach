// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debenture_asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_DebentureAsset _$_$_DebentureAssetFromJson(Map<String, dynamic> json) {
  return _$_DebentureAsset(
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$AssetTypeEnumMap, json['type']),
    averagePrice: (json['averagePrice'] as num)?.toDouble(),
    nominal: (json['nominal'] as num)?.toDouble(),
    profitabilityPercent: (json['profitabilityPercent'] as num)?.toDouble(),
    count: json['count'] as int,
  );
}

Map<String, dynamic> _$_$_DebentureAssetToJson(_$_DebentureAsset instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': _$AssetTypeEnumMap[instance.type],
      'averagePrice': instance.averagePrice,
      'nominal': instance.nominal,
      'profitabilityPercent': instance.profitabilityPercent,
      'count': instance.count,
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
