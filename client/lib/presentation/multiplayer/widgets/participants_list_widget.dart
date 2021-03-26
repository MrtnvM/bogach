import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/room/room_participant.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/presentation/multiplayer/room_page_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ParticipantListWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final room = useCurrentRoom();

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
