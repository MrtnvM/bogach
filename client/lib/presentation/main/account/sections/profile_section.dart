import 'dart:io';

import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/main/account/widgets/friends_list_widget.dart';
import 'package:cash_flow/presentation/main/account/widgets/name_input.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/avatar/editable_user_avatar.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfileSection extends HookWidget {
  const ProfileSection({
    required this.onAvatarChanged,
    required this.onUsernameChanged,
  });

  final void Function(File?) onAvatarChanged;
  final void Function(String) onUsernameChanged;

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser()!;
    final size = useAdaptiveSize();
    final friends = useCurrentUserFriends();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SectionTitle(
          text: Strings.profileSectionTitle,
          padding: EdgeInsets.only(bottom: size(20), top: size(20)),
        ),
        Container(
          decoration: BoxDecoration(
            color: ColorRes.cardBackground,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: ColorRes.lightGrey),
            boxShadow: [BoxShadow(color: ColorRes.cardShadow, blurRadius: 2)],
          ),
          padding: EdgeInsets.all(size(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              EditableUserAvatar(
                url: user.avatarUrl,
                onChanged: onAvatarChanged,
                avatarSize: size(size(size(120))),
              ),
              SizedBox(height: size(24)),
              NameInput(
                initialValue: user.fullName,
                onChange: onUsernameChanged,
              ),
            ],
          ),
        ),
        SizedBox(height: size(32)),
        FriendsListWidget(friends: friends),
      ]),
    );
  }
}
