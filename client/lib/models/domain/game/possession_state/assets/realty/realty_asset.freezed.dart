// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'realty_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
RealtyAsset _$RealtyAssetFromJson(Map<String, dynamic> json) {
  return _RealtyAsset.fromJson(json);
}

class _$RealtyAssetTearOff {
  const _$RealtyAssetTearOff();

  _RealtyAsset call(
      {@required String name,
      @required AssetType type,
      @required double downPayment,
      @required double cost}) {
    return _RealtyAsset(
      name: name,
      type: type,
      downPayment: downPayment,
      cost: cost,
    );
  }
}

// ignore: unused_element
const $RealtyAsset = _$RealtyAssetTearOff();

mixin _$RealtyAsset {
  String get name;
  AssetType get type;
  double get downPayment;
  double get cost;

  Map<String, dynamic> toJson();
  $RealtyAssetCopyWith<RealtyAsset> get copyWith;
}

abstract class $RealtyAssetCopyWith<$Res> {
  factory $RealtyAssetCopyWith(
          RealtyAsset value, $Res Function(RealtyAsset) then) =
      _$RealtyAssetCopyWithImpl<$Res>;
  $Res call({String name, AssetType type, double downPayment, double cost});
}

class _$RealtyAssetCopyWithImpl<$Res> implements $RealtyAssetCopyWith<$Res> {
  _$RealtyAssetCopyWithImpl(this._value, this._then);

  final RealtyAsset _value;
  // ignore: unused_field
  final $Res Function(RealtyAsset) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object downPayment = freezed,
    Object cost = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      downPayment:
          downPayment == freezed ? _value.downPayment : downPayment as double,
      cost: cost == freezed ? _value.cost : cost as double,
    ));
  }
}

abstract class _$RealtyAssetCopyWith<$Res>
    implements $RealtyAssetCopyWith<$Res> {
  factory _$RealtyAssetCopyWith(
          _RealtyAsset value, $Res Function(_RealtyAsset) then) =
      __$RealtyAssetCopyWithImpl<$Res>;
  @override
  $Res call({String name, AssetType type, double downPayment, double cost});
}

class __$RealtyAssetCopyWithImpl<$Res> extends _$RealtyAssetCopyWithImpl<$Res>
    implements _$RealtyAssetCopyWith<$Res> {
  __$RealtyAssetCopyWithImpl(
      _RealtyAsset _value, $Res Function(_RealtyAsset) _then)
      : super(_value, (v) => _then(v as _RealtyAsset));

  @override
  _RealtyAsset get _value => super._value as _RealtyAsset;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object downPayment = freezed,
    Object cost = freezed,
  }) {
    return _then(_RealtyAsset(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      downPayment:
          downPayment == freezed ? _value.downPayment : downPayment as double,
      cost: cost == freezed ? _value.cost : cost as double,
    ));
  }
}

@JsonSerializable()
class _$_RealtyAsset implements _RealtyAsset {
  _$_RealtyAsset(
      {@required this.name,
      @required this.type,
      @required this.downPayment,
      @required this.cost})
      : assert(name != null),
        assert(type != null),
        assert(downPayment != null),
        assert(cost != null);

  factory _$_RealtyAsset.fromJson(Map<String, dynamic> json) =>
      _$_$_RealtyAssetFromJson(json);

  @override
  final String name;
  @override
  final AssetType type;
  @override
  final double downPayment;
  @override
  final double cost;

  @override
  String toString() {
    return 'RealtyAsset(name: $name, type: $type, downPayment: $downPayment, cost: $cost)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _RealtyAsset &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.downPayment, downPayment) ||
                const DeepCollectionEquality()
                    .equals(other.downPayment, downPayment)) &&
            (identical(other.cost, cost) ||
                const DeepCollectionEquality().equals(other.cost, cost)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(downPayment) ^
      const DeepCollectionEquality().hash(cost);

  @override
  _$RealtyAssetCopyWith<_RealtyAsset> get copyWith =>
      __$RealtyAssetCopyWithImpl<_RealtyAsset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_RealtyAssetToJson(this);
  }
}

abstract class _RealtyAsset implements RealtyAsset {
  factory _RealtyAsset(
      {@required String name,
      @required AssetType type,
      @required double downPayment,
      @required double cost}) = _$_RealtyAsset;

  factory _RealtyAsset.fromJson(Map<String, dynamic> json) =
      _$_RealtyAsset.fromJson;

  @override
  String get name;
  @override
  AssetType get type;
  @override
  double get downPayment;
  @override
  double get cost;
  @override
  _$RealtyAssetCopyWith<_RealtyAsset> get copyWith;
}
