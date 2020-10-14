import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class CreateRoomGameAction extends BaseAction {
  @override
  Operation get operationKey => Operation.createRoomGame;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final roomId = state.multiplayer.currentRoom.id;

    await gameService.createRoomGame(roomId);

    return state.rebuild((s) {
      final multiplayerGamesCount =
          s.profile.currentUser.purchaseProfile.multiplayerGamesCount - 1;

      final updatedUser = s.profile.currentUser.copyWith.purchaseProfile(
        multiplayerGamesCount: multiplayerGamesCount,
      );

      s.profile.currentUser = updatedUser;
    });
  }
}
