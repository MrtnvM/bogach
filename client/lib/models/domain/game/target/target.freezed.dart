// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'target.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Target _$TargetFromJson(Map<String, dynamic> json) {
  return _Target.fromJson(json);
}

class _$TargetTearOff {
  const _$TargetTearOff();

  _Target call({@required TargetType type, @required double value}) {
    return _Target(
      type: type,
      value: value,
    );
  }
}

// ignore: unused_element
const $Target = _$TargetTearOff();

mixin _$Target {
  TargetType get type;
  double get value;

  Map<String, dynamic> toJson();
  $TargetCopyWith<Target> get copyWith;
}

abstract class $TargetCopyWith<$Res> {
  factory $TargetCopyWith(Target value, $Res Function(Target) then) =
      _$TargetCopyWithImpl<$Res>;
  $Res call({TargetType type, double value});
}

class _$TargetCopyWithImpl<$Res> implements $TargetCopyWith<$Res> {
  _$TargetCopyWithImpl(this._value, this._then);

  final Target _value;
  // ignore: unused_field
  final $Res Function(Target) _then;

  @override
  $Res call({
    Object type = freezed,
    Object value = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed ? _value.type : type as TargetType,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

abstract class _$TargetCopyWith<$Res> implements $TargetCopyWith<$Res> {
  factory _$TargetCopyWith(_Target value, $Res Function(_Target) then) =
      __$TargetCopyWithImpl<$Res>;
  @override
  $Res call({TargetType type, double value});
}

class __$TargetCopyWithImpl<$Res> extends _$TargetCopyWithImpl<$Res>
    implements _$TargetCopyWith<$Res> {
  __$TargetCopyWithImpl(_Target _value, $Res Function(_Target) _then)
      : super(_value, (v) => _then(v as _Target));

  @override
  _Target get _value => super._value as _Target;

  @override
  $Res call({
    Object type = freezed,
    Object value = freezed,
  }) {
    return _then(_Target(
      type: type == freezed ? _value.type : type as TargetType,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

@JsonSerializable()
class _$_Target implements _Target {
  _$_Target({@required this.type, @required this.value})
      : assert(type != null),
        assert(value != null);

  factory _$_Target.fromJson(Map<String, dynamic> json) =>
      _$_$_TargetFromJson(json);

  @override
  final TargetType type;
  @override
  final double value;

  @override
  String toString() {
    return 'Target(type: $type, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Target &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$TargetCopyWith<_Target> get copyWith =>
      __$TargetCopyWithImpl<_Target>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_TargetToJson(this);
  }
}

abstract class _Target implements Target {
  factory _Target({@required TargetType type, @required double value}) =
      _$_Target;

  factory _Target.fromJson(Map<String, dynamic> json) = _$_Target.fromJson;

  @override
  TargetType get type;
  @override
  double get value;
  @override
  _$TargetCopyWith<_Target> get copyWith;
}
