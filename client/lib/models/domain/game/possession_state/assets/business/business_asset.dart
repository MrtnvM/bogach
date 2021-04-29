import 'package:freezed_annotation/freezed_annotation.dart';

import '../asset.dart';

part 'business_asset.freezed.dart';
part 'business_asset.g.dart';

@freezed
class BusinessAsset with _$BusinessAsset implements Asset {
  factory BusinessAsset({
    required String name,
    required AssetType type,
    required double buyPrice,
    required double downPayment,
    required double fairPrice,
    required double passiveIncomePerMonth,
    required double payback,
    required double sellProbability,
    required String id,
  }) = _BusinessAsset;

  factory BusinessAsset.fromJson(Map<String, dynamic> json) =>
      _$BusinessAssetFromJson(json);
}
