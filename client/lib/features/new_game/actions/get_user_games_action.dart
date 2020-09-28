import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/models/domain/game/game/game.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class GetUserGamesAction extends BaseAction {
  GetUserGamesAction({
    @required this.userId,
    this.isRefreshing = false,
  })  : assert(userId != null),
        assert(isRefreshing != null);

  final String userId;
  final bool isRefreshing;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final games = await performRequest(
      gameService.getUserGames(userId),
      NetworkRequest.getUserGames,
      isRefreshing: isRefreshing,
    );

    return state.rebuild((s) {
      s.newGame.userGames = StoreList<Game>(games);
    });
  }
}
