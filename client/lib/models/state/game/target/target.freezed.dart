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

  _Target call() {
    return _Target();
  }
}

// ignore: unused_element
const $Target = _$TargetTearOff();

mixin _$Target {
  Map<String, dynamic> toJson();
}

abstract class $TargetCopyWith<$Res> {
  factory $TargetCopyWith(Target value, $Res Function(Target) then) =
      _$TargetCopyWithImpl<$Res>;
}

class _$TargetCopyWithImpl<$Res> implements $TargetCopyWith<$Res> {
  _$TargetCopyWithImpl(this._value, this._then);

  final Target _value;
  // ignore: unused_field
  final $Res Function(Target) _then;
}

abstract class _$TargetCopyWith<$Res> {
  factory _$TargetCopyWith(_Target value, $Res Function(_Target) then) =
      __$TargetCopyWithImpl<$Res>;
}

class __$TargetCopyWithImpl<$Res> extends _$TargetCopyWithImpl<$Res>
    implements _$TargetCopyWith<$Res> {
  __$TargetCopyWithImpl(_Target _value, $Res Function(_Target) _then)
      : super(_value, (v) => _then(v as _Target));

  @override
  _Target get _value => super._value as _Target;
}

@JsonSerializable()
class _$_Target implements _Target {
  _$_Target();

  factory _$_Target.fromJson(Map<String, dynamic> json) =>
      _$_$_TargetFromJson(json);

  @override
  String toString() {
    return 'Target()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Target);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$_$_TargetToJson(this);
  }
}

abstract class _Target implements Target {
  factory _Target() = _$_Target;

  factory _Target.fromJson(Map<String, dynamic> json) = _$_Target.fromJson;
}
