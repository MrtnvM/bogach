import 'package:freezed_annotation/freezed_annotation.dart';

import '../asset.dart';

part 'debenture_asset.freezed.dart';
part 'debenture_asset.g.dart';

@freezed
abstract class DebentureAsset with _$DebentureAsset implements Asset {
  factory DebentureAsset({
    @required String name,
    @required AssetType type,
    @required double averagePrice,
    @required double nominal,
    @required double profitabilityPercent,
    @required int count,
  }) = _DebentureAsset;

  factory DebentureAsset.fromJson(Map<String, dynamic> json) =>
      _$DebentureAssetFromJson(json);
}
