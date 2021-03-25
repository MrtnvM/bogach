import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/room/room_participant.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/current_room_data_provider.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

String useCurrentRoomId() {
  final context = useContext();
  final roomId = CurrentRoomDataProvider.of(context).roomId;
  return roomId;
}

Room useCurrentRoom() {
  final roomId = useCurrentRoomId();
  final room = useGlobalState((s) => s.multiplayer.rooms[roomId]);
  return room;
}

void useAutoTransitionToCreatedGame() {
  final roomState = useCurrentRoomState();
  final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);

  useEffect(() {
    final gameId = roomState.room?.gameId;

    if (gameId != null) {
      final startGame = () async {
        SessionTracker.multiplayerGameCreated.stop();
        SessionTracker.multiplayerGameJoined.stop();

        SchedulerBinding.instance.addPostFrameCallback((_) {
          appRouter.goToRoot();

          if (isTutorialPassed) {
            appRouter.goTo(GameBoard(gameId: gameId));
          } else {
            appRouter.goTo(TutorialPage(gameId: gameId));
          }
        });
      };

      startGame();
    }

    return null;
  }, [roomState?.room?.gameId]);
}

_CurrentRoom useCurrentRoomState() {
  final userId = useUserId();
  final roomId = useCurrentRoomId();
  final room = useCurrentRoom();
  final dispatch = useDispatcher();

  useEffect(() {
    dispatch(StartListeningRoomUpdatesAction(roomId));
    return () => dispatch(StopListeningRoomUpdatesAction(roomId));
  }, []);

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
    roomId: roomId,
    room: room,
    isActionInProgress: isActionInProgress,
    isParticipantAlreadyJoined: isParticipantAlreadyJoined,
    isCurrentUserRoomOwner: isCurrentUserRoomOwner,
    ownerName: room?.owner?.fullName,
  );
}

class _CurrentRoom {
  _CurrentRoom({
    @required this.roomId,
    @required this.room,
    @required this.isActionInProgress,
    @required this.isCurrentUserRoomOwner,
    @required this.isParticipantAlreadyJoined,
    @required this.ownerName,
  });

  final String roomId;
  final Room room;
  final bool isActionInProgress;
  final bool isCurrentUserRoomOwner;
  final bool isParticipantAlreadyJoined;
  final String ownerName;
}
