// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'liability.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Liability _$LiabilityFromJson(Map<String, dynamic> json) {
  return _Liability.fromJson(json);
}

class _$LiabilityTearOff {
  const _$LiabilityTearOff();

  _Liability call(
      {@required String name,
      @required LiabilityType type,
      @required double monthlyPayment,
      @required double value}) {
    return _Liability(
      name: name,
      type: type,
      monthlyPayment: monthlyPayment,
      value: value,
    );
  }
}

// ignore: unused_element
const $Liability = _$LiabilityTearOff();

mixin _$Liability {
  String get name;
  LiabilityType get type;
  double get monthlyPayment;
  double get value;

  Map<String, dynamic> toJson();
  $LiabilityCopyWith<Liability> get copyWith;
}

abstract class $LiabilityCopyWith<$Res> {
  factory $LiabilityCopyWith(Liability value, $Res Function(Liability) then) =
      _$LiabilityCopyWithImpl<$Res>;
  $Res call(
      {String name, LiabilityType type, double monthlyPayment, double value});
}

class _$LiabilityCopyWithImpl<$Res> implements $LiabilityCopyWith<$Res> {
  _$LiabilityCopyWithImpl(this._value, this._then);

  final Liability _value;
  // ignore: unused_field
  final $Res Function(Liability) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object monthlyPayment = freezed,
    Object value = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as LiabilityType,
      monthlyPayment: monthlyPayment == freezed
          ? _value.monthlyPayment
          : monthlyPayment as double,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

abstract class _$LiabilityCopyWith<$Res> implements $LiabilityCopyWith<$Res> {
  factory _$LiabilityCopyWith(
          _Liability value, $Res Function(_Liability) then) =
      __$LiabilityCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name, LiabilityType type, double monthlyPayment, double value});
}

class __$LiabilityCopyWithImpl<$Res> extends _$LiabilityCopyWithImpl<$Res>
    implements _$LiabilityCopyWith<$Res> {
  __$LiabilityCopyWithImpl(_Liability _value, $Res Function(_Liability) _then)
      : super(_value, (v) => _then(v as _Liability));

  @override
  _Liability get _value => super._value as _Liability;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object monthlyPayment = freezed,
    Object value = freezed,
  }) {
    return _then(_Liability(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as LiabilityType,
      monthlyPayment: monthlyPayment == freezed
          ? _value.monthlyPayment
          : monthlyPayment as double,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

@JsonSerializable()
class _$_Liability implements _Liability {
  _$_Liability(
      {@required this.name,
      @required this.type,
      @required this.monthlyPayment,
      @required this.value})
      : assert(name != null),
        assert(type != null),
        assert(monthlyPayment != null),
        assert(value != null);

  factory _$_Liability.fromJson(Map<String, dynamic> json) =>
      _$_$_LiabilityFromJson(json);

  @override
  final String name;
  @override
  final LiabilityType type;
  @override
  final double monthlyPayment;
  @override
  final double value;

  @override
  String toString() {
    return 'Liability(name: $name, type: $type, monthlyPayment: $monthlyPayment, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Liability &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.monthlyPayment, monthlyPayment) ||
                const DeepCollectionEquality()
                    .equals(other.monthlyPayment, monthlyPayment)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(monthlyPayment) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$LiabilityCopyWith<_Liability> get copyWith =>
      __$LiabilityCopyWithImpl<_Liability>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_LiabilityToJson(this);
  }
}

abstract class _Liability implements Liability {
  factory _Liability(
      {@required String name,
      @required LiabilityType type,
      @required double monthlyPayment,
      @required double value}) = _$_Liability;

  factory _Liability.fromJson(Map<String, dynamic> json) =
      _$_Liability.fromJson;

  @override
  String get name;
  @override
  LiabilityType get type;
  @override
  double get monthlyPayment;
  @override
  double get value;
  @override
  _$LiabilityCopyWith<_Liability> get copyWith;
}
