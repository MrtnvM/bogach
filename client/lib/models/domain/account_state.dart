import 'package:flutter/material.dart';

class AccountState {
  const AccountState({
    @required this.cash,
    @required this.cashFlow,
    @required this.credit,
  })  : assert(cash != null),
        assert(cashFlow != null),
        assert(credit != null);

  final double cash;
  final double cashFlow;
  final double credit;
}
