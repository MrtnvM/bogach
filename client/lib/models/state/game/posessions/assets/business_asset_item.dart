library business_asset_item;

import 'package:built_value/built_value.dart';

part 'business_asset_item.g.dart';

abstract class BusinessAssetItem
    implements Built<BusinessAssetItem, BusinessAssetItemBuilder> {
  factory BusinessAssetItem(
          [void Function(BusinessAssetItemBuilder b) updates]) =
      _$BusinessAssetItem;

  BusinessAssetItem._();

  int get cost;

  int get downPayment;

  String get name;
}
