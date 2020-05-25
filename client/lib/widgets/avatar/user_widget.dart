import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class UserWidget extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();

    if (user?.fullName == null) {
      return Container();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        UserAvatar(url: user.avatarUrl),
        const SizedBox(width: 12),
        Text('${user.fullName}', style: Styles.body1)
      ],
    );
  }
}
