// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Account _$AccountFromJson(Map<String, dynamic> json) {
  return _Account.fromJson(json);
}

class _$AccountTearOff {
  const _$AccountTearOff();

  _Account call(
      {@required double cashFlow,
      @required double cash,
      @required double credit}) {
    return _Account(
      cashFlow: cashFlow,
      cash: cash,
      credit: credit,
    );
  }
}

// ignore: unused_element
const $Account = _$AccountTearOff();

mixin _$Account {
  double get cashFlow;
  double get cash;
  double get credit;

  Map<String, dynamic> toJson();
  $AccountCopyWith<Account> get copyWith;
}

abstract class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) then) =
      _$AccountCopyWithImpl<$Res>;
  $Res call({double cashFlow, double cash, double credit});
}

class _$AccountCopyWithImpl<$Res> implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._value, this._then);

  final Account _value;
  // ignore: unused_field
  final $Res Function(Account) _then;

  @override
  $Res call({
    Object cashFlow = freezed,
    Object cash = freezed,
    Object credit = freezed,
  }) {
    return _then(_value.copyWith(
      cashFlow: cashFlow == freezed ? _value.cashFlow : cashFlow as double,
      cash: cash == freezed ? _value.cash : cash as double,
      credit: credit == freezed ? _value.credit : credit as double,
    ));
  }
}

abstract class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) then) =
      __$AccountCopyWithImpl<$Res>;
  @override
  $Res call({double cashFlow, double cash, double credit});
}

class __$AccountCopyWithImpl<$Res> extends _$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(_Account _value, $Res Function(_Account) _then)
      : super(_value, (v) => _then(v as _Account));

  @override
  _Account get _value => super._value as _Account;

  @override
  $Res call({
    Object cashFlow = freezed,
    Object cash = freezed,
    Object credit = freezed,
  }) {
    return _then(_Account(
      cashFlow: cashFlow == freezed ? _value.cashFlow : cashFlow as double,
      cash: cash == freezed ? _value.cash : cash as double,
      credit: credit == freezed ? _value.credit : credit as double,
    ));
  }
}

@JsonSerializable()
class _$_Account with DiagnosticableTreeMixin implements _Account {
  _$_Account(
      {@required this.cashFlow, @required this.cash, @required this.credit})
      : assert(cashFlow != null),
        assert(cash != null),
        assert(credit != null);

  factory _$_Account.fromJson(Map<String, dynamic> json) =>
      _$_$_AccountFromJson(json);

  @override
  final double cashFlow;
  @override
  final double cash;
  @override
  final double credit;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Account(cashFlow: $cashFlow, cash: $cash, credit: $credit)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Account'))
      ..add(DiagnosticsProperty('cashFlow', cashFlow))
      ..add(DiagnosticsProperty('cash', cash))
      ..add(DiagnosticsProperty('credit', credit));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Account &&
            (identical(other.cashFlow, cashFlow) ||
                const DeepCollectionEquality()
                    .equals(other.cashFlow, cashFlow)) &&
            (identical(other.cash, cash) ||
                const DeepCollectionEquality().equals(other.cash, cash)) &&
            (identical(other.credit, credit) ||
                const DeepCollectionEquality().equals(other.credit, credit)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(cashFlow) ^
      const DeepCollectionEquality().hash(cash) ^
      const DeepCollectionEquality().hash(credit);

  @override
  _$AccountCopyWith<_Account> get copyWith =>
      __$AccountCopyWithImpl<_Account>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_AccountToJson(this);
  }
}

abstract class _Account implements Account {
  factory _Account(
      {@required double cashFlow,
      @required double cash,
      @required double credit}) = _$_Account;

  factory _Account.fromJson(Map<String, dynamic> json) = _$_Account.fromJson;

  @override
  double get cashFlow;
  @override
  double get cash;
  @override
  double get credit;
  @override
  _$AccountCopyWith<_Account> get copyWith;
}
