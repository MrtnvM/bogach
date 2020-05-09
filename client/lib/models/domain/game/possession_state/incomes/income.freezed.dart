// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'income.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Income _$IncomeFromJson(Map<String, dynamic> json) {
  return _Income.fromJson(json);
}

class _$IncomeTearOff {
  const _$IncomeTearOff();

  _Income call(
      {@required String name,
      @required double value,
      @required @JsonKey(unknownEnumValue: IncomeType.other) IncomeType type}) {
    return _Income(
      name: name,
      value: value,
      type: type,
    );
  }
}

// ignore: unused_element
const $Income = _$IncomeTearOff();

mixin _$Income {
  String get name;
  double get value;
  @JsonKey(unknownEnumValue: IncomeType.other)
  IncomeType get type;

  Map<String, dynamic> toJson();
  $IncomeCopyWith<Income> get copyWith;
}

abstract class $IncomeCopyWith<$Res> {
  factory $IncomeCopyWith(Income value, $Res Function(Income) then) =
      _$IncomeCopyWithImpl<$Res>;
  $Res call(
      {String name,
      double value,
      @JsonKey(unknownEnumValue: IncomeType.other) IncomeType type});
}

class _$IncomeCopyWithImpl<$Res> implements $IncomeCopyWith<$Res> {
  _$IncomeCopyWithImpl(this._value, this._then);

  final Income _value;
  // ignore: unused_field
  final $Res Function(Income) _then;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
    Object type = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      value: value == freezed ? _value.value : value as double,
      type: type == freezed ? _value.type : type as IncomeType,
    ));
  }
}

abstract class _$IncomeCopyWith<$Res> implements $IncomeCopyWith<$Res> {
  factory _$IncomeCopyWith(_Income value, $Res Function(_Income) then) =
      __$IncomeCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      double value,
      @JsonKey(unknownEnumValue: IncomeType.other) IncomeType type});
}

class __$IncomeCopyWithImpl<$Res> extends _$IncomeCopyWithImpl<$Res>
    implements _$IncomeCopyWith<$Res> {
  __$IncomeCopyWithImpl(_Income _value, $Res Function(_Income) _then)
      : super(_value, (v) => _then(v as _Income));

  @override
  _Income get _value => super._value as _Income;

  @override
  $Res call({
    Object name = freezed,
    Object value = freezed,
    Object type = freezed,
  }) {
    return _then(_Income(
      name: name == freezed ? _value.name : name as String,
      value: value == freezed ? _value.value : value as double,
      type: type == freezed ? _value.type : type as IncomeType,
    ));
  }
}

@JsonSerializable()
class _$_Income implements _Income {
  _$_Income(
      {@required this.name,
      @required this.value,
      @required @JsonKey(unknownEnumValue: IncomeType.other) this.type})
      : assert(name != null),
        assert(value != null),
        assert(type != null);

  factory _$_Income.fromJson(Map<String, dynamic> json) =>
      _$_$_IncomeFromJson(json);

  @override
  final String name;
  @override
  final double value;
  @override
  @JsonKey(unknownEnumValue: IncomeType.other)
  final IncomeType type;

  @override
  String toString() {
    return 'Income(name: $name, value: $value, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Income &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(value) ^
      const DeepCollectionEquality().hash(type);

  @override
  _$IncomeCopyWith<_Income> get copyWith =>
      __$IncomeCopyWithImpl<_Income>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_IncomeToJson(this);
  }
}

abstract class _Income implements Income {
  factory _Income(
      {@required
          String name,
      @required
          double value,
      @required
      @JsonKey(unknownEnumValue: IncomeType.other)
          IncomeType type}) = _$_Income;

  factory _Income.fromJson(Map<String, dynamic> json) = _$_Income.fromJson;

  @override
  String get name;
  @override
  double get value;
  @override
  @JsonKey(unknownEnumValue: IncomeType.other)
  IncomeType get type;
  @override
  _$IncomeCopyWith<_Income> get copyWith;
}
