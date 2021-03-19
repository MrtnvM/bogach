import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/game/actions/set_game_context.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/room/room_participant.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

void useAutoTransitionToCreatedGame() {
  final userId = useUserId();
  final room = useGlobalState((s) => s.multiplayer.currentRoom);
  final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);
  final dispatch = useDispatcher();

  useEffect(() {
    if (room?.gameId != null) {
      final startGame = () async {
        final gameContext = GameContext(gameId: room.gameId, userId: userId);

        await dispatch(SetGameContextAction(gameContext));
        await dispatch(StartGameAction(gameContext));
        await Future.delayed(const Duration(milliseconds: 100));

        appRouter.goToRoot();

        SessionTracker.multiplayerGameCreated.stop();
        SessionTracker.multiplayerGameJoined.stop();

        if (isTutorialPassed) {
          appRouter.goTo(const GameBoard());
        } else {
          appRouter.goTo(const TutorialPage());
        }

        dispatch(StopListeningRoomUpdatesAction(room.id));
      };

      startGame();
    }

    return () {
      if (room?.id != null) {
        dispatch(StopListeningRoomUpdatesAction(room.id));
      }
    };
  }, [room?.gameId]);
}

_CurrentRoom useCurrentRoom() {
  final userId = useUserId();
  final room = useGlobalState((s) => s.multiplayer.currentRoom);

  final isActionInProgress = useGlobalState(
    (s) =>
        s.getOperationState(Operation.createRoomGame).isInProgress ||
        s.getOperationState(Operation.setRoomParticipantReady).isInProgress,
  );

  final isCurrentUserRoomOwner = room?.owner?.id == userId;

  final isParticipantAlreadyJoined = !isCurrentUserRoomOwner &&
      (room?.participants ?? [])
          .where((p) => p.id == userId)
          .any((p) => p.status == RoomParticipantStatus.ready);

  return _CurrentRoom(
    room: room,
    isActionInProgress: isActionInProgress,
    isParticipantAlreadyJoined: isParticipantAlreadyJoined,
    isCurrentUserRoomOwner: isCurrentUserRoomOwner,
    ownerName: room?.owner?.fullName,
  );
}

class _CurrentRoom {
  _CurrentRoom({
    @required this.room,
    @required this.isActionInProgress,
    @required this.isCurrentUserRoomOwner,
    @required this.isParticipantAlreadyJoined,
    @required this.ownerName,
  });

  final Room room;
  final bool isActionInProgress;
  final bool isCurrentUserRoomOwner;
  final bool isParticipantAlreadyJoined;
  final String ownerName;
}
