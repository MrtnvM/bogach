library possession_asset;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/state/game/posessions/assets/business_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/debenture_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/insurance_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/other_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/realty_asset_item.dart';
import 'package:cash_flow/models/state/game/posessions/assets/stock_asset_item.dart';

part 'possession_asset.g.dart';

abstract class PossessionAsset
    implements Built<PossessionAsset, PossessionAssetBuilder> {
  factory PossessionAsset([void Function(PossessionAssetBuilder b) updates]) =
      _$PossessionAsset;

  PossessionAsset._();

  int get sum;

  int get cash;

  List<InsuranceAssetItem> get insurances;

  List<DebentureAssetItem> get debentures;

  List<StockAssetItem> get stocks;

  List<RealtyAssetItem> get realty;

  List<BusinessAssetItem> get businesses;

  List<OtherAssetItem> get other;
}
