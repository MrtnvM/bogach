import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class StartSinglePlayerGameAction extends BaseAction {
  StartSinglePlayerGameAction({required this.templateId});

  final String templateId;

  @override
  Operation get operationKey => Operation.createGame;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  Future<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final userId = state.profile.currentUser!.id;

    final newGameId = await gameService.createNewGame(
      templateId: templateId,
      userId: userId,
    );

    return state.rebuild((s) {
      s.newGame.newGameId = newGameId;
    });
  }
}
