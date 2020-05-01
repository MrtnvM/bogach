// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_asset_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessAssetResponseModel _$BusinessAssetResponseModelFromJson(
    Map<String, dynamic> json) {
  return BusinessAssetResponseModel(
    cost: json['cost'] as int,
    downPayment: json['downPayment'] as int,
    name: json['name'] as String,
    type: _$enumDecodeNullable(_$AssetTypeEnumMap, json['type']) ??
        AssetType.other,
  );
}

Map<String, dynamic> _$BusinessAssetResponseModelToJson(
        BusinessAssetResponseModel instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'downPayment': instance.downPayment,
      'name': instance.name,
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
  AssetType.stock: 'stock',
  AssetType.realty: 'realty',
  AssetType.business: 'business',
  AssetType.cash: 'cash',
  AssetType.other: 'other',
};
