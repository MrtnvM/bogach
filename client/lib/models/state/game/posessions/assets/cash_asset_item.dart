library cash_asset_item;

import 'package:built_value/built_value.dart';

part 'cash_asset_item.g.dart';

abstract class CashAssetItem
    implements Built<CashAssetItem, CashAssetItemBuilder> {
  factory CashAssetItem([void Function(CashAssetItemBuilder b) updates]) =
      _$CashAssetItem;

  CashAssetItem._();

  String get name;
  double get value;
}
