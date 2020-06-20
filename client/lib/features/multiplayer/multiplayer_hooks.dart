import 'package:cash_flow/features/multiplayer/multiplayer_actions.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

_MultiplayerActions useMultiplayerActions() {
  final actionRunner = useActionRunner();

  return useMemoized(() {
    return _MultiplayerActions(
      searchUsers: (searchString) {
        actionRunner.runAction(
          QueryUserProfilesAsyncAction(searchString),
        );
      },
      selectGameTemplate: (gameTemplate) {
        actionRunner.runAction(
          SelectMultiplayerGameTemplateAction(gameTemplate),
        );
      },
      createRoom: () {
        return actionRunner.runAsyncAction(
          CreateRoomAsyncAction(),
        );
      },
      setPlayerReady: (participantId) {
        return actionRunner.runAsyncAction(
          SetRoomParticipantReadyAsyncAction(participantId),
        );
      },
      createRoomGame: () {
        return actionRunner.runAsyncAction(CreateRoomGameAsyncAction());
      },
      stopListeningRoomUpdates: (roomId) {
        actionRunner.runAction(StopListeningRoomUpdatesAction(roomId));
      },
      joinRoom: (roomId) {
        return actionRunner.runAsyncAction(JoinRoomAsyncAction(roomId));
      },
      shareRoomInviteLink: (roomId) {
        return actionRunner.runAsyncAction(
          ShareRoomInviteLinkAsyncAction(roomId),
        );
      },
    );
  });
}

class _MultiplayerActions {
  _MultiplayerActions({
    @required this.searchUsers,
    @required this.selectGameTemplate,
    @required this.createRoom,
    @required this.setPlayerReady,
    @required this.createRoomGame,
    @required this.stopListeningRoomUpdates,
    @required this.joinRoom,
    @required this.shareRoomInviteLink,
  });

  final void Function(String searchString) searchUsers;
  final void Function(GameTemplate gameTemplate) selectGameTemplate;

  final Future<Room> Function() createRoom;
  final Future Function(String participantId) setPlayerReady;
  final Future Function() createRoomGame;
  final void Function(String) stopListeningRoomUpdates;
  final Future<Tuple<Room, List<UserProfile>>> Function(String) joinRoom;
  final Future<void> Function(String) shareRoomInviteLink;
}
