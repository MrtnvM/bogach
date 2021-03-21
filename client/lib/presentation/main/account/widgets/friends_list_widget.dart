import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/multiplayer/actions/share_add_friend_link_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/presentation/main/account/widgets/friend_item_widget.dart';
import 'package:cash_flow/presentation/main/account/widgets/invite_friend_item_widget.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FriendsListWidget extends HookWidget {
  const FriendsListWidget({Key key, @required this.friends}) : super(key: key);

  final List<UserProfile> friends;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final inviteButtonSize = size(24);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            text: Strings.friends,
            padding: EdgeInsets.zero,
            actionWidget: friends.isNotEmpty
                ? _InviteButton(inviteButtonSize: inviteButtonSize, size: size)
                : null,
          ),
          const SizedBox(height: 4),
          const Divider(),
          const SizedBox(height: 4),
          if (friends.isEmpty)
            const InviteFriendItemWidget()
          else
            ...friends.map((item) => FriendItemWidget(user: item)).toList(),
        ],
      ),
    );
  }
}

class _InviteButton extends HookWidget {
  const _InviteButton({
    Key key,
    @required this.inviteButtonSize,
    @required this.size,
  }) : super(key: key);

  final double inviteButtonSize;
  final double Function(double p1) size;

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();

    final inviteFriend = () async {
      await dispatch(ShareAddFriendLinkAction());
      AnalyticsSender.accountInviteFriendLinkCreated();
    };

    return InkWell(
      onTap: inviteFriend,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: ColorRes.mainGreen.withAlpha(70),
          border: Border.all(color: ColorRes.mainGreen, width: 0.5),
          borderRadius: BorderRadius.circular(inviteButtonSize / 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: size(16)),
            SizedBox(width: size(3)),
            Text(
              Strings.invite,
              style: Styles.bodyBlack.copyWith(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
