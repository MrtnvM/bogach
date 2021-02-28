import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../account/account.dart';
import '../target/target.dart';

class GameTemplate implements StoreListItem {
  const GameTemplate({
    @required this.id,
    @required this.name,
    @required this.icon,
    @required this.accountState,
    @required this.target,
    this.image,
  })  : assert(id != null),
        assert(name != null),
        assert(icon != null),
        assert(accountState != null),
        assert(target != null);

  @override
  final String id;
  final String name;
  final String icon;
  final Account accountState;
  final Target target;
  final String image;
}
