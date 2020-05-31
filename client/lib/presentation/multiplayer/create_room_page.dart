import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CreateRoomPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final selectedPlayers = useState(<UserProfile>{});
    final possiblePlayers = useGlobalState(
      (s) => s.multiplayer.userProfiles.items
          .where((u) => u.fullName?.isNotEmpty == true)
          .where((u) => u.userId != userId)
          .toList(),
    );
    final multiplayerActions = useMultiplayerActions();

    useEffect(() {
      multiplayerActions.searchUsers('');
      return null;
    }, []);

    final selectPlayer = (player) {
      selectedPlayers.value = {...selectedPlayers.value, player};
    };

    final removeUser = (player) {
      selectedPlayers.value.remove(player);
      selectedPlayers.value = selectedPlayers.value.toSet();
    };

    return CashFlowScaffold(
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
            const SizedBox(height: 24),
            _buildPossiblePlayers(
              profiles: selectedPlayers.value.toList(),
              onProfileSelected: removeUser,
            ),
            const Spacer(),
            Text(
              Strings.allPlayers,
              style: Styles.caption.copyWith(fontSize: 19),
            ),
            const SizedBox(height: 24),
            _buildPossiblePlayers(
              profiles: possiblePlayers
                  .where((u) => !selectedPlayers.value.contains(u))
                  .toList(),
              onProfileSelected: selectPlayer,
            ),
            const SizedBox(height: 36),
            _buildBackButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPossiblePlayers({
    List<UserProfile> profiles,
    void Function(UserProfile) onProfileSelected,
  }) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: profiles.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => onProfileSelected(profiles[i]),
            child: _buildUserProfileItem(profiles[i]),
          );
        },
      ),
    );
  }

  Widget _buildUserProfileItem(UserProfile profile) {
    return Container(
      key: ValueKey(profile.userId),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          UserAvatar(url: profile.avatarUrl, size: 52),
          const SizedBox(height: 8),
          Text(
            profile.fullName,
            style: Styles.body1.copyWith(fontSize: 13),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
