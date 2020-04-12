import 'package:cash_flow/models/domain/target_data.dart';
import 'package:cash_flow/models/state/posessions_state/user_possession_state.dart';
import 'package:flutter/material.dart';

class GameData {
  const GameData({
    @required this.possessions,
    @required this.target,
  })  : assert(possessions != null),
        assert(target != null);

  final UserPossessionState possessions;
  final TargetData target;
}
