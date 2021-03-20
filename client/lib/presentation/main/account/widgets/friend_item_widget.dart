import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/profile/actions/remove_from_friends_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer/shimmer.dart';

class FriendItemWidget extends HookWidget {
  const FriendItemWidget({@required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: _buildName(),
      leading: _buildAvatar(size(48)),
      trailing: _buildOptionsButton(),
    );
  }

  Widget _buildName() {
    if (user == null) {
      return Shimmer.fromColors(
        baseColor: ColorRes.shimmerBaseColor,
        highlightColor: ColorRes.shimmerHightlightColor,
        child: Container(height: 24, width: 100, color: Colors.black),
      );
    }

    return Text(
      user.fullName,
      style: Styles.friendName,
      maxLines: 1,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildAvatar(double size) {
    if (user == null) {
      return Shimmer.fromColors(
        baseColor: ColorRes.shimmerBaseColor,
        highlightColor: ColorRes.shimmerHightlightColor,
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size / 2),
            color: Colors.black,
          ),
        ),
      );
    }

    return UserAvatar(
      url: user.avatarUrl,
      size: size,
      borderColor: user.isOnline ? ColorRes.mainGreen : ColorRes.transparent,
    );
  }

  Widget _buildOptionsButton() {
    if (user == null) {
      return const SizedBox();
    }

    return _OptionsButton(user: user);
  }
}

class _OptionsButton extends HookWidget {
  const _OptionsButton({Key key, @required this.user}) : super(key: key);

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();
    final size = useAdaptiveSize();
    final optionsButtonSize = size(32);

    final void Function(String) removeFromFriends = (id) {
      dispatch(RemoveFromFriendsAciton(id)).catchError(
        (error) => handleError(
          context: context,
          exception: error,
        ),
      );
    };

    return InkWell(
      borderRadius: BorderRadius.circular(optionsButtonSize / 2),
      onTap: () => _showFriendActions(
        context,
        removeFromFriends: () => removeFromFriends(user.id),
      ),
      child: SizedBox(
        height: optionsButtonSize,
        width: optionsButtonSize,
        child: Icon(Icons.more_vert, color: Colors.black.withAlpha(180)),
      ),
    );
  }

  void _showFriendActions(
    BuildContext context, {
    @required VoidCallback removeFromFriends,
  }) {
    if (user == null) {
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              UserAvatar(
                url: user.avatarUrl,
                size: 48,
                borderColor: ColorRes.transparent,
              ),
              const SizedBox(height: 8),
              Text(user.fullName, style: Styles.bodyBlackBold),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  removeFromFriends();
                  appRouter.goBack();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.remove, color: Colors.red),
                    const SizedBox(width: 4),
                    Text(
                      Strings.removeFromFriends,
                      style: Styles.bodyBlack.copyWith(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              FlatButton(
                onPressed: appRouter.goBack,
                child: Text(
                  Strings.cancel,
                  style: Styles.bodyBlack.copyWith(
                    fontSize: 13,
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
