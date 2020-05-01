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
  final int averagePrice;
  @override
  final int count;
  @override
  final double profitabilityPercent;

  factory _$DebentureAssetItem(
          [void Function(DebentureAssetItemBuilder) updates]) =>
      (new DebentureAssetItemBuilder()..update(updates)).build();

  _$DebentureAssetItem._(
      {this.name,
      this.nominal,
      this.averagePrice,
      this.count,
      this.profitabilityPercent})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'name');
    }
    if (nominal == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'nominal');
    }
    if (averagePrice == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'averagePrice');
    }
    if (count == null) {
      throw new BuiltValueNullFieldError('DebentureAssetItem', 'count');
    }
    if (profitabilityPercent == null) {
      throw new BuiltValueNullFieldError(
          'DebentureAssetItem', 'profitabilityPercent');
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
        averagePrice == other.averagePrice &&
        count == other.count &&
        profitabilityPercent == other.profitabilityPercent;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, name.hashCode), nominal.hashCode),
                averagePrice.hashCode),
            count.hashCode),
        profitabilityPercent.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('DebentureAssetItem')
          ..add('name', name)
          ..add('nominal', nominal)
          ..add('averagePrice', averagePrice)
          ..add('count', count)
          ..add('profitabilityPercent', profitabilityPercent))
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

  int _averagePrice;
  int get averagePrice => _$this._averagePrice;
  set averagePrice(int averagePrice) => _$this._averagePrice = averagePrice;

  int _count;
  int get count => _$this._count;
  set count(int count) => _$this._count = count;

  double _profitabilityPercent;
  double get profitabilityPercent => _$this._profitabilityPercent;
  set profitabilityPercent(double profitabilityPercent) =>
      _$this._profitabilityPercent = profitabilityPercent;

  DebentureAssetItemBuilder();

  DebentureAssetItemBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _nominal = _$v.nominal;
      _averagePrice = _$v.averagePrice;
      _count = _$v.count;
      _profitabilityPercent = _$v.profitabilityPercent;
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
            averagePrice: averagePrice,
            count: count,
            profitabilityPercent: profitabilityPercent);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
