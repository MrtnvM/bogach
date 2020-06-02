import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_actions.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:flutter/foundation.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

Epic<AppState> multiplayerEpic({
  @required UserService userService,
  @required GameService gameService,
}) {
  final queryUsersEpic = epic((action$, store) {
    return action$
        .whereType<QueryUserProfilesAsyncAction>()
        .where((action) => action.isStarted)
        .switchMap((action) => userService
            .searchUsers(action.query)
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final createRoomEpic = epic((action$, store) {
    return action$
        .whereType<CreateRoomAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) {
      final createRoom = gameService
          .createRoom(CreateRoomRequestModel(
            currentUserId: store.state.login.currentUser.id,
            gameTemplateId: store.state.multiplayer.selectedGameTemplate.id,
            participantIds: action.participantIds,
          ))
          .shareReplay();

      final onRoomUpdated = createRoom
          .flatMap((room) => gameService.subscribeOnRoomUpdates(room.id))
          .takeUntil(
            createRoom.flatMap((room) => action$
                .whereType<StopListeningRoomUpdatesAction>()
                .where((action) => action.roomId == room.id)),
          );

      return Rx.concat([createRoom, onRoomUpdated])
          .map(action.complete)
          .onErrorReturnWith(action.fail);
    });
  });

  final setPlayerReadyStatusEpic = epic((action$, store) {
    return action$
        .whereType<SetRoomParticipantReadyAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => gameService
            .setRoomParticipantReady(
              store.state.multiplayer.currentRoom.id,
              action.participantId,
            )
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final createRoomGameEpic = epic((action$, store) {
    return action$
        .whereType<CreateRoomGameAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => gameService
            .createRoomGame(
              store.state.multiplayer.currentRoom.id,
            )
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    queryUsersEpic,
    createRoomEpic,
    setPlayerReadyStatusEpic,
    createRoomGameEpic,
  ]);
}
