import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/app_configuration.dart';
import 'package:cash_flow/features/config/config_hooks.dart';
import 'package:cash_flow/features/profile/actions/logout_action.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/main/widgets/online_status.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ProfileBar extends HookWidget {
  const ProfileBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlineStatus = useOnlineStatus();
    final user = useCurrentUser().copyWith(
      status: onlineStatus.description,
    );

    return ControlPanelGate(
      isEnabled: AppConfiguration.controlPanelEnabled,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.grey.withAlpha(100),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            UserAvatar(
              url: user.avatarUrl,
              size: 60,
              borderWidth: 2.5,
              borderColor: onlineStatus.color,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${user.fullName}',
                    style: Styles.body1.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  if (user.status != null)
                    Text(
                      '${user.status}',
                      style: Styles.body1.copyWith(
                        color: Colors.black.withAlpha(170),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                ],
              ),
            ),
            const OnlineStatus(),
          ],
        ),
      ),
    );
  }

  // TODO(Maxim): Move logout feature to Account Tab
  void showProfileActions(BuildContext context, UserProfile user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: ColorRes.mainGreen,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            UserAvatar(url: user.avatarUrl, size: 48, borderWidth: 0),
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
