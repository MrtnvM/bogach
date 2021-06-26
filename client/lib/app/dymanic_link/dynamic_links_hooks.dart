import 'package:cash_flow/app/app_navigation_hooks/use_join_room.dart';
import 'package:cash_flow/app/link_actions/add_friend_hook.dart';
import 'package:cash_flow/core/hooks/dynamic_link_subscription_hook.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';

void useDynamicLinkHandler() {
  final joinRoom = useJoinRoom();
  final addFriend = useAddFriend();

  useDynamicLinkSubscription((dynamicLink) {
    final link = dynamicLink?.link;

    if (link == null) {
      return;
    }

    final query = link.query;

    Logger.i(
      'APP CAPTURED DYNAMIC LINK:\n$link\n'
      '${query.isNotEmpty ? "QUERY: $query" : ""}',
    );

    if (query.contains(DynamicLinks.roomInvite)) {
      final roomId = link.queryParameters[DynamicLinks.roomInvite];
      joinRoom(roomId);
      return;
    }

    if (query.contains(DynamicLinks.inviterId)) {
      final inviterId = link.queryParameters[DynamicLinks.inviterId];

      if (inviterId != null) {
        Logger.i('Inviter id: $inviterId');
        addFriend(inviterId);
      }
      return;
    }
  });
}
