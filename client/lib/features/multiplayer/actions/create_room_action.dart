import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class CreateRoomAction extends BaseAction {
  @override
  Operation get operationKey => Operation.createRoom;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    final userId = state.profile.currentUser.id;
    final gameTemplateId = state.multiplayer.selectedGameTemplate.id;

    final requestModel = CreateRoomRequestModel(
      currentUserId: userId,
      gameTemplateId: gameTemplateId,
    );

    final room = await gameService.createRoom(requestModel);

    return state.rebuild((s) {
      s.multiplayer.currentRoom = room;
    });
  }

  @override
  void after() {
    super.after();

    final room = state.multiplayer.currentRoom;

    if (room != null) {
      dispatch(StartListeningRoomUpdatesAction(room.id));
    }
  }
}
