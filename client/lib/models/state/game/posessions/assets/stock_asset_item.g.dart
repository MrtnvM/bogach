// GENERATED CODE - DO NOT MODIFY BY HAND

part of stock_asset_item;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$StockAssetItem extends StockAssetItem {
  @override
  final String name;
  @override
  final double averagePrice;
  @override
  final int countInPortfolio;

  factory _$StockAssetItem([void Function(StockAssetItemBuilder) updates]) =>
      (new StockAssetItemBuilder()..update(updates)).build();

  _$StockAssetItem._({this.name, this.averagePrice, this.countInPortfolio})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('StockAssetItem', 'name');
    }
    if (averagePrice == null) {
      throw new BuiltValueNullFieldError('StockAssetItem', 'averagePrice');
    }
    if (countInPortfolio == null) {
      throw new BuiltValueNullFieldError('StockAssetItem', 'countInPortfolio');
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
        name == other.name &&
        averagePrice == other.averagePrice &&
        countInPortfolio == other.countInPortfolio;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, name.hashCode), averagePrice.hashCode),
        countInPortfolio.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StockAssetItem')
          ..add('name', name)
          ..add('averagePrice', averagePrice)
          ..add('countInPortfolio', countInPortfolio))
        .toString();
  }
}

class StockAssetItemBuilder
    implements Builder<StockAssetItem, StockAssetItemBuilder> {
  _$StockAssetItem _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  double _averagePrice;
  double get averagePrice => _$this._averagePrice;
  set averagePrice(double averagePrice) => _$this._averagePrice = averagePrice;

  int _countInPortfolio;
  int get countInPortfolio => _$this._countInPortfolio;
  set countInPortfolio(int countInPortfolio) =>
      _$this._countInPortfolio = countInPortfolio;

  StockAssetItemBuilder();

  StockAssetItemBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _averagePrice = _$v.averagePrice;
      _countInPortfolio = _$v.countInPortfolio;
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
            name: name,
            averagePrice: averagePrice,
            countInPortfolio: countInPortfolio);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
