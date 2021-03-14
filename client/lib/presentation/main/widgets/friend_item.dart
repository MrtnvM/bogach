import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendItem extends StatelessWidget {
  const FriendItem({@required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      title: Text(
        user.fullName,
        style: Styles.friendName,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      leading: UserAvatar(
        url: user.avatarUrl,
        size: 55,
        borderColor: user.isOnline ? ColorRes.mainGreen : ColorRes.transparent,
      ),
    );
  }
}
