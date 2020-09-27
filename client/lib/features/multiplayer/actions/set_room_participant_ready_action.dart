import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class SetRoomParticipantReadyAsyncAction extends BaseAction {
  SetRoomParticipantReadyAsyncAction(this.participantId)
      : assert(participantId != null);

  final String participantId;

  @override
  FutureOr<AppState> reduce() {
    final gameService = GetIt.I.get<GameService>();

    performRequest(
      gameService
          .setRoomParticipantReady(
            state.multiplayer.currentRoom.id,
            participantId,
          )
          .first,
      NetworkRequest.setRoomParticipantReady,
    );

    return null;
  }
}
