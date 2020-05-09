// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'possession_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
PossessionState _$PossessionStateFromJson(Map<String, dynamic> json) {
  return _PossessionState.fromJson(json);
}

class _$PossessionStateTearOff {
  const _$PossessionStateTearOff();

  _PossessionState call(
      {@required List<Income> incomes,
      @required List<Expense> expenses,
      @required List<Asset> assets,
      @required List<Liability> liabilities}) {
    return _PossessionState(
      incomes: incomes,
      expenses: expenses,
      assets: assets,
      liabilities: liabilities,
    );
  }
}

// ignore: unused_element
const $PossessionState = _$PossessionStateTearOff();

mixin _$PossessionState {
  List<Income> get incomes;
  List<Expense> get expenses;
  List<Asset> get assets;
  List<Liability> get liabilities;

  Map<String, dynamic> toJson();
  $PossessionStateCopyWith<PossessionState> get copyWith;
}

abstract class $PossessionStateCopyWith<$Res> {
  factory $PossessionStateCopyWith(
          PossessionState value, $Res Function(PossessionState) then) =
      _$PossessionStateCopyWithImpl<$Res>;
  $Res call(
      {List<Income> incomes,
      List<Expense> expenses,
      List<Asset> assets,
      List<Liability> liabilities});
}

class _$PossessionStateCopyWithImpl<$Res>
    implements $PossessionStateCopyWith<$Res> {
  _$PossessionStateCopyWithImpl(this._value, this._then);

  final PossessionState _value;
  // ignore: unused_field
  final $Res Function(PossessionState) _then;

  @override
  $Res call({
    Object incomes = freezed,
    Object expenses = freezed,
    Object assets = freezed,
    Object liabilities = freezed,
  }) {
    return _then(_value.copyWith(
      incomes: incomes == freezed ? _value.incomes : incomes as List<Income>,
      expenses:
          expenses == freezed ? _value.expenses : expenses as List<Expense>,
      assets: assets == freezed ? _value.assets : assets as List<Asset>,
      liabilities: liabilities == freezed
          ? _value.liabilities
          : liabilities as List<Liability>,
    ));
  }
}

abstract class _$PossessionStateCopyWith<$Res>
    implements $PossessionStateCopyWith<$Res> {
  factory _$PossessionStateCopyWith(
          _PossessionState value, $Res Function(_PossessionState) then) =
      __$PossessionStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {List<Income> incomes,
      List<Expense> expenses,
      List<Asset> assets,
      List<Liability> liabilities});
}

class __$PossessionStateCopyWithImpl<$Res>
    extends _$PossessionStateCopyWithImpl<$Res>
    implements _$PossessionStateCopyWith<$Res> {
  __$PossessionStateCopyWithImpl(
      _PossessionState _value, $Res Function(_PossessionState) _then)
      : super(_value, (v) => _then(v as _PossessionState));

  @override
  _PossessionState get _value => super._value as _PossessionState;

  @override
  $Res call({
    Object incomes = freezed,
    Object expenses = freezed,
    Object assets = freezed,
    Object liabilities = freezed,
  }) {
    return _then(_PossessionState(
      incomes: incomes == freezed ? _value.incomes : incomes as List<Income>,
      expenses:
          expenses == freezed ? _value.expenses : expenses as List<Expense>,
      assets: assets == freezed ? _value.assets : assets as List<Asset>,
      liabilities: liabilities == freezed
          ? _value.liabilities
          : liabilities as List<Liability>,
    ));
  }
}

@JsonSerializable()
class _$_PossessionState implements _PossessionState {
  _$_PossessionState(
      {@required this.incomes,
      @required this.expenses,
      @required this.assets,
      @required this.liabilities})
      : assert(incomes != null),
        assert(expenses != null),
        assert(assets != null),
        assert(liabilities != null);

  factory _$_PossessionState.fromJson(Map<String, dynamic> json) =>
      _$_$_PossessionStateFromJson(json);

  @override
  final List<Income> incomes;
  @override
  final List<Expense> expenses;
  @override
  final List<Asset> assets;
  @override
  final List<Liability> liabilities;

  @override
  String toString() {
    return 'PossessionState(incomes: $incomes, expenses: $expenses, assets: $assets, liabilities: $liabilities)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _PossessionState &&
            (identical(other.incomes, incomes) ||
                const DeepCollectionEquality()
                    .equals(other.incomes, incomes)) &&
            (identical(other.expenses, expenses) ||
                const DeepCollectionEquality()
                    .equals(other.expenses, expenses)) &&
            (identical(other.assets, assets) ||
                const DeepCollectionEquality().equals(other.assets, assets)) &&
            (identical(other.liabilities, liabilities) ||
                const DeepCollectionEquality()
                    .equals(other.liabilities, liabilities)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(incomes) ^
      const DeepCollectionEquality().hash(expenses) ^
      const DeepCollectionEquality().hash(assets) ^
      const DeepCollectionEquality().hash(liabilities);

  @override
  _$PossessionStateCopyWith<_PossessionState> get copyWith =>
      __$PossessionStateCopyWithImpl<_PossessionState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_PossessionStateToJson(this);
  }
}

abstract class _PossessionState implements PossessionState {
  factory _PossessionState(
      {@required List<Income> incomes,
      @required List<Expense> expenses,
      @required List<Asset> assets,
      @required List<Liability> liabilities}) = _$_PossessionState;

  factory _PossessionState.fromJson(Map<String, dynamic> json) =
      _$_PossessionState.fromJson;

  @override
  List<Income> get incomes;
  @override
  List<Expense> get expenses;
  @override
  List<Asset> get assets;
  @override
  List<Liability> get liabilities;
  @override
  _$PossessionStateCopyWith<_PossessionState> get copyWith;
}
