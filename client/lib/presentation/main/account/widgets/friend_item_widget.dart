import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FriendItemWidget extends HookWidget {
  const FriendItemWidget({@required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        user.fullName,
        style: Styles.friendName,
        maxLines: 1,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
      ),
      leading: UserAvatar(
        url: user.avatarUrl,
        size: size(48),
        borderColor: user.isOnline ? ColorRes.mainGreen : ColorRes.transparent,
      ),
    );
  }
}
