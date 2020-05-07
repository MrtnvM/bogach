import 'package:cash_flow/models/state/game/possession_state/assets/asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'insurance_asset.freezed.dart';
part 'insurance_asset.g.dart';

@freezed
abstract class InsuranceAsset with _$InsuranceAsset implements Asset {
  factory InsuranceAsset({
    @required String name,
    @required AssetType type,
    @required double downPayment,
    @required double value,
  }) = _InsuranceAsset;

  factory InsuranceAsset.fromJson(Map<String, dynamic> json) =>
      _$InsuranceAssetFromJson(json);
}
