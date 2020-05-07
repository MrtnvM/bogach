// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'insurance_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
InsuranceAsset _$InsuranceAssetFromJson(Map<String, dynamic> json) {
  return _InsuranceAsset.fromJson(json);
}

class _$InsuranceAssetTearOff {
  const _$InsuranceAssetTearOff();

  _InsuranceAsset call(
      {@required String name,
      @required AssetType type,
      @required double downPayment,
      @required double value}) {
    return _InsuranceAsset(
      name: name,
      type: type,
      downPayment: downPayment,
      value: value,
    );
  }
}

// ignore: unused_element
const $InsuranceAsset = _$InsuranceAssetTearOff();

mixin _$InsuranceAsset {
  String get name;
  AssetType get type;
  double get downPayment;
  double get value;

  Map<String, dynamic> toJson();
  $InsuranceAssetCopyWith<InsuranceAsset> get copyWith;
}

abstract class $InsuranceAssetCopyWith<$Res> {
  factory $InsuranceAssetCopyWith(
          InsuranceAsset value, $Res Function(InsuranceAsset) then) =
      _$InsuranceAssetCopyWithImpl<$Res>;
  $Res call({String name, AssetType type, double downPayment, double value});
}

class _$InsuranceAssetCopyWithImpl<$Res>
    implements $InsuranceAssetCopyWith<$Res> {
  _$InsuranceAssetCopyWithImpl(this._value, this._then);

  final InsuranceAsset _value;
  // ignore: unused_field
  final $Res Function(InsuranceAsset) _then;

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

abstract class _$InsuranceAssetCopyWith<$Res>
    implements $InsuranceAssetCopyWith<$Res> {
  factory _$InsuranceAssetCopyWith(
          _InsuranceAsset value, $Res Function(_InsuranceAsset) then) =
      __$InsuranceAssetCopyWithImpl<$Res>;
  @override
  $Res call({String name, AssetType type, double downPayment, double value});
}

class __$InsuranceAssetCopyWithImpl<$Res>
    extends _$InsuranceAssetCopyWithImpl<$Res>
    implements _$InsuranceAssetCopyWith<$Res> {
  __$InsuranceAssetCopyWithImpl(
      _InsuranceAsset _value, $Res Function(_InsuranceAsset) _then)
      : super(_value, (v) => _then(v as _InsuranceAsset));

  @override
  _InsuranceAsset get _value => super._value as _InsuranceAsset;

  @override
  $Res call({
    Object name = freezed,
    Object type = freezed,
    Object downPayment = freezed,
    Object value = freezed,
  }) {
    return _then(_InsuranceAsset(
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as AssetType,
      downPayment:
          downPayment == freezed ? _value.downPayment : downPayment as double,
      value: value == freezed ? _value.value : value as double,
    ));
  }
}

@JsonSerializable()
class _$_InsuranceAsset implements _InsuranceAsset {
  _$_InsuranceAsset(
      {@required this.name,
      @required this.type,
      @required this.downPayment,
      @required this.value})
      : assert(name != null),
        assert(type != null),
        assert(downPayment != null),
        assert(value != null);

  factory _$_InsuranceAsset.fromJson(Map<String, dynamic> json) =>
      _$_$_InsuranceAssetFromJson(json);

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
    return 'InsuranceAsset(name: $name, type: $type, downPayment: $downPayment, value: $value)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _InsuranceAsset &&
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
  _$InsuranceAssetCopyWith<_InsuranceAsset> get copyWith =>
      __$InsuranceAssetCopyWithImpl<_InsuranceAsset>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_InsuranceAssetToJson(this);
  }
}

abstract class _InsuranceAsset implements InsuranceAsset {
  factory _InsuranceAsset(
      {@required String name,
      @required AssetType type,
      @required double downPayment,
      @required double value}) = _$_InsuranceAsset;

  factory _InsuranceAsset.fromJson(Map<String, dynamic> json) =
      _$_InsuranceAsset.fromJson;

  @override
  String get name;
  @override
  AssetType get type;
  @override
  double get downPayment;
  @override
  double get value;
  @override
  _$InsuranceAssetCopyWith<_InsuranceAsset> get copyWith;
}
