library other_asset_item;

import 'package:built_value/built_value.dart';

part 'other_asset_item.g.dart';

abstract class OtherAssetItem
    implements Built<OtherAssetItem, OtherAssetItemBuilder> {
  factory OtherAssetItem([void Function(OtherAssetItemBuilder b) updates]) =
      _$OtherAssetItem;

  OtherAssetItem._();

  int get cost;

  int get downPayment;

  String get name;
}
