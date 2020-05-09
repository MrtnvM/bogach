import 'package:cash_flow/models/state/game/possession_state/assets/business/business_asset.dart';
import 'package:cash_flow/models/state/game/possession_state/assets/cash/cash_asset.dart';
import 'package:cash_flow/models/state/game/possession_state/assets/debenture/debenture_asset.dart';
import 'package:cash_flow/models/state/game/possession_state/assets/insurance/insurance_asset.dart';
import 'package:cash_flow/models/state/game/possession_state/assets/other/other_asset.dart';
import 'package:cash_flow/models/state/game/possession_state/assets/realty/realty_asset.dart';
import 'package:cash_flow/models/state/game/possession_state/assets/stock/stock_asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset.g.dart';

@JsonSerializable()
class Asset {
  Asset();

  factory Asset.fromJson(Map<String, dynamic> json) {
    final typeString = json['type'];
    final type = AssetType.values.firstWhere(
      (e) => e.toString() == 'AssetType.$typeString',
      orElse: () => null,
    );

    if (type == null) {
      return null;
    }

    switch (type) {
      case AssetType.debenture:
        return DebentureAsset.fromJson(json);

      case AssetType.insurance:
        return InsuranceAsset.fromJson(json);

      case AssetType.stock:
        return StockAsset.fromJson(json);

      case AssetType.realty:
        return RealtyAsset.fromJson(json);

      case AssetType.business:
        return BusinessAsset.fromJson(json);

      case AssetType.cash:
        return CashAsset.fromJson(json);

      case AssetType.other:
        return OtherAsset.fromJson(json);
    }

    return null;
  }

  String get name => null;
  AssetType get type => null;

  Map<String, dynamic> toJson() => {};
}

enum AssetType { insurance, debenture, stock, realty, business, cash, other }
