import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

class GetQuestsAction extends BaseAction {
  GetQuestsAction({@required this.userId, this.isRefreshing = false})
      : assert(isRefreshing != null),
        assert(userId != null);

  final bool isRefreshing;
  final String userId;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final quests = await performRequest(
      gameService.getQuests(userId),
      NetworkRequest.getQuests,
      isRefreshing: isRefreshing,
    );

    return state.rebuild((s) {
      s.newGame.quests.updateList(quests);

      for (final quest in quests) {
        s.newGame.currentGameForQuests[quest.id] = quest.currentGameId;
      }
    });
  }
}
