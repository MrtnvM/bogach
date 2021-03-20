import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultiplayerProfile {
  MultiplayerProfile({
    @required this.userId,
    @required this.avatarUrl,
    @required this.userName,
    @required this.isOnline,
  });

  final String userId;
  final String avatarUrl;
  final String userName;
  final bool isOnline;
}

class MultiplayerProfileWidget extends HookWidget {
  const MultiplayerProfileWidget({
    Key key,
    @required this.profile,
    @required this.isSelected,
    @required this.onTap,
  })  : assert(profile != null),
        super(key: key);

  final MultiplayerProfile profile;
  final Function(String) onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final avatarSize = size(60);

    return GestureDetector(
      onTap: () => onTap?.call(profile.userId),
      child: SizedBox(
        width: avatarSize,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: avatarSize,
              height: avatarSize,
              child: Stack(
                children: [
                  UserAvatar(
                    url: profile.avatarUrl,
                    size: avatarSize,
                    borderWidth: size(2.5),
                    borderColor: profile.isOnline //
                        ? ColorRes.onlineStatus
                        : ColorRes.grey,
                  ),
                  if (isSelected) const _SelectedProfileIcon(),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    profile.userName,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: Styles.bodyBlack.copyWith(
                      fontSize: size(11),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedProfileIcon extends HookWidget {
  const _SelectedProfileIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final checkIconSize = size(20);

    return Positioned(
      right: 0,
      child: Container(
        width: checkIconSize,
        height: checkIconSize,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: ColorRes.mainGreen.withAlpha(100),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(checkIconSize / 2),
        ),
        child: Icon(
          Icons.check,
          color: ColorRes.mainGreen,
          size: checkIconSize * 0.7,
        ),
      ),
    );
  }
}
