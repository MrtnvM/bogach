import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class CreateRoomAction extends BaseAction {
  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final userId = state.profile.currentUser.id;
    final gameTemplateId = state.multiplayer.selectedGameTemplate.id;

    final requestModel = CreateRoomRequestModel(
      currentUserId: userId,
      gameTemplateId: gameTemplateId,
    );

    final room = await performRequest(
      gameService.createRoom(requestModel),
      NetworkRequest.createRoom,
    );

    dispatch(StartListeningRoomUpdatesAction(room.id));

    return state.rebuild((s) {
      s.multiplayer.currentRoom = room;
    });
  }
}
