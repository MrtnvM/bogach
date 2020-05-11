import 'package:freezed_annotation/freezed_annotation.dart';

import '../asset.dart';

part 'cash_asset.freezed.dart';
part 'cash_asset.g.dart';

@freezed
abstract class CashAsset with _$CashAsset implements Asset {
  factory CashAsset({
    @required String name,
    @required AssetType type,
    @required double value,
  }) = _CashAsset;

  factory CashAsset.fromJson(Map<String, dynamic> json) =>
      _$CashAssetFromJson(json);
}
