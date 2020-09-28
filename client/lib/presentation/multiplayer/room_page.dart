import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/create_room_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/features/multiplayer/actions/set_room_participant_ready_action.dart';
import 'package:cash_flow/features/multiplayer/actions/share_room_invite_link_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/room/room_participant.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/user_profile_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';

class RoomPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final room = useGlobalState((s) => s.multiplayer.currentRoom);

    final userProfiles = useGlobalState((s) {
      return StoreList<UserProfile>([
        ...s.multiplayer.userProfiles.items,
        s.profile.currentUser,
      ]);
    });

    final isActionInProgress = useGlobalState(
      (s) =>
          s.network
              .getRequestState(NetworkRequest.createRoomGame)
              .isInProgress ||
          s.network
              .getRequestState(NetworkRequest.setRoomParticipantReady)
              .isInProgress,
    );

    final isCurrentUserRoomOwner = room.owner.id == userId;
    final participantsList = room.participants
        .map((p) => Tuple(p, userProfiles.itemsMap[p.id]))
        .toList();

    final isParticipantAlreadyJoined = !isCurrentUserRoomOwner &&
        room.participants
            .where((p) => p.id == userId)
            .any((p) => p.status == RoomParticipantStatus.ready);

    final canStartGame = room.participants.length >= 2;

    _useAutoTransitionToCreatedGame();

    final dispatch = useDispatcher();

    final inviteByLink = () {
      dispatch(ShareRoomInviteLinkAction(room.id))
          .catchError((e) => handleError(context: context, exception: e));
    };

    return LoadableView(
      backgroundColor: ColorRes.black80,
      isLoading: isActionInProgress,
      child: CashFlowScaffold(
        title: Strings.waitingPlayers,
        showUser: true,
        showBackArrow: true,
        child: SizedBox(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      for (final participant in participantsList)
                        _buildParticipantWidget(
                          participant: participant.item1,
                          profile: participant.item2 ??
                              UserProfile.unknownUser(
                                participant.item1.id,
                              ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),
              if (isCurrentUserRoomOwner) ...[
                _buildInviteByLinkButton(inviteByLink),
                const SizedBox(height: 16),
                _buildStartGameButton(
                  startGame: () => dispatch(CreateRoomGameAction()),
                  canStartGame: canStartGame,
                ),
              ],
              if (!isCurrentUserRoomOwner && isParticipantAlreadyJoined)
                _buildReadyButton(
                  join: () => dispatch(SetRoomParticipantReadyAction(userId)),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartGameButton({
    @required VoidCallback startGame,
    @required bool canStartGame,
  }) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.startGame,
        onPressed: canStartGame ? startGame : null,
        color: ColorRes.white,
      ),
    );
  }

  Widget _buildReadyButton({
    VoidCallback join,
  }) {
    return SizedBox(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.join,
        onPressed: join,
        color: ColorRes.white,
      ),
    );
  }

  Widget _buildInviteByLinkButton(VoidCallback inviteByLink) {
    return SizedBox(
      height: 50,
      width: 280,
      child: ColorButton(
        text: Strings.inviteByLink,
        onPressed: inviteByLink,
        color: ColorRes.white,
      ),
    );
  }

  Widget _buildParticipantWidget({
    @required UserProfile profile,
    @required RoomParticipant participant,
  }) {
    IconData icon;
    String status;

    switch (participant.status) {
      case RoomParticipantStatus.waiting:
        status = Strings.waiting;
        icon = Icons.access_time;
        break;

      case RoomParticipantStatus.ready:
        status = Strings.readyForGame;
        icon = Icons.check;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: ColorRes.lightGreen.withAlpha(40),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 94,
            child: UserProfileItem(profile),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: ColorRes.white64,
                size: 14,
              ),
              const SizedBox(width: 4),
              Text(status, style: Styles.body1.copyWith(fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }
}

void _useAutoTransitionToCreatedGame() {
  final userId = useUserId();
  final room = useGlobalState((s) => s.multiplayer.currentRoom);
  final dispatch = useDispatcher();

  useEffect(() {
    if (room?.gameId != null) {
      final gameContext = GameContext(gameId: room.gameId, userId: userId);
      dispatch(StartGameAction(gameContext));

      Future.delayed(const Duration(milliseconds: 100)).then((_) async {
        appRouter.goToRoot();
        appRouter.goTo(GameBoard());

        dispatch(StopListeningRoomUpdatesAction(room.id));
      });
    }

    return null;
  }, [room?.gameId]);
}
