import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class UserWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();
    final screenSize = useScreenSize();

    if (user?.fullName == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        UserAvatar(url: user!.avatarUrl),
        const SizedBox(width: 12),
        Container(
          constraints: BoxConstraints(maxWidth: screenSize.width * 0.8),
          child: Text(
            '${user.fullName}',
            style: Styles.body1,
            overflow: TextOverflow.fade,
            maxLines: 2,
          ),
        )
      ],
    );
  }
}
