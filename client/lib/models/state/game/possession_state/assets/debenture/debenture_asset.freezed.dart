// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'debenture_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
DebentureAsset _$DebentureAssetFromJson(Map<String, dynamic> json) {
  return _DebentureAsset.fromJson(json);
}

class _$DebentureAssetTearOff {
  const _$DebentureAssetTearOff();

  _DebentureAsset call(
      {@required String name,
      @required AssetType type,
      @required double averagePrice,
      @required double nominal,
      @required double profitabilityPercent,
      @required int count}) {
    return _DebentureAsset(
      name: name,
      type: type,
      averagePrice: averagePrice,
      nominal: nominal,
      profitabilityPercent: profitabilityPercent,
      count: count,
    );
  }
}

// ignore: unused_element
const $DebentureAsset = _$DebentureAssetTearOff();

mixin _$DebentureAsset {
  String get name;
  AssetType get type;
  double get averagePrice;
  double get nominal;
  double get profitabilityPercent;
  int get count;

  Map<String, dynamic> toJson();
  $DebentureAssetCopyWith<DebentureAsset> get copyWith;
}

abstract class $DebentureAssetCopyWith<$Res> {
  factory $DebentureAssetCopyWith(
          DebentureAsset value, $Res Function(DebentureAsset) then) =
      _$DebentureAssetCopyWithImpl<$Res>;
  $Res call(
      {String name,
      AssetType type,
      double averagePrice,
      double nominal,
      double profitabilityPercent,
      int count});
}

class _$DebentureAssetCopyWithImpl<$Res>
    implements $DebentureAssetCopyWith<$Res> {
  _$DebentureAssetCopyWithImpl(this._value, this._then);

  final DebentureAsset _value;
  // ignore: unused_field
  final $Res Function(DebentureAsset) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object averagePrice = freezed,
    Object nominal = freezed,
    Object profitabilityPercent = freezed,
    Object count = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      averagePrice: averagePrice == freezed
          ? _value.averagePrice
          : averagePrice as double,
      nominal: nominal == freezed ? _value.nominal : nominal as double,
      profitabilityPercent: profitabilityPercent == freezed
          ? _value.profitabilityPercent
          : profitabilityPercent as double,
      count: count == freezed ? _value.count : count as int,
    ));
  }
}

abstract class _$DebentureAssetCopyWith<$Res>
    implements $DebentureAssetCopyWith<$Res> {
  factory _$DebentureAssetCopyWith(
          _DebentureAsset value, $Res Function(_DebentureAsset) then) =
      __$DebentureAssetCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      AssetType type,
      double averagePrice,
      double nominal,
      double profitabilityPercent,
      int count});
}

class __$DebentureAssetCopyWithImpl<$Res>
    extends _$DebentureAssetCopyWithImpl<$Res>
    implements _$DebentureAssetCopyWith<$Res> {
  __$DebentureAssetCopyWithImpl(
      _DebentureAsset _value, $Res Function(_DebentureAsset) _then)
      : super(_value, (v) => _then(v as _DebentureAsset));

  @override
  _DebentureAsset get _value => super._value as _DebentureAsset;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object averagePrice = freezed,
    Object nominal = freezed,
    Object profitabilityPercent = freezed,
    Object count = freezed,
  }) {
    return _then(_DebentureAsset(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      averagePrice: averagePrice == freezed
          ? _value.averagePrice
          : averagePrice as double,
      nominal: nominal == freezed ? _value.nominal : nominal as double,
      profitabilityPercent: profitabilityPercent == freezed
          ? _value.profitabilityPercent
          : profitabilityPercent as double,
      count: count == freezed ? _value.count : count as int,
    ));
  }
}

@JsonSerializable()
class _$_DebentureAsset implements _DebentureAsset {
  _$_DebentureAsset(
      {@required this.name,
      @required this.type,
      @required this.averagePrice,
      @required this.nominal,
      @required this.profitabilityPercent,
      @required this.count})
      : assert(name != null),
        assert(type != null),
        assert(averagePrice != null),
        assert(nominal != null),
        assert(profitabilityPercent != null),
        assert(count != null);

  factory _$_DebentureAsset.fromJson(Map<String, dynamic> json) =>
      _$_$_DebentureAssetFromJson(json);

  @override
  final String name;
  @override
  final AssetType type;
  @override
  final double averagePrice;
  @override
  final double nominal;
  @override
  final double profitabilityPercent;
  @override
  final int count;

  @override
  String toString() {
    return 'DebentureAsset(name: $name, type: $type, averagePrice: $averagePrice, nominal: $nominal, profitabilityPercent: $profitabilityPercent, count: $count)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _DebentureAsset &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.averagePrice, averagePrice) ||
                const DeepCollectionEquality()
                    .equals(other.averagePrice, averagePrice)) &&
            (identical(other.nominal, nominal) ||
                const DeepCollectionEquality()
                    .equals(other.nominal, nominal)) &&
            (identical(other.profitabilityPercent, profitabilityPercent) ||
                const DeepCollectionEquality().equals(
                    other.profitabilityPercent, profitabilityPercent)) &&
            (identical(other.count, count) ||
                const DeepCollectionEquality().equals(other.count, count)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(averagePrice) ^
      const DeepCollectionEquality().hash(nominal) ^
      const DeepCollectionEquality().hash(profitabilityPercent) ^
      const DeepCollectionEquality().hash(count);

  @override
  _$DebentureAssetCopyWith<_DebentureAsset> get copyWith =>
      __$DebentureAssetCopyWithImpl<_DebentureAsset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_DebentureAssetToJson(this);
  }
}

abstract class _DebentureAsset implements DebentureAsset {
  factory _DebentureAsset(
      {@required String name,
      @required AssetType type,
      @required double averagePrice,
      @required double nominal,
      @required double profitabilityPercent,
      @required int count}) = _$_DebentureAsset;

  factory _DebentureAsset.fromJson(Map<String, dynamic> json) =
      _$_DebentureAsset.fromJson;

  @override
  String get name;
  @override
  AssetType get type;
  @override
  double get averagePrice;
  @override
  double get nominal;
  @override
  double get profitabilityPercent;
  @override
  int get count;
  @override
  _$DebentureAssetCopyWith<_DebentureAsset> get copyWith;
}
