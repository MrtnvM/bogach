import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/login/login_actions.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage();

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with ReduxState {
  @override
  void initState() {
    super.initState();

    _authUser();
  }

  @override
  Widget build(BuildContext context) {
    return AppStateConnector<bool>(
        converter: (s) => s.login.loginRequestState.isInProgress,
        builder: (context, isLoading) {
          return Scaffold(
            body: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('Cash Flow game!'),
                  if (isLoading) const SizedBox(width: 12),
                  if (isLoading) const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        });
  }

  void _authUser() {
    dispatchAsyncAction(LoginAsyncAction()).listen((action) => action
      ..onSuccess(_onSuccessLogin)
      ..onError(_onErrorLogin));
  }

  void _onSuccessLogin(_) {
    appRouter.goTo(const MainPage());
  }

  void _onErrorLogin(dynamic error) {
    handleError(
      context: context,
      exception: error,
      onRetry: _authUser,
      barrierDismissible: false,
      displayNegative: false,
    );
  }
}
