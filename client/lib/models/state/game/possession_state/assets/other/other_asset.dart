import 'package:cash_flow/models/state/game/possession_state/assets/asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'other_asset.freezed.dart';
part 'other_asset.g.dart';

@freezed
abstract class OtherAsset with _$OtherAsset implements Asset {
  factory OtherAsset({
    @required String name,
    @required AssetType type,
    @required double downPayment,
    @required double value,
  }) = _OtherAsset;

  factory OtherAsset.fromJson(Map<String, dynamic> json) =>
      _$OtherAssetFromJson(json);
}
