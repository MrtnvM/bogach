import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class GetGameLevelsAction extends BaseAction {
  GetGameLevelsAction({@required this.userId, this.isRefreshing = false})
      : assert(isRefreshing != null),
        assert(userId != null);

  final bool isRefreshing;
  final String userId;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final gameLevels = await performRequest(
      gameService.getGameLevels(userId).first,
      NetworkRequest.getGameLevels,
      isRefreshing: isRefreshing,
    );

    return state.rebuild((s) {
      s.newGame.gameLevels.updateList(gameLevels);

      for (final level in gameLevels) {
        s.newGame.currentGameForLevels[level.id] = level.currentGameId;
      }
    });
  }
}
