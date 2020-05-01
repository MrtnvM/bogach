import 'package:flutter/material.dart';

class AccountState {
  const AccountState({
    @required this.cash,
    @required this.cashFlow,
    @required this.credit,
  })  : assert(cash != null),
        assert(cashFlow != null),
        assert(credit != null);

  final int cash;
  final int cashFlow;
  final int credit;
}
