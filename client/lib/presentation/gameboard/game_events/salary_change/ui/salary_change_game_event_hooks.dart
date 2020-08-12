import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/salary_change/salary_change_player_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

VoidCallback useSalaryChangePlayerActionHandler({
  @required GameEvent event,
}) {
  final gameActions = useGameActions();
  final context = useContext();

  return () {
    gameActions
        .sendPlayerAction(SalaryChangePlayerAction(event.id), event.id)
        .catchError((e) => handleError(context: context, exception: e));
  };
}
