import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:cash_flow/widgets/common/empty_list_widget.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class OnlineProfilesList extends HookWidget {
  const OnlineProfilesList(this.selectedProfiles);

  final ValueNotifier<Set<String>> selectedProfiles;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final getOnlineRequestState = useGlobalState(
      (s) => s.getOperationState(Operation.setOnline),
    );

    final profiles = useGlobalState((s) {
      final onlineProfiles = s.multiplayer.onlineProfiles.map(
        (p) => _MultiplayerProfile(
          userId: p.userId,
          userName: p.fullName,
          avatarUrl: p.avatarUrl,
        ),
      );

      final onlineProfilesSet = onlineProfiles.map((p) => p.userId).toSet();
      final friends = (s.profile.currentUser?.friends ?? [])
          .where((id) => !onlineProfilesSet.contains(id))
          .map((id) => s.multiplayer.userProfiles.itemsMap[id])
          .where((p) => p != null)
          .map((p) => _MultiplayerProfile(
                userId: p.userId,
                userName: p.fullName,
                avatarUrl: p.avatarUrl,
              ));

      return [...onlineProfiles, ...friends];
    });

    return LoadableView(
      indicatorColor: const AlwaysStoppedAnimation<Color>(ColorRes.mainGreen),
      isLoading: getOnlineRequestState.isInProgress && profiles.isEmpty,
      child: profiles.isEmpty
          ? EmptyListWidget(Strings.noPlayers)
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: profiles.length,
              padding: EdgeInsets.only(left: size(20)),
              itemBuilder: (_, index) => _MultiplayerProfileWidget(
                key: ValueKey(profiles[index].userId),
                profile: profiles[index],
                onTap: (userId) {
                  final set = Set.of(selectedProfiles.value);

                  if (!set.remove(userId)) {
                    set.add(userId);
                  }

                  selectedProfiles.value = set;
                },
                isSelected:
                    selectedProfiles.value.contains(profiles[index].userId),
              ),
              separatorBuilder: (_, index) => SizedBox(width: size(16)),
            ),
    );
  }
}

class _MultiplayerProfile {
  _MultiplayerProfile({this.userId, this.avatarUrl, this.userName});

  final String userId;
  final String avatarUrl;
  final String userName;
}

class _MultiplayerProfileWidget extends HookWidget {
  const _MultiplayerProfileWidget({
    Key key,
    @required this.profile,
    @required this.onTap,
    @required this.isSelected,
  })  : assert(profile != null),
        super(key: key);

  final _MultiplayerProfile profile;
  final Function(String) onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return GestureDetector(
      onTap: () => onTap?.call(profile.userId),
      child: UserAvatar(
        url: profile.avatarUrl,
        size: size(60),
        borderWidth: isSelected ? size(2.5) : 0,
        borderColor: isSelected ? ColorRes.onlineStatus : ColorRes.transparent,
      ),
    );
  }
}
