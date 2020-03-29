// GENERATED CODE - DO NOT MODIFY BY HAND

part of insurance_asset_item;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InsuranceAssetItem extends InsuranceAssetItem {
  @override
  final String name;
  @override
  final int value;

  factory _$InsuranceAssetItem(
          [void Function(InsuranceAssetItemBuilder) updates]) =>
      (new InsuranceAssetItemBuilder()..update(updates)).build();

  _$InsuranceAssetItem._({this.name, this.value}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('InsuranceAssetItem', 'name');
    }
    if (value == null) {
      throw new BuiltValueNullFieldError('InsuranceAssetItem', 'value');
    }
  }

  @override
  InsuranceAssetItem rebuild(
          void Function(InsuranceAssetItemBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InsuranceAssetItemBuilder toBuilder() =>
      new InsuranceAssetItemBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InsuranceAssetItem &&
        name == other.name &&
        value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('InsuranceAssetItem')
          ..add('name', name)
          ..add('value', value))
        .toString();
  }
}

class InsuranceAssetItemBuilder
    implements Builder<InsuranceAssetItem, InsuranceAssetItemBuilder> {
  _$InsuranceAssetItem _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _value;
  int get value => _$this._value;
  set value(int value) => _$this._value = value;

  InsuranceAssetItemBuilder();

  InsuranceAssetItemBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InsuranceAssetItem other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$InsuranceAssetItem;
  }

  @override
  void update(void Function(InsuranceAssetItemBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$InsuranceAssetItem build() {
    final _$result =
        _$v ?? new _$InsuranceAssetItem._(name: name, value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
