library insurance_asset_item;

import 'package:built_value/built_value.dart';

part 'insurance_asset_item.g.dart';

abstract class InsuranceAssetItem
    implements Built<InsuranceAssetItem, InsuranceAssetItemBuilder> {
  factory InsuranceAssetItem(
          [void Function(InsuranceAssetItemBuilder b) updates]) =
      _$InsuranceAssetItem;

  InsuranceAssetItem._();

  String get name;

  int get value;
}
