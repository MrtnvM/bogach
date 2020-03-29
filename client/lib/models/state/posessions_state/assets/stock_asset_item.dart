library stock_asset_item;

import 'package:built_value/built_value.dart';

part 'stock_asset_item.g.dart';

abstract class StockAssetItem
    implements Built<StockAssetItem, StockAssetItemBuilder> {
  factory StockAssetItem([void Function(StockAssetItemBuilder b) updates]) =
      _$StockAssetItem;

  StockAssetItem._();

  int get count;

  String get name;

  int get itemPrice;

  int get total;
}
