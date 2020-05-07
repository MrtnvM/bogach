import 'package:cash_flow/models/state/game/possession_state/assets/asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_asset.freezed.dart';
part 'stock_asset.g.dart';

@freezed
abstract class StockAsset with _$StockAsset implements Asset {
  factory StockAsset({
    @required String name,
    @required AssetType type,
    @required double fairPrice,
    @required double averagePrice,
    @required int countInPortfolio,
  }) = _StockAsset;

  factory StockAsset.fromJson(Map<String, dynamic> json) =>
      _$StockAssetFromJson(json);
}
