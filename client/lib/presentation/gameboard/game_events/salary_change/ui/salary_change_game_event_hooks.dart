import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/salary_change/models/salary_change_player_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

VoidCallback useSalaryChangePlayerActionHandler({
  required GameEvent event,
}) {
  final context = useContext();
  final dispatch = useDispatcher();
  final gameContext = useCurrentGameContext();

  return () {
    final action = SalaryChangePlayerAction(event.id);

    dispatch(SendPlayerMoveAction(
      eventId: event.id,
      playerAction: action,
      gameContext: gameContext,
    )).onError((e, st) => handleError(context: context, exception: e));
  };
}
