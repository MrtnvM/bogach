import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/profile/actions/logout_action.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:cash_flow/widgets/containers/badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class ProfileBadge extends HookWidget {
  const ProfileBadge({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();

    return Badge(
      onTap: () => _showProfileActions(context, user),
      imageWidget: UserAvatar(url: user.avatarUrl, size: 24, borderWidth: 1),
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${user.fullName}',
            style: Styles.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileActions(BuildContext context, UserProfile user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorRes.mainGreen,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(url: user.avatarUrl, size: 48, borderWidth: 1),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    user.fullName,
                    textAlign: TextAlign.center,
                    style: Styles.bodyWhiteBold14,
                  ),
                ),
              ],
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Divider(height: 1, color: Colors.white30),
            const SizedBox(height: 16),
            _buildProfileActionButton(
              title: Strings.logout,
              textColor: ColorRes.red,
              action: () => _logout(context),
            ),
            const SizedBox(height: 12),
            _buildProfileActionButton(
              title: Strings.cancel,
              textColor: ColorRes.black.withAlpha(180),
              action: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileActionButton({
    String title,
    VoidCallback action,
    Color textColor,
  }) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onPressed: action,
        child: Text(
          title,
          style: Styles.body1.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    context
        .dispatch(StopListeningProfileUpdatesAction())
        .then((value) => context.dispatch(LogoutAction()))
        .then((_) => _onLogoutFinished())
        .catchError((_) => _onLogoutFinished());
  }

  void _onLogoutFinished() {
    appRouter.startWith(LoginPage());
  }
}
