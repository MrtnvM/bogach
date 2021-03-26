import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InviteFriendItemWidget extends HookWidget {
  const InviteFriendItemWidget({@required this.inviteFriend});

  final VoidCallback inviteFriend;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final avatarSize = size(48);

    return InkWell(
      onTap: inviteFriend,
      borderRadius: BorderRadius.circular(8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          Strings.inviteFriend,
          style: Styles.friendName,
          maxLines: 1,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
        ),
        leading: Container(
          height: avatarSize,
          width: avatarSize,
          // padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorRes.lightGrey,
            borderRadius: BorderRadius.circular(avatarSize / 2),
            border: Border.all(
              color: ColorRes.grey,
              width: 0.5,
            ),
          ),
          child: Icon(
            Icons.add,
            color: ColorRes.black,
            size: avatarSize * 0.4,
          ),
        ),
      ),
    );
  }
}
