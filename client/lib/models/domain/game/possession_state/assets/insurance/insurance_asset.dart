import 'package:freezed_annotation/freezed_annotation.dart';

import '../asset.dart';

part 'insurance_asset.freezed.dart';
part 'insurance_asset.g.dart';

@freezed
abstract class InsuranceAsset with _$InsuranceAsset implements Asset {
  factory InsuranceAsset({
    @required String name,
    @required AssetType type,
    @required int cost,
    @required int value,
    @required int duration,
    @required int fromMonth,
    @required InsuranceType insuranceType,
  }) = _InsuranceAsset;

  factory InsuranceAsset.fromJson(Map<String, dynamic> json) =>
      _$InsuranceAssetFromJson(json);
}

enum InsuranceType {
  @JsonValue('health')
  playersMove,
  @JsonValue('property')
  gameOver,
}
