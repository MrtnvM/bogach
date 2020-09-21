import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/presentation/multiplayer/widgets/user_profile_item.dart';
import 'package:flutter/material.dart';

class HorizontalUserProfileList extends StatelessWidget {
  const HorizontalUserProfileList({
    @required this.profiles,
    @required this.onProfileSelected,
    Key key,
  }) : super(key: key);

  final List<UserProfile> profiles;
  final void Function(UserProfile) onProfileSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: profiles.length,
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () => onProfileSelected(profiles[i]),
            child: UserProfileItem(profiles[i]),
          );
        },
      ),
    );
  }
}
