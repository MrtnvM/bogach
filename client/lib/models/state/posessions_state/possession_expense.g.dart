// GENERATED CODE - DO NOT MODIFY BY HAND

part of possession_expense;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PossessionExpense extends PossessionExpense {
  @override
  final String name;
  @override
  final int value;

  factory _$PossessionExpense(
          [void Function(PossessionExpenseBuilder) updates]) =>
      (new PossessionExpenseBuilder()..update(updates)).build();

  _$PossessionExpense._({this.name, this.value}) : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('PossessionExpense', 'name');
    }
    if (value == null) {
      throw new BuiltValueNullFieldError('PossessionExpense', 'value');
    }
  }

  @override
  PossessionExpense rebuild(void Function(PossessionExpenseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PossessionExpenseBuilder toBuilder() =>
      new PossessionExpenseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PossessionExpense &&
        name == other.name &&
        value == other.value;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), value.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PossessionExpense')
          ..add('name', name)
          ..add('value', value))
        .toString();
  }
}

class PossessionExpenseBuilder
    implements Builder<PossessionExpense, PossessionExpenseBuilder> {
  _$PossessionExpense _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  int _value;
  int get value => _$this._value;
  set value(int value) => _$this._value = value;

  PossessionExpenseBuilder();

  PossessionExpenseBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _value = _$v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PossessionExpense other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PossessionExpense;
  }

  @override
  void update(void Function(PossessionExpenseBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PossessionExpense build() {
    final _$result = _$v ?? new _$PossessionExpense._(name: name, value: value);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
