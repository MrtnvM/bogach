import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

import '../account/account.dart';
import '../target/target.dart';

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
  final Account accountState;
  final Target target;
}
