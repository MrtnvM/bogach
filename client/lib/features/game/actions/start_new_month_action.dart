import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class StartNewMonthAsyncAction extends BaseAction {
  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final gameContext = state.game.currentGameContext;

    performRequest(
      gameService.startNewMonth(gameContext).first,
      NetworkRequest.startNewMonth,
    );

    return null;
  }
}
