// GENERATED CODE - DO NOT MODIFY BY HAND

part of debenture_asset_item;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$DebentureAssetItem extends DebentureAssetItem {
  @override
  final String name;
  @override
  final int nominal;
  @override
  final int currentPrice;
  @override
  final int count;

  factory _$DebentureAssetItem(
          [void Function(DebentureAssetItemBuilder) updates]) =>
      (new DebentureAssetItemBuilder()..update(updates)).build();

  _$DebentureAssetItem._(
      {this.name, this.nominal, this.currentPrice, this.count})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'name');
    }
    if (nominal == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'nominal');
    }
    if (currentPrice == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'currentPrice');
    }
    if (count == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'count');
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
        name == other.name &&
        nominal == other.nominal &&
        currentPrice == other.currentPrice &&
        count == other.count;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, name.hashCode), nominal.hashCode),
            currentPrice.hashCode),
        count.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DebentureAssetItem')
          ..add('name', name)
          ..add('nominal', nominal)
          ..add('currentPrice', currentPrice)
          ..add('count', count))
        .toString();
  }
}

class DebentureAssetItemBuilder
    implements Builder<DebentureAssetItem, DebentureAssetItemBuilder> {
  _$DebentureAssetItem _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _nominal;
  int get nominal => _$this._nominal;
  set nominal(int nominal) => _$this._nominal = nominal;

  int _currentPrice;
  int get currentPrice => _$this._currentPrice;
  set currentPrice(int currentPrice) => _$this._currentPrice = currentPrice;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  DebentureAssetItemBuilder();

  DebentureAssetItemBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _nominal = _$v.nominal;
      _currentPrice = _$v.currentPrice;
      _count = _$v.count;
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
            name: name,
            nominal: nominal,
            currentPrice: currentPrice,
            count: count);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
