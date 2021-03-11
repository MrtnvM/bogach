import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/game/actions/start_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/create_room_game_action.dart';
import 'package:cash_flow/features/multiplayer/actions/room_listening_actions.dart';
import 'package:cash_flow/features/multiplayer/actions/set_room_participant_ready_action.dart';
import 'package:cash_flow/features/multiplayer/actions/share_room_invite_link_action.dart';
import 'package:cash_flow/models/domain/game/game_context/game_context.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/room/room_participant.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/presentation/main/widgets/game_type_title.dart';
import 'package:cash_flow/presentation/tutorial/tutorial_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer/shimmer.dart';

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

    final mediaQueryData = useAdaptiveMediaQueryData();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: LoadableView(
        backgroundColor: ColorRes.black80,
        isLoading: isActionInProgress,
        child: Scaffold(
          backgroundColor: ColorRes.mainPageBackground,
          body: MediaQuery(
            data: mediaQueryData,
            child: SafeArea(
              top: false,
              child: _buildBody(
                context: context,
                isCurrentUserRoomOwner: isCurrentUserRoomOwner,
                isParticipantAlreadyJoined: isParticipantAlreadyJoined,
                room: room,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _buildBody({
    BuildContext context,
    bool isCurrentUserRoomOwner,
    bool isParticipantAlreadyJoined,
    Room room,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _Header(templateId: room?.gameTemplateId),
        const SizedBox(height: 16),
        GameTypeTitle(text: Strings.players),
        const SizedBox(height: 16),
        const Divider(height: 1, indent: 16, endIndent: 16),
        Expanded(child: _ParticipantListWidget()),
        const Divider(height: 1, indent: 16, endIndent: 16),
        const SizedBox(height: 24),
        if (isCurrentUserRoomOwner) ...[
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
        ] else if (!isParticipantAlreadyJoined) ...[
          const _JoinRoomButton(),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _Header extends HookWidget {
  const _Header({Key key, @required this.templateId}) : super(key: key);

  final String templateId;

  @override
  Widget build(BuildContext context) {
    final screenSize = useScreenSize();
    final headerDesiredHeight = screenSize.height * 0.3;
    final headerHeight =
        min(headerDesiredHeight, screenSize.height > 700 ? 300 : 200);

    final template = useGlobalState(
      (s) => s.newGame.gameTemplates.itemsMap[templateId],
    );

    return SizedBox(
      width: double.infinity,
      height: headerHeight,
      child: Stack(
        children: [
          if (template == null)
            _buildShimmer()
          else
            _buildHeaderImage(template),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (template == null)
                  _buildPlaceholder(screenSize.width * 0.4)
                else
                  Text(
                    template.name,
                    style: Styles.bodyWhiteBold.copyWith(fontSize: 16),
                  ),
                const SizedBox(height: 4),
                if (template == null)
                  _buildPlaceholder(screenSize.width * 0.7)
                else
                  Text(
                    template.getDescription(),
                    style: Styles.body1.copyWith(fontSize: 16),
                  ),
              ],
            ),
          ),
          Positioned(
            child: GestureDetector(
              onTap: appRouter.goBack,
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16 + MediaQuery.of(context).padding.top,
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _buildPlaceholder(double width) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(140),
        borderRadius: BorderRadius.circular(6),
      ),
      height: 20,
      width: width,
    );
  }

  Stack _buildHeaderImage(GameTemplate template) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image(
            image: CachedNetworkImageProvider(template.image),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withAlpha(100)),
        ),
      ],
    );
  }

  Shimmer _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFDDDDDD),
      highlightColor: const Color(0xFFFFFFFF),
      child: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.grey,
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

        SessionTracker.multiplayerGameCreated.stop();
        SessionTracker.multiplayerGameJoined.stop();

        if (isTutorialPassed) {
          appRouter.goTo(const GameBoard());
        } else {
          appRouter.goTo(const TutorialPage());
        }

        dispatch(StopListeningRoomUpdatesAction(room.id));
      });
    }

    return () {
      if (room?.id != null) {
        dispatch(StopListeningRoomUpdatesAction(room.id));
      }
    };
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

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        for (final participant in participantsList)
          _buildParticipantWidget(
            participant: participant.item1,
            profile: participant.item2 ??
                UserProfile.unknownUser(
                  participant.item1.id,
                ),
          )
      ],
    );
  }

  Widget _buildParticipantWidget({
    @required UserProfile profile,
    @required RoomParticipant participant,
  }) {
    IconData icon;
    String status;
    Color color;

    switch (participant.status) {
      case RoomParticipantStatus.waiting:
        status = Strings.waiting;
        icon = Icons.access_time;
        color = ColorRes.grey;
        break;

      case RoomParticipantStatus.ready:
        status = Strings.readyForGame;
        icon = Icons.check;

        color = ColorRes.mainGreen;
        break;
    }

    return ListTile(
      title: Text(profile.fullName, style: Styles.bodyBlackSemibold),
      subtitle: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Expanded(child: Text(status)),
        ],
      ),
      leading: UserAvatar(
        url: profile.avatarUrl,
        size: 52,
        borderColor: color,
      ),
    );
  }
}
