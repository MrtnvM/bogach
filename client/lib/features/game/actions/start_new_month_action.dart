import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class StartNewMonthAction extends BaseAction {
  @override
  Operation get operationKey => Operation.startNewMonth;

  @override
  Future<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final gameContext = state.game.currentGameContext;

    await gameService.startNewMonth(gameContext);

    return null;
  }
}
