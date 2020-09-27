import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/store/redux_action_observer.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:get_it/get_it.dart';

class JoinRoomAsyncAction extends BaseAction {
  JoinRoomAsyncAction(this.roomId) : assert(roomId != null);

  final String roomId;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();
    final userService = GetIt.I.get<UserService>();

    final joinRoomRequest = () async {
      final room = await gameService.getRoom(roomId);

      final participantsIds = room.participants.map((p) => p.id).toList();
      final profiles = await userService.loadProfiles(participantsIds);

      return Tuple(room, profiles);
    };

    final result = await performRequest(
      joinRoomRequest(),
      NetworkRequest.joinRoom,
    );

    final room = result.item1;
    final participantProfiles = result.item2;

    dispatch(StartListeningRoomUpdatesAction(room.id));

    return state.rebuild((s) {
      s.multiplayer.currentRoom = room;
      s.multiplayer.userProfiles.addAll(participantProfiles);
    });
  }
}
