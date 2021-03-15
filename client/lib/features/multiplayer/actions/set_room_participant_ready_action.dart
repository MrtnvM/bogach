import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class SetRoomParticipantReadyAction extends BaseAction {
  SetRoomParticipantReadyAction(this.participantId)
      : assert(participantId != null);

  final String participantId;

  @override
  Operation get operationKey => Operation.setRoomParticipantReady;

  @override
  Future<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    await gameService.setRoomParticipantReady(
      state.multiplayer.currentRoom.id,
      participantId,
    );

    return null;
  }
}
