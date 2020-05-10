// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'cash_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
CashAsset _$CashAssetFromJson(Map<String, dynamic> json) {
  return _CashAsset.fromJson(json);
}

class _$CashAssetTearOff {
  const _$CashAssetTearOff();

  _CashAsset call(
      {@required String name,
      @required AssetType type,
      @required double value}) {
    return _CashAsset(
      name: name,
      type: type,
      value: value,
    );
  }
}

// ignore: unused_element
const $CashAsset = _$CashAssetTearOff();

mixin _$CashAsset {
  String get name;
  AssetType get type;
  double get value;

  Map<String, dynamic> toJson();
  $CashAssetCopyWith<CashAsset> get copyWith;
}

abstract class $CashAssetCopyWith<$Res> {
  factory $CashAssetCopyWith(CashAsset value, $Res Function(CashAsset) then) =
      _$CashAssetCopyWithImpl<$Res>;
  $Res call({String name, AssetType type, double value});
}

class _$CashAssetCopyWithImpl<$Res> implements $CashAssetCopyWith<$Res> {
  _$CashAssetCopyWithImpl(this._value, this._then);

  final CashAsset _value;
  // ignore: unused_field
  final $Res Function(CashAsset) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object value = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

abstract class _$CashAssetCopyWith<$Res> implements $CashAssetCopyWith<$Res> {
  factory _$CashAssetCopyWith(
          _CashAsset value, $Res Function(_CashAsset) then) =
      __$CashAssetCopyWithImpl<$Res>;
  @override
  $Res call({String name, AssetType type, double value});
}

class __$CashAssetCopyWithImpl<$Res> extends _$CashAssetCopyWithImpl<$Res>
    implements _$CashAssetCopyWith<$Res> {
  __$CashAssetCopyWithImpl(_CashAsset _value, $Res Function(_CashAsset) _then)
      : super(_value, (v) => _then(v as _CashAsset));

  @override
  _CashAsset get _value => super._value as _CashAsset;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object value = freezed,
  }) {
    return _then(_CashAsset(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

@JsonSerializable()
class _$_CashAsset implements _CashAsset {
  _$_CashAsset({@required this.name, @required this.type, @required this.value})
      : assert(name != null),
        assert(type != null),
        assert(value != null);

  factory _$_CashAsset.fromJson(Map<String, dynamic> json) =>
      _$_$_CashAssetFromJson(json);

  @override
  final String name;
  @override
  final AssetType type;
  @override
  final double value;

  @override
  String toString() {
    return 'CashAsset(name: $name, type: $type, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CashAsset &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.value, value) ||
                const DeepCollectionEquality().equals(other.value, value)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(value);

  @override
  _$CashAssetCopyWith<_CashAsset> get copyWith =>
      __$CashAssetCopyWithImpl<_CashAsset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CashAssetToJson(this);
  }
}

abstract class _CashAsset implements CashAsset {
  factory _CashAsset(
      {@required String name,
      @required AssetType type,
      @required double value}) = _$_CashAsset;

  factory _CashAsset.fromJson(Map<String, dynamic> json) =
      _$_CashAsset.fromJson;

  @override
  String get name;
  @override
  AssetType get type;
  @override
  double get value;
  @override
  _$CashAssetCopyWith<_CashAsset> get copyWith;
}
