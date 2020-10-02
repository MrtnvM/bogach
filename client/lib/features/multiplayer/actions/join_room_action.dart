import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:get_it/get_it.dart';

class JoinRoomAction extends BaseAction {
  JoinRoomAction(this.roomId) : assert(roomId != null);

  final String roomId;

  @override
  Operation get operationKey => Operation.joinRoom;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final userService = GetIt.I.get<UserService>();

    final room = await gameService.getRoom(roomId);

    final participantsIds = room.participants.map((p) => p.id).toList();
    final participantProfiles = await userService.loadProfiles(participantsIds);

    return state.rebuild((s) {
      s.multiplayer.currentRoom = room;
      s.multiplayer.userProfiles.addAll(participantProfiles);
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
