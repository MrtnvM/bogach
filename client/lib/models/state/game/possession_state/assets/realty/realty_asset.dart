import 'package:cash_flow/models/state/game/possession_state/assets/asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'realty_asset.freezed.dart';
part 'realty_asset.g.dart';

@freezed
abstract class RealtyAsset with _$RealtyAsset implements Asset {
  factory RealtyAsset({
    @required String name,
    @required AssetType type,
    @required double downPayment,
    @required double cost,
  }) = _RealtyAsset;

  factory RealtyAsset.fromJson(Map<String, dynamic> json) =>
      _$RealtyAssetFromJson(json);
}
