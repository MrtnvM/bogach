import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_actions.dart';
import 'package:cash_flow/models/network/request/game/create_room_request_model.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:cash_flow/services/user_service.dart';
import 'package:cash_flow/utils/core/epic.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:flutter/foundation.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
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
          ))
          .shareReplay();

      final startListenRoom = createRoom
          .map<Action>((room) => StartListeningRoomUpdatesAction(room.id))
          .take(1);

      final createRoomAction = createRoom
          .take(1)
          .map<Action>(action.complete)
          .onErrorReturnWith(action.fail);

      return Rx.concat<Action>([
        createRoomAction,
        startListenRoom,
      ]);
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
            .createRoomGame(store.state.multiplayer.currentRoom.id)
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  final joinRoomEpic = epic((action$, store) {
    return action$
        .whereType<JoinRoomAsyncAction>()
        .where((action) => action.isStarted)
        .switchMap((action) {
      final room = gameService.getRoom(action.roomId).asStream().shareReplay();

      final joinRoomResult = room
          .asyncMap((room) => userService
              .loadProfiles(room.participants.map((p) => p.id).toList())
              .then((profiles) => Tuple(room, profiles)))
          .take(1);

      final startListenRoom = room
          .map<Action>((room) => StartListeningRoomUpdatesAction(room.id))
          .take(1);

      return Rx.concat([
        joinRoomResult.map(action.complete).onErrorReturnWith(action.fail),
        startListenRoom,
      ]);
    });
  });

  final listenRoomUpdatesEpic = epic((action$, store) {
    return action$ //
        .whereType<StartListeningRoomUpdatesAction>()
        .flatMap((action) => gameService
            .subscribeOnRoomUpdates(action.roomId)
            .takeUntil(action$
                .whereType<StopListeningRoomUpdatesAction>()
                .where((a) => a.roomId == action.roomId))
            .map<Action>((room) => OnCurrentRoomUpdatedAction(room))
            .onErrorReturnWith((error) => OnCurrentRoomUpdatedAction(null)));
  });

  final loadParticipantProfilesEpic = epic((action$, store) {
    return action$
        .whereType<OnCurrentRoomUpdatedAction>()
        .where((action) => action.room != null)
        .flatMap((action) {
      final isParticipantProfileLoaded = (id) {
        return store.state.multiplayer.userProfiles.itemsMap[id] != null;
      };

      final participantWithoutProfile = action.room.participants
          .where((p) => !isParticipantProfileLoaded(p.id))
          .map((p) => p.id)
          .toList();

      return userService
          .loadProfiles(participantWithoutProfile)
          .asStream()
          .map<Action>(
              (profiles) => OnLoadedParticipantProfilesAction(profiles))
          .onErrorReturnWith((error) {
        Logger.e('PARTICIPANT PROFILES LOADING FAILED\n$error');
        return OnLoadedParticipantProfilesAction([]);
      });
    });
  });

  final shareRoomInviteLinkEpic = epic((action$, store) {
    return action$
        .whereType<ShareRoomInviteLinkAsyncAction>()
        .where((action) => action.isStarted)
        .flatMap((action) => gameService
            .shareRoomInviteLink(
              roomId: action.roomId,
              currentUser: store.state.login.currentUser,
            )
            .asStream()
            .map(action.complete)
            .onErrorReturnWith(action.fail));
  });

  return combineEpics([
    queryUsersEpic,
    createRoomEpic,
    setPlayerReadyStatusEpic,
    createRoomGameEpic,
    joinRoomEpic,
    shareRoomInviteLinkEpic,
    listenRoomUpdatesEpic,
    loadParticipantProfilesEpic,
  ]);
}
