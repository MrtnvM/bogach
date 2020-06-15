import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/horizontal_user_profiles_list.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_loadable/flutter_platform_loadable.dart';

class CreateRoomPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final selectedPlayers = useState(<UserProfile>{});
    final currentRoom = useGlobalState((s) => s.multiplayer.currentRoom);
    final possiblePlayers = useGlobalState(
      (s) => s.multiplayer.userProfiles.items
          .where((u) => !u.isAnonymous)
          .where((u) => u.userId != userId)
          .toList(),
    );
    final isRoomCreationInProgress = useGlobalState(
      (s) => s.multiplayer.createRoomRequestState.isInProgress,
    );
    final multiplayerActions = useMultiplayerActions();

    useEffect(() {
      multiplayerActions.searchUsers('');
      return null;
    }, []);

    final selectPlayer = (player) {
      if (selectedPlayers.value.length > 5) {
        return;
      }

      selectedPlayers.value = {...selectedPlayers.value, player};
    };

    final removeUser = (player) {
      selectedPlayers.value.remove(player);
      selectedPlayers.value = selectedPlayers.value.toSet();
    };

    final showRoomCreationFailedAlert = useWarningAlert(
      message: (_) => Strings.roomCreationFailed,
    );

    VoidCallback createRoom;
    createRoom = () {
      if (selectedPlayers.value.isEmpty) {
        return;
      }

      multiplayerActions
          .createRoom()
          .then((_) => appRouter.goTo(RoomPage()))
          .catchError((e) => showRoomCreationFailedAlert(e, createRoom));
    };

    final inviteByLink = () async {
      var room = currentRoom;

      try {
        if (currentRoom == null) {
          room = await multiplayerActions.createRoom();
        }

        await multiplayerActions
            .shareRoomInviteLink(room.id)
            .then((_) => appRouter.goTo(RoomPage()))
            .catchError((e) => showRoomCreationFailedAlert(e, createRoom));
      } on dynamic catch (error) {
        showRoomCreationFailedAlert(error, createRoom);
      }
    };

    return Loadable(
      backgroundColor: ColorRes.black80,
      isLoading: isRoomCreationInProgress,
      child: CashFlowScaffold(
        title: Strings.selectPlayers,
        showUser: true,
        child: Container(
          height: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Strings.selectedPlayers,
                style: Styles.caption.copyWith(fontSize: 19),
              ),
              const SizedBox(height: 8),
              HorizontalUserProfileList(
                profiles: selectedPlayers.value.toList(),
                onProfileSelected: removeUser,
              ),
              const Spacer(),
              Text(
                Strings.allPlayers,
                style: Styles.caption.copyWith(fontSize: 19),
              ),
              const SizedBox(height: 24),
              HorizontalUserProfileList(
                profiles: possiblePlayers
                    .where((u) => !selectedPlayers.value.contains(u))
                    .toList(),
                onProfileSelected: selectPlayer,
              ),
              _buildInviteByLinkButton(inviteByLink),
              const SizedBox(height: 8),
              _buildCreateRoomButton(createRoom),
              const SizedBox(height: 8),
              _buildBackButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInviteByLinkButton(VoidCallback inviteByLink) {
    return Container(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.inviteByLink,
        onPressed: inviteByLink,
        color: ColorRes.white,
      ),
    );
  }

  Widget _buildCreateRoomButton(VoidCallback createRoom) {
    return Container(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.createRoom,
        onPressed: createRoom,
        color: ColorRes.white,
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      height: 50,
      width: 200,
      child: ColorButton(
        text: Strings.goBack,
        onPressed: appRouter.goBack,
        color: ColorRes.yellow,
      ),
    );
  }
}
