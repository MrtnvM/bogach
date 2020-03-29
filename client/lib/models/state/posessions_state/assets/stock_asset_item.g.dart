// GENERATED CODE - DO NOT MODIFY BY HAND

part of stock_asset_item;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StockAssetItem extends StockAssetItem {
  @override
  final int count;
  @override
  final String name;
  @override
  final int itemPrice;
  @override
  final int total;

  factory _$StockAssetItem([void Function(StockAssetItemBuilder) updates]) =>
      (new StockAssetItemBuilder()..update(updates)).build();

  _$StockAssetItem._({this.count, this.name, this.itemPrice, this.total})
      : super._() {
    if (count == null) {
      throw new BuiltValueNullFieldError('StockAssetItem', 'count');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('StockAssetItem', 'name');
    }
    if (itemPrice == null) {
      throw new BuiltValueNullFieldError('StockAssetItem', 'itemPrice');
    }
    if (total == null) {
      throw new BuiltValueNullFieldError('StockAssetItem', 'total');
    }
  }

  @override
  StockAssetItem rebuild(void Function(StockAssetItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StockAssetItemBuilder toBuilder() =>
      new StockAssetItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StockAssetItem &&
        count == other.count &&
        name == other.name &&
        itemPrice == other.itemPrice &&
        total == other.total;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, count.hashCode), name.hashCode), itemPrice.hashCode),
        total.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StockAssetItem')
          ..add('count', count)
          ..add('name', name)
          ..add('itemPrice', itemPrice)
          ..add('total', total))
        .toString();
  }
}

class StockAssetItemBuilder
    implements Builder<StockAssetItem, StockAssetItemBuilder> {
  _$StockAssetItem _$v;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _itemPrice;
  int get itemPrice => _$this._itemPrice;
  set itemPrice(int itemPrice) => _$this._itemPrice = itemPrice;

  int _total;
  int get total => _$this._total;
  set total(int total) => _$this._total = total;

  StockAssetItemBuilder();

  StockAssetItemBuilder get _$this {
    if (_$v != null) {
      _count = _$v.count;
      _name = _$v.name;
      _itemPrice = _$v.itemPrice;
      _total = _$v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StockAssetItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StockAssetItem;
  }

  @override
  void update(void Function(StockAssetItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StockAssetItem build() {
    final _$result = _$v ??
        new _$StockAssetItem._(
            count: count, name: name, itemPrice: itemPrice, total: total);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
