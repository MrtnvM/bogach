library debenture_asset_item;

import 'package:built_value/built_value.dart';

part 'debenture_asset_item.g.dart';

abstract class DebentureAssetItem
    implements Built<DebentureAssetItem, DebentureAssetItemBuilder> {
  factory DebentureAssetItem(
          [void Function(DebentureAssetItemBuilder b) updates]) =
      _$DebentureAssetItem;

  DebentureAssetItem._();

  int get count;

  String get name;

  int get purchasePrice;

  int get total;
}
