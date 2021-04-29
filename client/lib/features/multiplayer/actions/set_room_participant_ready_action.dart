import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/game_service.dart';

class SetRoomParticipantReadyAction extends BaseAction {
  SetRoomParticipantReadyAction({
    required this.participantId,
    required this.roomId,
  });

  final String participantId;
  final String? roomId;

  @override
  Operation get operationKey => Operation.setRoomParticipantReady;

  @override
  Future<AppState?> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    await gameService.setRoomParticipantReady(
      roomId,
      participantId,
    );

    return null;
  }
}
