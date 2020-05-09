// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'business_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
BusinessAsset _$BusinessAssetFromJson(Map<String, dynamic> json) {
  return _BusinessAsset.fromJson(json);
}

class _$BusinessAssetTearOff {
  const _$BusinessAssetTearOff();

  _BusinessAsset call(
      {@required String name,
      @required AssetType type,
      @required double buyPrice,
      @required double downPayment,
      @required double fairPrice,
      @required double passiveIncomePerMonth,
      @required double payback,
      @required double sellProbability}) {
    return _BusinessAsset(
      name: name,
      type: type,
      buyPrice: buyPrice,
      downPayment: downPayment,
      fairPrice: fairPrice,
      passiveIncomePerMonth: passiveIncomePerMonth,
      payback: payback,
      sellProbability: sellProbability,
    );
  }
}

// ignore: unused_element
const $BusinessAsset = _$BusinessAssetTearOff();

mixin _$BusinessAsset {
  String get name;
  AssetType get type;
  double get buyPrice;
  double get downPayment;
  double get fairPrice;
  double get passiveIncomePerMonth;
  double get payback;
  double get sellProbability;

  Map<String, dynamic> toJson();
  $BusinessAssetCopyWith<BusinessAsset> get copyWith;
}

abstract class $BusinessAssetCopyWith<$Res> {
  factory $BusinessAssetCopyWith(
          BusinessAsset value, $Res Function(BusinessAsset) then) =
      _$BusinessAssetCopyWithImpl<$Res>;
  $Res call(
      {String name,
      AssetType type,
      double buyPrice,
      double downPayment,
      double fairPrice,
      double passiveIncomePerMonth,
      double payback,
      double sellProbability});
}

class _$BusinessAssetCopyWithImpl<$Res>
    implements $BusinessAssetCopyWith<$Res> {
  _$BusinessAssetCopyWithImpl(this._value, this._then);

  final BusinessAsset _value;
  // ignore: unused_field
  final $Res Function(BusinessAsset) _then;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object buyPrice = freezed,
    Object downPayment = freezed,
    Object fairPrice = freezed,
    Object passiveIncomePerMonth = freezed,
    Object payback = freezed,
    Object sellProbability = freezed,
  }) {
    return _then(_value.copyWith(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      buyPrice: buyPrice == freezed ? _value.buyPrice : buyPrice as double,
      downPayment:
          downPayment == freezed ? _value.downPayment : downPayment as double,
      fairPrice: fairPrice == freezed ? _value.fairPrice : fairPrice as double,
      passiveIncomePerMonth: passiveIncomePerMonth == freezed
          ? _value.passiveIncomePerMonth
          : passiveIncomePerMonth as double,
      payback: payback == freezed ? _value.payback : payback as double,
      sellProbability: sellProbability == freezed
          ? _value.sellProbability
          : sellProbability as double,
    ));
  }
}

abstract class _$BusinessAssetCopyWith<$Res>
    implements $BusinessAssetCopyWith<$Res> {
  factory _$BusinessAssetCopyWith(
          _BusinessAsset value, $Res Function(_BusinessAsset) then) =
      __$BusinessAssetCopyWithImpl<$Res>;
  @override
  $Res call(
      {String name,
      AssetType type,
      double buyPrice,
      double downPayment,
      double fairPrice,
      double passiveIncomePerMonth,
      double payback,
      double sellProbability});
}

class __$BusinessAssetCopyWithImpl<$Res>
    extends _$BusinessAssetCopyWithImpl<$Res>
    implements _$BusinessAssetCopyWith<$Res> {
  __$BusinessAssetCopyWithImpl(
      _BusinessAsset _value, $Res Function(_BusinessAsset) _then)
      : super(_value, (v) => _then(v as _BusinessAsset));

  @override
  _BusinessAsset get _value => super._value as _BusinessAsset;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object buyPrice = freezed,
    Object downPayment = freezed,
    Object fairPrice = freezed,
    Object passiveIncomePerMonth = freezed,
    Object payback = freezed,
    Object sellProbability = freezed,
  }) {
    return _then(_BusinessAsset(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      buyPrice: buyPrice == freezed ? _value.buyPrice : buyPrice as double,
      downPayment:
          downPayment == freezed ? _value.downPayment : downPayment as double,
      fairPrice: fairPrice == freezed ? _value.fairPrice : fairPrice as double,
      passiveIncomePerMonth: passiveIncomePerMonth == freezed
          ? _value.passiveIncomePerMonth
          : passiveIncomePerMonth as double,
      payback: payback == freezed ? _value.payback : payback as double,
      sellProbability: sellProbability == freezed
          ? _value.sellProbability
          : sellProbability as double,
    ));
  }
}

@JsonSerializable()
class _$_BusinessAsset implements _BusinessAsset {
  _$_BusinessAsset(
      {@required this.name,
      @required this.type,
      @required this.buyPrice,
      @required this.downPayment,
      @required this.fairPrice,
      @required this.passiveIncomePerMonth,
      @required this.payback,
      @required this.sellProbability})
      : assert(name != null),
        assert(type != null),
        assert(buyPrice != null),
        assert(downPayment != null),
        assert(fairPrice != null),
        assert(passiveIncomePerMonth != null),
        assert(payback != null),
        assert(sellProbability != null);

  factory _$_BusinessAsset.fromJson(Map<String, dynamic> json) =>
      _$_$_BusinessAssetFromJson(json);

  @override
  final String name;
  @override
  final AssetType type;
  @override
  final double buyPrice;
  @override
  final double downPayment;
  @override
  final double fairPrice;
  @override
  final double passiveIncomePerMonth;
  @override
  final double payback;
  @override
  final double sellProbability;

  @override
  String toString() {
    return 'BusinessAsset(name: $name, type: $type, buyPrice: $buyPrice, downPayment: $downPayment, fairPrice: $fairPrice, passiveIncomePerMonth: $passiveIncomePerMonth, payback: $payback, sellProbability: $sellProbability)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _BusinessAsset &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.buyPrice, buyPrice) ||
                const DeepCollectionEquality()
                    .equals(other.buyPrice, buyPrice)) &&
            (identical(other.downPayment, downPayment) ||
                const DeepCollectionEquality()
                    .equals(other.downPayment, downPayment)) &&
            (identical(other.fairPrice, fairPrice) ||
                const DeepCollectionEquality()
                    .equals(other.fairPrice, fairPrice)) &&
            (identical(other.passiveIncomePerMonth, passiveIncomePerMonth) ||
                const DeepCollectionEquality().equals(
                    other.passiveIncomePerMonth, passiveIncomePerMonth)) &&
            (identical(other.payback, payback) ||
                const DeepCollectionEquality()
                    .equals(other.payback, payback)) &&
            (identical(other.sellProbability, sellProbability) ||
                const DeepCollectionEquality()
                    .equals(other.sellProbability, sellProbability)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(buyPrice) ^
      const DeepCollectionEquality().hash(downPayment) ^
      const DeepCollectionEquality().hash(fairPrice) ^
      const DeepCollectionEquality().hash(passiveIncomePerMonth) ^
      const DeepCollectionEquality().hash(payback) ^
      const DeepCollectionEquality().hash(sellProbability);

  @override
  _$BusinessAssetCopyWith<_BusinessAsset> get copyWith =>
      __$BusinessAssetCopyWithImpl<_BusinessAsset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_BusinessAssetToJson(this);
  }
}

abstract class _BusinessAsset implements BusinessAsset {
  factory _BusinessAsset(
      {@required String name,
      @required AssetType type,
      @required double buyPrice,
      @required double downPayment,
      @required double fairPrice,
      @required double passiveIncomePerMonth,
      @required double payback,
      @required double sellProbability}) = _$_BusinessAsset;

  factory _BusinessAsset.fromJson(Map<String, dynamic> json) =
      _$_BusinessAsset.fromJson;

  @override
  String get name;
  @override
  AssetType get type;
  @override
  double get buyPrice;
  @override
  double get downPayment;
  @override
  double get fairPrice;
  @override
  double get passiveIncomePerMonth;
  @override
  double get payback;
  @override
  double get sellProbability;
  @override
  _$BusinessAssetCopyWith<_BusinessAsset> get copyWith;
}
