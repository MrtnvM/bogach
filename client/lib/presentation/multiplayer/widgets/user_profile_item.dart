import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';

class UserProfileItem extends StatelessWidget {
  const UserProfileItem(
    this.profile, {
    Key key,
    this.titleColor,
  }) : super(key: key);

  final UserProfile profile;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(profile.userId),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      width: 80,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          UserAvatar(url: profile.avatarUrl, size: 52),
          const SizedBox(height: 8),
          Text(
            profile.fullName,
            style: Styles.body1.copyWith(fontSize: 13, color: titleColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
