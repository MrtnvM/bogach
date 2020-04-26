// GENERATED CODE - DO NOT MODIFY BY HAND

part of debenture_asset_item;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DebentureAssetItem extends DebentureAssetItem {
  @override
  final int count;
  @override
  final String name;
  @override
  final int purchasePrice;
  @override
  final int total;

  factory _$DebentureAssetItem(
          [void Function(DebentureAssetItemBuilder) updates]) =>
      (new DebentureAssetItemBuilder()..update(updates)).build();

  _$DebentureAssetItem._(
      {this.count, this.name, this.purchasePrice, this.total})
      : super._() {
    if (count == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'count');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'name');
    }
    if (purchasePrice == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'purchasePrice');
    }
    if (total == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'total');
    }
  }

  @override
  DebentureAssetItem rebuild(
          void Function(DebentureAssetItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DebentureAssetItemBuilder toBuilder() =>
      new DebentureAssetItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DebentureAssetItem &&
        count == other.count &&
        name == other.name &&
        purchasePrice == other.purchasePrice &&
        total == other.total;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, count.hashCode), name.hashCode), purchasePrice.hashCode),
        total.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DebentureAssetItem')
          ..add('count', count)
          ..add('name', name)
          ..add('purchasePrice', purchasePrice)
          ..add('total', total))
        .toString();
  }
}

class DebentureAssetItemBuilder
    implements Builder<DebentureAssetItem, DebentureAssetItemBuilder> {
  _$DebentureAssetItem _$v;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _purchasePrice;
  int get purchasePrice => _$this._purchasePrice;
  set purchasePrice(int purchasePrice) => _$this._purchasePrice = purchasePrice;

  int _total;
  int get total => _$this._total;
  set total(int total) => _$this._total = total;

  DebentureAssetItemBuilder();

  DebentureAssetItemBuilder get _$this {
    if (_$v != null) {
      _count = _$v.count;
      _name = _$v.name;
      _purchasePrice = _$v.purchasePrice;
      _total = _$v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DebentureAssetItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$DebentureAssetItem;
  }

  @override
  void update(void Function(DebentureAssetItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$DebentureAssetItem build() {
    final _$result = _$v ??
        new _$DebentureAssetItem._(
            count: count,
            name: name,
            purchasePrice: purchasePrice,
            total: total);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
