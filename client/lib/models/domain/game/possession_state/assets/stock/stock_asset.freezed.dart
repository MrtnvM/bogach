// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'stock_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
StockAsset _$StockAssetFromJson(Map<String, dynamic> json) {
  return _StockAsset.fromJson(json);
}

class _$StockAssetTearOff {
  const _$StockAssetTearOff();

  _StockAsset call(
      {@required String name,
      @required AssetType type,
      @required double fairPrice,
      @required double averagePrice,
      @required int countInPortfolio}) {
    return _StockAsset(
      name: name,
      type: type,
      fairPrice: fairPrice,
      averagePrice: averagePrice,
      countInPortfolio: countInPortfolio,
    );
  }
}

// ignore: unused_element
const $StockAsset = _$StockAssetTearOff();

mixin _$StockAsset {
  String get name;
  AssetType get type;
  double get fairPrice;
  double get averagePrice;
  int get countInPortfolio;

  Map<String, dynamic> toJson();
  $StockAssetCopyWith<StockAsset> get copyWith;
}

abstract class $StockAssetCopyWith<$Res> {
  factory $StockAssetCopyWith(
          StockAsset value, $Res Function(StockAsset) then) =
      _$StockAssetCopyWithImpl<$Res>;
  $Res call(
      {String name,
      AssetType type,
      double fairPrice,
      double averagePrice,
      int countInPortfolio});
}

class _$StockAssetCopyWithImpl<$Res> implements $StockAssetCopyWith<$Res> {
  _$StockAssetCopyWithImpl(this._value, this._then);

  final StockAsset _value;
  // ignore: unused_field
  final $Res Function(StockAsset) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object fairPrice = freezed,
    Object averagePrice = freezed,
    Object countInPortfolio = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      fairPrice: fairPrice == freezed ? _value.fairPrice : fairPrice as double,
      averagePrice: averagePrice == freezed
          ? _value.averagePrice
          : averagePrice as double,
      countInPortfolio: countInPortfolio == freezed
          ? _value.countInPortfolio
          : countInPortfolio as int,
    ));
  }
}

abstract class _$StockAssetCopyWith<$Res> implements $StockAssetCopyWith<$Res> {
  factory _$StockAssetCopyWith(
          _StockAsset value, $Res Function(_StockAsset) then) =
      __$StockAssetCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      AssetType type,
      double fairPrice,
      double averagePrice,
      int countInPortfolio});
}

class __$StockAssetCopyWithImpl<$Res> extends _$StockAssetCopyWithImpl<$Res>
    implements _$StockAssetCopyWith<$Res> {
  __$StockAssetCopyWithImpl(
      _StockAsset _value, $Res Function(_StockAsset) _then)
      : super(_value, (v) => _then(v as _StockAsset));

  @override
  _StockAsset get _value => super._value as _StockAsset;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object fairPrice = freezed,
    Object averagePrice = freezed,
    Object countInPortfolio = freezed,
  }) {
    return _then(_StockAsset(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      fairPrice: fairPrice == freezed ? _value.fairPrice : fairPrice as double,
      averagePrice: averagePrice == freezed
          ? _value.averagePrice
          : averagePrice as double,
      countInPortfolio: countInPortfolio == freezed
          ? _value.countInPortfolio
          : countInPortfolio as int,
    ));
  }
}

@JsonSerializable()
class _$_StockAsset implements _StockAsset {
  _$_StockAsset(
      {@required this.name,
      @required this.type,
      @required this.fairPrice,
      @required this.averagePrice,
      @required this.countInPortfolio})
      : assert(name != null),
        assert(type != null),
        assert(fairPrice != null),
        assert(averagePrice != null),
        assert(countInPortfolio != null);

  factory _$_StockAsset.fromJson(Map<String, dynamic> json) =>
      _$_$_StockAssetFromJson(json);

  @override
  final String name;
  @override
  final AssetType type;
  @override
  final double fairPrice;
  @override
  final double averagePrice;
  @override
  final int countInPortfolio;

  @override
  String toString() {
    return 'StockAsset(name: $name, type: $type, fairPrice: $fairPrice, averagePrice: $averagePrice, countInPortfolio: $countInPortfolio)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _StockAsset &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.fairPrice, fairPrice) ||
                const DeepCollectionEquality()
                    .equals(other.fairPrice, fairPrice)) &&
            (identical(other.averagePrice, averagePrice) ||
                const DeepCollectionEquality()
                    .equals(other.averagePrice, averagePrice)) &&
            (identical(other.countInPortfolio, countInPortfolio) ||
                const DeepCollectionEquality()
                    .equals(other.countInPortfolio, countInPortfolio)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(fairPrice) ^
      const DeepCollectionEquality().hash(averagePrice) ^
      const DeepCollectionEquality().hash(countInPortfolio);

  @override
  _$StockAssetCopyWith<_StockAsset> get copyWith =>
      __$StockAssetCopyWithImpl<_StockAsset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_StockAssetToJson(this);
  }
}

abstract class _StockAsset implements StockAsset {
  factory _StockAsset(
      {@required String name,
      @required AssetType type,
      @required double fairPrice,
      @required double averagePrice,
      @required int countInPortfolio}) = _$_StockAsset;

  factory _StockAsset.fromJson(Map<String, dynamic> json) =
      _$_StockAsset.fromJson;

  @override
  String get name;
  @override
  AssetType get type;
  @override
  double get fairPrice;
  @override
  double get averagePrice;
  @override
  int get countInPortfolio;
  @override
  _$StockAssetCopyWith<_StockAsset> get copyWith;
}
