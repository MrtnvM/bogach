import 'package:cash_flow/models/domain/account_state.dart';
import 'package:cash_flow/models/domain/target_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class GameTemplate implements StoreListItem {
  const GameTemplate({
    @required this.id,
    @required this.name,
    @required this.accountState,
    @required this.target,
  })  : assert(id != null),
        assert(name != null),
        assert(accountState != null),
        assert(target != null);

  @override
  final String id;
  final String name;
  final AccountState accountState;
  final TargetData target;
}
