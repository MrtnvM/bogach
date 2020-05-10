// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'buy_sell_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$BuySellActionTearOff {
  const _$BuySellActionTearOff();

  BuyAction buy() {
    return const BuyAction();
  }

  SellAction sell() {
    return const SellAction();
  }
}

// ignore: unused_element
const $BuySellAction = _$BuySellActionTearOff();

mixin _$BuySellAction {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result buy(),
    @required Result sell(),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result buy(),
    Result sell(),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result buy(BuyAction value),
    @required Result sell(SellAction value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result buy(BuyAction value),
    Result sell(SellAction value),
    @required Result orElse(),
  });
}

abstract class $BuySellActionCopyWith<$Res> {
  factory $BuySellActionCopyWith(
          BuySellAction value, $Res Function(BuySellAction) then) =
      _$BuySellActionCopyWithImpl<$Res>;
}

class _$BuySellActionCopyWithImpl<$Res>
    implements $BuySellActionCopyWith<$Res> {
  _$BuySellActionCopyWithImpl(this._value, this._then);

  final BuySellAction _value;
  // ignore: unused_field
  final $Res Function(BuySellAction) _then;
}

abstract class $BuyActionCopyWith<$Res> {
  factory $BuyActionCopyWith(BuyAction value, $Res Function(BuyAction) then) =
      _$BuyActionCopyWithImpl<$Res>;
}

class _$BuyActionCopyWithImpl<$Res> extends _$BuySellActionCopyWithImpl<$Res>
    implements $BuyActionCopyWith<$Res> {
  _$BuyActionCopyWithImpl(BuyAction _value, $Res Function(BuyAction) _then)
      : super(_value, (v) => _then(v as BuyAction));

  @override
  BuyAction get _value => super._value as BuyAction;
}

class _$BuyAction implements BuyAction {
  const _$BuyAction();

  @override
  String toString() {
    return 'BuySellAction.buy()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is BuyAction);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result buy(),
    @required Result sell(),
  }) {
    assert(buy != null);
    assert(sell != null);
    return buy();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result buy(),
    Result sell(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (buy != null) {
      return buy();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result buy(BuyAction value),
    @required Result sell(SellAction value),
  }) {
    assert(buy != null);
    assert(sell != null);
    return buy(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result buy(BuyAction value),
    Result sell(SellAction value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (buy != null) {
      return buy(this);
    }
    return orElse();
  }
}

abstract class BuyAction implements BuySellAction {
  const factory BuyAction() = _$BuyAction;
}

abstract class $SellActionCopyWith<$Res> {
  factory $SellActionCopyWith(
          SellAction value, $Res Function(SellAction) then) =
      _$SellActionCopyWithImpl<$Res>;
}

class _$SellActionCopyWithImpl<$Res> extends _$BuySellActionCopyWithImpl<$Res>
    implements $SellActionCopyWith<$Res> {
  _$SellActionCopyWithImpl(SellAction _value, $Res Function(SellAction) _then)
      : super(_value, (v) => _then(v as SellAction));

  @override
  SellAction get _value => super._value as SellAction;
}

class _$SellAction implements SellAction {
  const _$SellAction();

  @override
  String toString() {
    return 'BuySellAction.sell()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is SellAction);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result buy(),
    @required Result sell(),
  }) {
    assert(buy != null);
    assert(sell != null);
    return sell();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result buy(),
    Result sell(),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (sell != null) {
      return sell();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result buy(BuyAction value),
    @required Result sell(SellAction value),
  }) {
    assert(buy != null);
    assert(sell != null);
    return sell(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result buy(BuyAction value),
    Result sell(SellAction value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (sell != null) {
      return sell(this);
    }
    return orElse();
  }
}

abstract class SellAction implements BuySellAction {
  const factory SellAction() = _$SellAction;
}
