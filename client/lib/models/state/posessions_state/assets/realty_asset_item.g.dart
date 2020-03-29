// GENERATED CODE - DO NOT MODIFY BY HAND

part of realty_asset_item;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RealtyAssetItem extends RealtyAssetItem {
  @override
  final int cost;
  @override
  final int downPayment;
  @override
  final String name;

  factory _$RealtyAssetItem([void Function(RealtyAssetItemBuilder) updates]) =>
      (new RealtyAssetItemBuilder()..update(updates)).build();

  _$RealtyAssetItem._({this.cost, this.downPayment, this.name}) : super._() {
    if (cost == null) {
      throw new BuiltValueNullFieldError('RealtyAssetItem', 'cost');
    }
    if (downPayment == null) {
      throw new BuiltValueNullFieldError('RealtyAssetItem', 'downPayment');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('RealtyAssetItem', 'name');
    }
  }

  @override
  RealtyAssetItem rebuild(void Function(RealtyAssetItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RealtyAssetItemBuilder toBuilder() =>
      new RealtyAssetItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RealtyAssetItem &&
        cost == other.cost &&
        downPayment == other.downPayment &&
        name == other.name;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, cost.hashCode), downPayment.hashCode), name.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RealtyAssetItem')
          ..add('cost', cost)
          ..add('downPayment', downPayment)
          ..add('name', name))
        .toString();
  }
}

class RealtyAssetItemBuilder
    implements Builder<RealtyAssetItem, RealtyAssetItemBuilder> {
  _$RealtyAssetItem _$v;

  int _cost;
  int get cost => _$this._cost;
  set cost(int cost) => _$this._cost = cost;

  int _downPayment;
  int get downPayment => _$this._downPayment;
  set downPayment(int downPayment) => _$this._downPayment = downPayment;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  RealtyAssetItemBuilder();

  RealtyAssetItemBuilder get _$this {
    if (_$v != null) {
      _cost = _$v.cost;
      _downPayment = _$v.downPayment;
      _name = _$v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RealtyAssetItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RealtyAssetItem;
  }

  @override
  void update(void Function(RealtyAssetItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RealtyAssetItem build() {
    final _$result = _$v ??
        new _$RealtyAssetItem._(
            cost: cost, downPayment: downPayment, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
