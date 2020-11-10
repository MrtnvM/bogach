import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/create_room_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/features/multiplayer/actions/set_room_participant_ready_action.dart';
import 'package:cash_flow/features/multiplayer/actions/share_room_invite_link_action.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/room/room_participant.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/user_profile_item.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:cash_flow/widgets/containers/note.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RoomPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
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

    _useAutoTransitionToCreatedGame();

    return LoadableView(
      backgroundColor: ColorRes.black80,
      isLoading: isActionInProgress,
      child: CashFlowScaffold(
        title: Strings.waitingPlayers,
        showUser: true,
        showBackArrow: true,
        horizontalPadding: 16,
        child: SizedBox(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Divider(height: 1),
              Expanded(child: _ParticipantListWidget()),
              const Divider(height: 1),
              const SizedBox(height: 16),
              if (isCurrentUserRoomOwner)
                _InviteFriendsNote()
              else
                _JoinToRoomNote(),
              const SizedBox(height: 24),
              if (isCurrentUserRoomOwner) ...[
                Row(
                  children: const [
                    Expanded(child: _InviteButton()),
                    SizedBox(height: 16, width: 16),
                    Expanded(child: _StartGameButton()),
                  ],
                ),
                const SizedBox(height: 24),
              ] else if (!isParticipantAlreadyJoined) ...[
                const _JoinRoomButton(),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _JoinRoomButton extends HookWidget {
  const _JoinRoomButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final dispatch = useDispatcher();
    final join = () {
      return dispatch(SetRoomParticipantReadyAction(userId)).catchError(
        (e) => handleError(context: context, exception: e),
      );
    };

    return _Button(
      title: Strings.join,
      icon: Icons.check,
      onTap: join,
      color: ColorRes.white,
    );
  }
}

class _StartGameButton extends HookWidget {
  const _StartGameButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final room = useGlobalState((s) => s.multiplayer.currentRoom);
    final canStartGame = room != null ? room.participants.length >= 2 : false;

    final dispatch = useDispatcher();
    final startGame = () => dispatch(CreateRoomGameAction());

    return _Button(
      title: Strings.startGame,
      icon: Icons.check,
      onTap: canStartGame ? startGame : null,
      color: ColorRes.white,
    );
  }
}

class _InviteButton extends HookWidget {
  const _InviteButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomId = useGlobalState((s) => s.multiplayer.currentRoom?.id);
    final dispatch = useDispatcher();

    final inviteByLink = () {
      dispatch(ShareRoomInviteLinkAction(roomId))
          .catchError((e) => handleError(context: context, exception: e));
    };

    return _Button(
      title: Strings.invite,
      icon: Icons.add,
      color: ColorRes.yellow,
      onTap: inviteByLink,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    @required this.title,
    @required this.icon,
    @required this.color,
    @required this.onTap,
    Key key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onTap == null ? 0.6 : 1,
      child: Container(
        constraints: const BoxConstraints(minWidth: 120, maxWidth: 200),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        alignment: Alignment.center,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: Colors.black),
              const SizedBox(width: 6),
              Text(
                title,
                style: Styles.bodyBlack.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InviteFriendsNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Note(title: Strings.inviteFriendsToStart);
  }
}

class _JoinToRoomNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Note(title: Strings.joinToRoom);
  }
}

void _useAutoTransitionToCreatedGame() {
  final userId = useUserId();
  final room = useGlobalState((s) => s.multiplayer.currentRoom);
  final isTutorialPassed = useConfig((c) => c.isGameboardTutorialPassed);
  final dispatch = useDispatcher();

  useEffect(() {
    if (room?.gameId != null) {
      final gameContext = GameContext(gameId: room.gameId, userId: userId);
      dispatch(StartGameAction(gameContext));

      Future.delayed(const Duration(milliseconds: 100)).then((_) async {
        appRouter.goToRoot();

        if (isTutorialPassed) {
          appRouter.goTo(const GameBoard());
        } else {
          appRouter.goTo(const TutorialPage());
        }

        dispatch(StopListeningRoomUpdatesAction(room.id));
      });
    }

    return null;
  }, [room?.gameId]);
}

class _ParticipantListWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final room = useGlobalState((s) => s.multiplayer.currentRoom);

    final userProfiles = useGlobalState((s) {
      return StoreList<UserProfile>([
        ...s.multiplayer.userProfiles.items,
        s.profile.currentUser,
      ]);
    });

    final participantsList = (room?.participants ?? [])
        .map((p) => Tuple(p, userProfiles.itemsMap[p.id]))
        .toList();

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: double.infinity,
          maxWidth: double.infinity,
        ),
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
