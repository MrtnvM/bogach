// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'investment_event_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
InvestmentEventData _$InvestmentEventDataFromJson(Map<String, dynamic> json) {
  return _InvestmentEventData.fromJson(json);
}

class _$InvestmentEventDataTearOff {
  const _$InvestmentEventDataTearOff();

  _InvestmentEventData call(
      {int currentPrice, int maxCount, int nominal, int profitabilityPercent}) {
    return _InvestmentEventData(
      currentPrice: currentPrice,
      maxCount: maxCount,
      nominal: nominal,
      profitabilityPercent: profitabilityPercent,
    );
  }
}

// ignore: unused_element
const $InvestmentEventData = _$InvestmentEventDataTearOff();

mixin _$InvestmentEventData {
  int get currentPrice;
  int get maxCount;
  int get nominal;
  int get profitabilityPercent;

  Map<String, dynamic> toJson();
  $InvestmentEventDataCopyWith<InvestmentEventData> get copyWith;
}

abstract class $InvestmentEventDataCopyWith<$Res> {
  factory $InvestmentEventDataCopyWith(
          InvestmentEventData value, $Res Function(InvestmentEventData) then) =
      _$InvestmentEventDataCopyWithImpl<$Res>;
  $Res call(
      {int currentPrice, int maxCount, int nominal, int profitabilityPercent});
}

class _$InvestmentEventDataCopyWithImpl<$Res>
    implements $InvestmentEventDataCopyWith<$Res> {
  _$InvestmentEventDataCopyWithImpl(this._value, this._then);

  final InvestmentEventData _value;
  // ignore: unused_field
  final $Res Function(InvestmentEventData) _then;

  @override
  $Res call({
    Object currentPrice = freezed,
    Object maxCount = freezed,
    Object nominal = freezed,
    Object profitabilityPercent = freezed,
  }) {
    return _then(_value.copyWith(
      currentPrice:
          currentPrice == freezed ? _value.currentPrice : currentPrice as int,
      maxCount: maxCount == freezed ? _value.maxCount : maxCount as int,
      nominal: nominal == freezed ? _value.nominal : nominal as int,
      profitabilityPercent: profitabilityPercent == freezed
          ? _value.profitabilityPercent
          : profitabilityPercent as int,
    ));
  }
}

abstract class _$InvestmentEventDataCopyWith<$Res>
    implements $InvestmentEventDataCopyWith<$Res> {
  factory _$InvestmentEventDataCopyWith(_InvestmentEventData value,
          $Res Function(_InvestmentEventData) then) =
      __$InvestmentEventDataCopyWithImpl<$Res>;
  @override
  $Res call(
      {int currentPrice, int maxCount, int nominal, int profitabilityPercent});
}

class __$InvestmentEventDataCopyWithImpl<$Res>
    extends _$InvestmentEventDataCopyWithImpl<$Res>
    implements _$InvestmentEventDataCopyWith<$Res> {
  __$InvestmentEventDataCopyWithImpl(
      _InvestmentEventData _value, $Res Function(_InvestmentEventData) _then)
      : super(_value, (v) => _then(v as _InvestmentEventData));

  @override
  _InvestmentEventData get _value => super._value as _InvestmentEventData;

  @override
  $Res call({
    Object currentPrice = freezed,
    Object maxCount = freezed,
    Object nominal = freezed,
    Object profitabilityPercent = freezed,
  }) {
    return _then(_InvestmentEventData(
      currentPrice:
          currentPrice == freezed ? _value.currentPrice : currentPrice as int,
      maxCount: maxCount == freezed ? _value.maxCount : maxCount as int,
      nominal: nominal == freezed ? _value.nominal : nominal as int,
      profitabilityPercent: profitabilityPercent == freezed
          ? _value.profitabilityPercent
          : profitabilityPercent as int,
    ));
  }
}

@JsonSerializable()
class _$_InvestmentEventData
    with DiagnosticableTreeMixin
    implements _InvestmentEventData {
  _$_InvestmentEventData(
      {this.currentPrice,
      this.maxCount,
      this.nominal,
      this.profitabilityPercent});

  factory _$_InvestmentEventData.fromJson(Map<String, dynamic> json) =>
      _$_$_InvestmentEventDataFromJson(json);

  @override
  final int currentPrice;
  @override
  final int maxCount;
  @override
  final int nominal;
  @override
  final int profitabilityPercent;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'InvestmentEventData(currentPrice: $currentPrice, maxCount: $maxCount, nominal: $nominal, profitabilityPercent: $profitabilityPercent)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'InvestmentEventData'))
      ..add(DiagnosticsProperty('currentPrice', currentPrice))
      ..add(DiagnosticsProperty('maxCount', maxCount))
      ..add(DiagnosticsProperty('nominal', nominal))
      ..add(DiagnosticsProperty('profitabilityPercent', profitabilityPercent));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _InvestmentEventData &&
            (identical(other.currentPrice, currentPrice) ||
                const DeepCollectionEquality()
                    .equals(other.currentPrice, currentPrice)) &&
            (identical(other.maxCount, maxCount) ||
                const DeepCollectionEquality()
                    .equals(other.maxCount, maxCount)) &&
            (identical(other.nominal, nominal) ||
                const DeepCollectionEquality()
                    .equals(other.nominal, nominal)) &&
            (identical(other.profitabilityPercent, profitabilityPercent) ||
                const DeepCollectionEquality()
                    .equals(other.profitabilityPercent, profitabilityPercent)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(currentPrice) ^
      const DeepCollectionEquality().hash(maxCount) ^
      const DeepCollectionEquality().hash(nominal) ^
      const DeepCollectionEquality().hash(profitabilityPercent);

  @override
  _$InvestmentEventDataCopyWith<_InvestmentEventData> get copyWith =>
      __$InvestmentEventDataCopyWithImpl<_InvestmentEventData>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_InvestmentEventDataToJson(this);
  }
}

abstract class _InvestmentEventData implements InvestmentEventData {
  factory _InvestmentEventData(
      {int currentPrice,
      int maxCount,
      int nominal,
      int profitabilityPercent}) = _$_InvestmentEventData;

  factory _InvestmentEventData.fromJson(Map<String, dynamic> json) =
      _$_InvestmentEventData.fromJson;

  @override
  int get currentPrice;
  @override
  int get maxCount;
  @override
  int get nominal;
  @override
  int get profitabilityPercent;
  @override
  _$InvestmentEventDataCopyWith<_InvestmentEventData> get copyWith;
}
