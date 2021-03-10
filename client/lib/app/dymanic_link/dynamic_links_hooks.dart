import 'package:cash_flow/app/app_action_hooks/use_join_room.dart';
import 'package:cash_flow/core/hooks/dynamic_link_subscription_hook.dart';
import 'package:cash_flow/resources/dynamic_links.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';

void useDynamicLinkHandler() {
  final joinRoom = useJoinRoom();

  useDynamicLinkSubscription((dynamicLink) {
    final link = dynamicLink.link;

    Logger.i('APP CAPTURE DYNAMIC LINK:\n$link\n'
        'APP CAPTURE DYNAMIC LINK QUERY:\n${link.query}');

    if (link == null) {
      return;
    }

    final query = link.query;

    if (query.contains(DynamicLinks.roomInvite)) {
      final roomId = link.queryParameters[DynamicLinks.roomInvite];
      joinRoom(roomId);
    }
  });
}
