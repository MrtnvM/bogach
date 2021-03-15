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
  bool abortDispatch() => state.profile.currentUser == null;

  @override
  Future<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final roomId = state.multiplayer.currentRoom.id;

    await gameService.createRoomGame(roomId);

    return state.rebuild((s) {
      final currentUser = s.profile.currentUser;
      final multiplayerGamePlayed = currentUser.multiplayerGamePlayed ?? 0;

      final updatedUser = currentUser.copyWith(
        multiplayerGamePlayed: multiplayerGamePlayed + 1,
      );

      s.profile.currentUser = updatedUser;
    });
  }
}
