// GENERATED CODE - DO NOT MODIFY BY HAND

part of target_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TargetState extends TargetState {
  @override
  final int value;
  @override
  final int currentValue;
  @override
  final TargetType type;

  factory _$TargetState([void Function(TargetStateBuilder) updates]) =>
      (new TargetStateBuilder()..update(updates)).build();

  _$TargetState._({this.value, this.currentValue, this.type}) : super._() {
    if (value == null) {
      throw new BuiltValueNullFieldError('TargetState', 'value');
    }
    if (currentValue == null) {
      throw new BuiltValueNullFieldError('TargetState', 'currentValue');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('TargetState', 'type');
    }
  }

  @override
  TargetState rebuild(void Function(TargetStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TargetStateBuilder toBuilder() => new TargetStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TargetState &&
        value == other.value &&
        currentValue == other.currentValue &&
        type == other.type;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, value.hashCode), currentValue.hashCode), type.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TargetState')
          ..add('value', value)
          ..add('currentValue', currentValue)
          ..add('type', type))
        .toString();
  }
}

class TargetStateBuilder implements Builder<TargetState, TargetStateBuilder> {
  _$TargetState _$v;

  int _value;
  int get value => _$this._value;
  set value(int value) => _$this._value = value;

  int _currentValue;
  int get currentValue => _$this._currentValue;
  set currentValue(int currentValue) => _$this._currentValue = currentValue;

  TargetType _type;
  TargetType get type => _$this._type;
  set type(TargetType type) => _$this._type = type;

  TargetStateBuilder();

  TargetStateBuilder get _$this {
    if (_$v != null) {
      _value = _$v.value;
      _currentValue = _$v.currentValue;
      _type = _$v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TargetState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TargetState;
  }

  @override
  void update(void Function(TargetStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$TargetState build() {
    final _$result = _$v ??
        new _$TargetState._(
            value: value, currentValue: currentValue, type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
