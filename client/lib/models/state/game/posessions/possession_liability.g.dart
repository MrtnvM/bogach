// GENERATED CODE - DO NOT MODIFY BY HAND

part of possession_liability;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PossessionLiability extends PossessionLiability {
  @override
  final String name;
  @override
  final LiabilityType type;
  @override
  final int value;

  factory _$PossessionLiability(
          [void Function(PossessionLiabilityBuilder) updates]) =>
      (new PossessionLiabilityBuilder()..update(updates)).build();

  _$PossessionLiability._({this.name, this.type, this.value}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('PossessionLiability', 'name');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('PossessionLiability', 'type');
    }
    if (value == null) {
      throw new BuiltValueNullFieldError('PossessionLiability', 'value');
    }
  }

  @override
  PossessionLiability rebuild(
          void Function(PossessionLiabilityBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PossessionLiabilityBuilder toBuilder() =>
      new PossessionLiabilityBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PossessionLiability &&
        name == other.name &&
        type == other.type &&
        value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc($jc($jc(0, name.hashCode), type.hashCode), value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PossessionLiability')
          ..add('name', name)
          ..add('type', type)
          ..add('value', value))
        .toString();
  }
}

class PossessionLiabilityBuilder
    implements Builder<PossessionLiability, PossessionLiabilityBuilder> {
  _$PossessionLiability _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  LiabilityType _type;
  LiabilityType get type => _$this._type;
  set type(LiabilityType type) => _$this._type = type;

  int _value;
  int get value => _$this._value;
  set value(int value) => _$this._value = value;

  PossessionLiabilityBuilder();

  PossessionLiabilityBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _type = _$v.type;
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PossessionLiability other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PossessionLiability;
  }

  @override
  void update(void Function(PossessionLiabilityBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PossessionLiability build() {
    final _$result = _$v ??
        new _$PossessionLiability._(name: name, type: type, value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
