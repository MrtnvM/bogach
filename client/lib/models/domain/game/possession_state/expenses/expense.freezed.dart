// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return _Expense.fromJson(json);
}

class _$ExpenseTearOff {
  const _$ExpenseTearOff();

  _Expense call({@required String name, @required double value}) {
    return _Expense(
      name: name,
      value: value,
    );
  }
}

// ignore: unused_element
const $Expense = _$ExpenseTearOff();

mixin _$Expense {
  String get name;
  double get value;

  Map<String, dynamic> toJson();
  $ExpenseCopyWith<Expense> get copyWith;
}

abstract class $ExpenseCopyWith<$Res> {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) then) =
      _$ExpenseCopyWithImpl<$Res>;
  $Res call({String name, double value});
}

class _$ExpenseCopyWithImpl<$Res> implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._value, this._then);

  final Expense _value;
  // ignore: unused_field
  final $Res Function(Expense) _then;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

abstract class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) then) =
      __$ExpenseCopyWithImpl<$Res>;
  @override
  $Res call({String name, double value});
}

class __$ExpenseCopyWithImpl<$Res> extends _$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(_Expense _value, $Res Function(_Expense) _then)
      : super(_value, (v) => _then(v as _Expense));

  @override
  _Expense get _value => super._value as _Expense;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
  }) {
    return _then(_Expense(
      name: name == freezed ? _value.name : name as String,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

@JsonSerializable()
class _$_Expense implements _Expense {
  _$_Expense({@required this.name, @required this.value})
      : assert(name != null),
        assert(value != null);

  factory _$_Expense.fromJson(Map<String, dynamic> json) =>
      _$_$_ExpenseFromJson(json);

  @override
  final String name;
  @override
  final double value;

  @override
  String toString() {
    return 'Expense(name: $name, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Expense &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$ExpenseCopyWith<_Expense> get copyWith =>
      __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_ExpenseToJson(this);
  }
}

abstract class _Expense implements Expense {
  factory _Expense({@required String name, @required double value}) =
      _$_Expense;

  factory _Expense.fromJson(Map<String, dynamic> json) = _$_Expense.fromJson;

  @override
  String get name;
  @override
  double get value;
  @override
  _$ExpenseCopyWith<_Expense> get copyWith;
}
