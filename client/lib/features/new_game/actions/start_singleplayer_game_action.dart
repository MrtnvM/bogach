import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class StartSinglePlayerGameAction extends BaseAction {
  StartSinglePlayerGameAction({@required this.templateId})
      : assert(templateId != null);

  final String templateId;
  String _initialNewGameId;

  @override
  Operation get operationKey => Operation.createGame;

  @override
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  void before() {
    super.before();
    _initialNewGameId = state.newGame.newGameId;
  }

  @override
  Future<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final userId = state.profile.currentUser.id;

    final newGameId = await gameService.createNewGame(
      templateId: templateId,
      userId: userId,
    );

    return state.rebuild((s) {
      s.newGame.newGameId = newGameId;
    });
  }

  @override
  void after() {
    super.after();

    final userId = state.profile.currentUser?.id;
    final newGameId = state.newGame.newGameId;

    if (userId != null && newGameId != null && _initialNewGameId != newGameId) {
      final gameContext = GameContext(gameId: newGameId, userId: userId);
      dispatch(StartGameAction(gameContext));
    }
  }
}
