import 'package:freezed_annotation/freezed_annotation.dart';

import 'business/business_asset.dart';
import 'cash/cash_asset.dart';
import 'debenture/debenture_asset.dart';
import 'insurance/insurance_asset.dart';
import 'other/other_asset.dart';
import 'realty/realty_asset.dart';
import 'stock/stock_asset.dart';

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
