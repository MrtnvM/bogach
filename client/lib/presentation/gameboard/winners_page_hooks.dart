import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:flutter/material.dart';

VoidCallback useGameRestarter() {
  final currentLevel = useCurrentGame((g) => g.config.level);
  final gameActions = useGameActions();

  final showCreateGameErrorAlert = useWarningAlert(
    needCancelButton: true,
  );

  void Function() startAgain;
  startAgain = () {
    if (currentLevel == null) {
      return;
    }

    gameActions.createGameByLevel(currentLevel).then((createdGameId) {
      gameActions.startGame(createdGameId);

      appRouter.goToRoot();
      appRouter.goTo(GameBoard());
    }).catchError(
      (error) => showCreateGameErrorAlert(error, startAgain),
    );
  };

  return startAgain;
}
