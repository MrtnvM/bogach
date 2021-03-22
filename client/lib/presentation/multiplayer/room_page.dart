import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/multiplayer/actions/create_room_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/set_room_participant_ready_action.dart';
import 'package:cash_flow/features/multiplayer/actions/share_room_invite_link_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/multiplayer/room_page_hooks.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/participants_list_widget.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/room_header.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/note.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RoomPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQueryData = useAdaptiveMediaQueryData();
    final room = useCurrentRoom();

    useAutoTransitionToCreatedGame();

    useEffect(() {
      SessionTracker.roomPage.start();
      return SessionTracker.roomPage.stop;
    }, []);

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: LoadableView(
        backgroundColor: ColorRes.black80,
        isLoading: room.isActionInProgress,
        child: Scaffold(
          backgroundColor: ColorRes.mainPageBackground,
          body: MediaQuery(
            data: mediaQueryData,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RoomHeader(templateId: room.room?.gameTemplateId),
                  const SizedBox(height: 16),
                  SectionTitle(text: Strings.players),
                  const SizedBox(height: 16),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  Expanded(child: ParticipantListWidget()),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  const SizedBox(height: 24),
                  if (room.isCurrentUserRoomOwner) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Expanded(child: _InviteButton()),
                          SizedBox(height: 16, width: 16),
                          Expanded(child: _StartGameButton()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ] else if (!room.isParticipantAlreadyJoined) ...[
                    const _JoinRoomButton(),
                    const SizedBox(height: 16),
                  ],
                  if (!room.isCurrentUserRoomOwner &&
                      room.isParticipantAlreadyJoined &&
                      room.ownerName != null) ...[
                    Note(
                      title: Strings.waitingWhenLeaderStartGame(room.ownerName),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    const SizedBox(height: 16),
                  ]
                ],
              ),
            ),
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
    final join = () async {
      try {
        await dispatch(SetRoomParticipantReadyAction(userId));
        AnalyticsSender.multiplayerParticipantJoined();
      } catch (e) {
        AnalyticsSender.multiplayerParticipantJoinFailed();
        handleError(context: context, exception: e);
      }
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
    final isLoading = useState(false);

    final inviteByLink = () {
      AnalyticsSender.multiplayerInviteLinkCreated();
      isLoading.value = true;

      dispatch(ShareRoomInviteLinkAction(roomId))
          .then((_) => isLoading.value = false)
          .catchError((e) {
        isLoading.value = false;
        handleError(context: context, exception: e);
      });
    };

    return _Button(
      title: Strings.invite,
      icon: Icons.add,
      color: ColorRes.yellow,
      onTap: inviteByLink,
      isLoading: isLoading.value,
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    @required this.title,
    @required this.icon,
    @required this.color,
    @required this.onTap,
    this.isLoading = false,
    Key key,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLoading;

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
        child: isLoading
            ? const Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 3),
                ),
              )
            : InkWell(
                onTap: onTap,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 20, color: Colors.black),
                    const SizedBox(width: 6),
                    Text(
                      title,
                      style: Styles.bodyBlack.copyWith(
                        fontSize: 14.5,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
