library realty_asset_item;

import 'package:built_value/built_value.dart';

part 'realty_asset_item.g.dart';

abstract class RealtyAssetItem
    implements Built<RealtyAssetItem, RealtyAssetItemBuilder> {
  factory RealtyAssetItem([void Function(RealtyAssetItemBuilder b) updates]) =
      _$RealtyAssetItem;

  RealtyAssetItem._();

  int get cost;

  int get downPayment;

  String get name;
}
