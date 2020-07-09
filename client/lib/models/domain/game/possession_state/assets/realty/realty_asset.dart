import 'package:freezed_annotation/freezed_annotation.dart';

import '../asset.dart';

part 'realty_asset.freezed.dart';
part 'realty_asset.g.dart';

@freezed
abstract class RealtyAsset with _$RealtyAsset implements Asset {
  factory RealtyAsset({
    @required String name,
    @required AssetType type,
    @required double buyPrice,
    @required double downPayment,
    @required double fairPrice,
    @required double passiveIncomePerMonth,
    @required double payback,
    @required double sellProbability,
    @required String id,
  }) = _RealtyAsset;

  factory RealtyAsset.fromJson(Map<String, dynamic> json) =>
      _$RealtyAssetFromJson(json);
}
