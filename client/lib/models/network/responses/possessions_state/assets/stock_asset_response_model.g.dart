// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_asset_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockAssetResponseModel _$StockAssetResponseModelFromJson(
    Map<String, dynamic> json) {
  return StockAssetResponseModel(
    count: json['count'] as int,
    name: json['name'] as String,
    purchasePrice: json['purchasePrice'] as int,
    total: json['total'] as int,
    type: _$enumDecodeNullable(_$AssetTypeEnumMap, json['type']) ??
        AssetType.other,
  );
}

Map<String, dynamic> _$StockAssetResponseModelToJson(
        StockAssetResponseModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'name': instance.name,
      'purchasePrice': instance.purchasePrice,
      'total': instance.total,
      'type': _$AssetTypeEnumMap[instance.type],
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
  AssetType.debenture: 'debenture',
  AssetType.insurance: 'insurance',
  AssetType.stocks: 'stocks',
  AssetType.realty: 'realty',
  AssetType.business: 'business',
  AssetType.cash: 'cash',
  AssetType.other: 'other',
};
