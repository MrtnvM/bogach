// GENERATED CODE - DO NOT MODIFY BY HAND

part of cash_asset_item;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CashAssetItem extends CashAssetItem {
  @override
  final String name;
  @override
  final int value;

  factory _$CashAssetItem([void Function(CashAssetItemBuilder) updates]) =>
      (new CashAssetItemBuilder()..update(updates)).build();

  _$CashAssetItem._({this.name, this.value}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('CashAssetItem', 'name');
    }
    if (value == null) {
      throw new BuiltValueNullFieldError('CashAssetItem', 'value');
    }
  }

  @override
  CashAssetItem rebuild(void Function(CashAssetItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CashAssetItemBuilder toBuilder() => new CashAssetItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CashAssetItem && name == other.name && value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CashAssetItem')
          ..add('name', name)
          ..add('value', value))
        .toString();
  }
}

class CashAssetItemBuilder
    implements Builder<CashAssetItem, CashAssetItemBuilder> {
  _$CashAssetItem _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _value;
  int get value => _$this._value;
  set value(int value) => _$this._value = value;

  CashAssetItemBuilder();

  CashAssetItemBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CashAssetItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CashAssetItem;
  }

  @override
  void update(void Function(CashAssetItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CashAssetItem build() {
    final _$result = _$v ?? new _$CashAssetItem._(name: name, value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
