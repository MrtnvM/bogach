import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class GetQuestsAction extends BaseAction {
  GetQuestsAction({required this.userId, bool isRefreshing = false})
      : super(isRefreshing: isRefreshing);

  final String userId;

  @override
  Operation get operationKey => Operation.getQuests;

  @override
  Future<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final quests = await gameService.getQuests(userId);

    return state.rebuild((s) {
      s.newGame.quests!.updateList(quests);
    });
  }
}
