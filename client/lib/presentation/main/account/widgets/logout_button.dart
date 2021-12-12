import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/features/profile/actions/logout_action.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/raised_icon_button.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedIconButton(
      onPressed: () => _logout(context),
      icon: Icons.logout,
      iconColor: ColorRes.red.withAlpha(200),
      buttonColor: ColorRes.transparent,
      size: 24,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            Strings.sureToGoOut,
            style: Styles.bodyBlackBold,
          ),
          actions: [
            TextButton(
              onPressed: appRouter.goBack,
              child: const Text(Strings.cancel),
            ),
            TextButton(
              onPressed: () {
                context
                    .dispatch(StopListeningProfileUpdatesAction())
                    .then((value) => context.dispatch(LogoutAction()))
                    .then((_) => _onLogoutFinished())
                    .onError((_, st) => _onLogoutFinished());
              },
              child: Text(
                Strings.goOut,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _onLogoutFinished() {
    AnalyticsSender.accountLogout();
    appRouter.startWith(LoginPage());
  }
}
