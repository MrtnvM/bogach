// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'stock_event_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
StockEventData _$StockEventDataFromJson(Map<String, dynamic> json) {
  return _StockEventData.fromJson(json);
}

class _$StockEventDataTearOff {
  const _$StockEventDataTearOff();

  _StockEventData call({int currentPrice, int availableCount, int fairPrice}) {
    return _StockEventData(
      currentPrice: currentPrice,
      availableCount: availableCount,
      fairPrice: fairPrice,
    );
  }
}

// ignore: unused_element
const $StockEventData = _$StockEventDataTearOff();

mixin _$StockEventData {
  int get currentPrice;
  int get availableCount;
  int get fairPrice;

  Map<String, dynamic> toJson();
  $StockEventDataCopyWith<StockEventData> get copyWith;
}

abstract class $StockEventDataCopyWith<$Res> {
  factory $StockEventDataCopyWith(
          StockEventData value, $Res Function(StockEventData) then) =
      _$StockEventDataCopyWithImpl<$Res>;
  $Res call({int currentPrice, int availableCount, int fairPrice});
}

class _$StockEventDataCopyWithImpl<$Res>
    implements $StockEventDataCopyWith<$Res> {
  _$StockEventDataCopyWithImpl(this._value, this._then);

  final StockEventData _value;
  // ignore: unused_field
  final $Res Function(StockEventData) _then;

  @override
  $Res call({
    Object currentPrice = freezed,
    Object availableCount = freezed,
    Object fairPrice = freezed,
  }) {
    return _then(_value.copyWith(
      currentPrice:
          currentPrice == freezed ? _value.currentPrice : currentPrice as int,
      availableCount: availableCount == freezed
          ? _value.availableCount
          : availableCount as int,
      fairPrice: fairPrice == freezed ? _value.fairPrice : fairPrice as int,
    ));
  }
}

abstract class _$StockEventDataCopyWith<$Res>
    implements $StockEventDataCopyWith<$Res> {
  factory _$StockEventDataCopyWith(
          _StockEventData value, $Res Function(_StockEventData) then) =
      __$StockEventDataCopyWithImpl<$Res>;
  @override
  $Res call({int currentPrice, int availableCount, int fairPrice});
}

class __$StockEventDataCopyWithImpl<$Res>
    extends _$StockEventDataCopyWithImpl<$Res>
    implements _$StockEventDataCopyWith<$Res> {
  __$StockEventDataCopyWithImpl(
      _StockEventData _value, $Res Function(_StockEventData) _then)
      : super(_value, (v) => _then(v as _StockEventData));

  @override
  _StockEventData get _value => super._value as _StockEventData;

  @override
  $Res call({
    Object currentPrice = freezed,
    Object availableCount = freezed,
    Object fairPrice = freezed,
  }) {
    return _then(_StockEventData(
      currentPrice:
          currentPrice == freezed ? _value.currentPrice : currentPrice as int,
      availableCount: availableCount == freezed
          ? _value.availableCount
          : availableCount as int,
      fairPrice: fairPrice == freezed ? _value.fairPrice : fairPrice as int,
    ));
  }
}

@JsonSerializable()
class _$_StockEventData implements _StockEventData {
  _$_StockEventData({this.currentPrice, this.availableCount, this.fairPrice});

  factory _$_StockEventData.fromJson(Map<String, dynamic> json) =>
      _$_$_StockEventDataFromJson(json);

  @override
  final int currentPrice;
  @override
  final int availableCount;
  @override
  final int fairPrice;

  @override
  String toString() {
    return 'StockEventData(currentPrice: $currentPrice, availableCount: $availableCount, fairPrice: $fairPrice)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _StockEventData &&
            (identical(other.currentPrice, currentPrice) ||
                const DeepCollectionEquality()
                    .equals(other.currentPrice, currentPrice)) &&
            (identical(other.availableCount, availableCount) ||
                const DeepCollectionEquality()
                    .equals(other.availableCount, availableCount)) &&
            (identical(other.fairPrice, fairPrice) ||
                const DeepCollectionEquality()
                    .equals(other.fairPrice, fairPrice)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(currentPrice) ^
      const DeepCollectionEquality().hash(availableCount) ^
      const DeepCollectionEquality().hash(fairPrice);

  @override
  _$StockEventDataCopyWith<_StockEventData> get copyWith =>
      __$StockEventDataCopyWithImpl<_StockEventData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_StockEventDataToJson(this);
  }
}

abstract class _StockEventData implements StockEventData {
  factory _StockEventData(
      {int currentPrice,
      int availableCount,
      int fairPrice}) = _$_StockEventData;

  factory _StockEventData.fromJson(Map<String, dynamic> json) =
      _$_StockEventData.fromJson;

  @override
  int get currentPrice;
  @override
  int get availableCount;
  @override
  int get fairPrice;
  @override
  _$StockEventDataCopyWith<_StockEventData> get copyWith;
}
