// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'other_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
OtherAsset _$OtherAssetFromJson(Map<String, dynamic> json) {
  return _OtherAsset.fromJson(json);
}

class _$OtherAssetTearOff {
  const _$OtherAssetTearOff();

  _OtherAsset call(
      {@required String name,
      @required AssetType type,
      @required double downPayment,
      @required double value}) {
    return _OtherAsset(
      name: name,
      type: type,
      downPayment: downPayment,
      value: value,
    );
  }
}

// ignore: unused_element
const $OtherAsset = _$OtherAssetTearOff();

mixin _$OtherAsset {
  String get name;
  AssetType get type;
  double get downPayment;
  double get value;

  Map<String, dynamic> toJson();
  $OtherAssetCopyWith<OtherAsset> get copyWith;
}

abstract class $OtherAssetCopyWith<$Res> {
  factory $OtherAssetCopyWith(
          OtherAsset value, $Res Function(OtherAsset) then) =
      _$OtherAssetCopyWithImpl<$Res>;
  $Res call({String name, AssetType type, double downPayment, double value});
}

class _$OtherAssetCopyWithImpl<$Res> implements $OtherAssetCopyWith<$Res> {
  _$OtherAssetCopyWithImpl(this._value, this._then);

  final OtherAsset _value;
  // ignore: unused_field
  final $Res Function(OtherAsset) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object downPayment = freezed,
    Object value = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      downPayment:
          downPayment == freezed ? _value.downPayment : downPayment as double,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

abstract class _$OtherAssetCopyWith<$Res> implements $OtherAssetCopyWith<$Res> {
  factory _$OtherAssetCopyWith(
          _OtherAsset value, $Res Function(_OtherAsset) then) =
      __$OtherAssetCopyWithImpl<$Res>;
  @override
  $Res call({String name, AssetType type, double downPayment, double value});
}

class __$OtherAssetCopyWithImpl<$Res> extends _$OtherAssetCopyWithImpl<$Res>
    implements _$OtherAssetCopyWith<$Res> {
  __$OtherAssetCopyWithImpl(
      _OtherAsset _value, $Res Function(_OtherAsset) _then)
      : super(_value, (v) => _then(v as _OtherAsset));

  @override
  _OtherAsset get _value => super._value as _OtherAsset;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object downPayment = freezed,
    Object value = freezed,
  }) {
    return _then(_OtherAsset(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      downPayment:
          downPayment == freezed ? _value.downPayment : downPayment as double,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

@JsonSerializable()
class _$_OtherAsset implements _OtherAsset {
  _$_OtherAsset(
      {@required this.name,
      @required this.type,
      @required this.downPayment,
      @required this.value})
      : assert(name != null),
        assert(type != null),
        assert(downPayment != null),
        assert(value != null);

  factory _$_OtherAsset.fromJson(Map<String, dynamic> json) =>
      _$_$_OtherAssetFromJson(json);

  @override
  final String name;
  @override
  final AssetType type;
  @override
  final double downPayment;
  @override
  final double value;

  @override
  String toString() {
    return 'OtherAsset(name: $name, type: $type, downPayment: $downPayment, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _OtherAsset &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.downPayment, downPayment) ||
                const DeepCollectionEquality()
                    .equals(other.downPayment, downPayment)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(downPayment) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$OtherAssetCopyWith<_OtherAsset> get copyWith =>
      __$OtherAssetCopyWithImpl<_OtherAsset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_OtherAssetToJson(this);
  }
}

abstract class _OtherAsset implements OtherAsset {
  factory _OtherAsset(
      {@required String name,
      @required AssetType type,
      @required double downPayment,
      @required double value}) = _$_OtherAsset;

  factory _OtherAsset.fromJson(Map<String, dynamic> json) =
      _$_OtherAsset.fromJson;

  @override
  String get name;
  @override
  AssetType get type;
  @override
  double get downPayment;
  @override
  double get value;
  @override
  _$OtherAssetCopyWith<_OtherAsset> get copyWith;
}
