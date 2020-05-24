import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/models/domain/user/current_user.dart';
import 'package:cash_flow/presentation/continue_game/continue_game_page.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/new_game/single_game_page.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/buttons/text_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();

    return CashFlowScaffold(
      title: Strings.chooseGame,
      footerImage: Images.homeImage,
      showUser: true,
      child: Column(
        children: <Widget>[
          _buildGameActions(context),
          _buildAuthButton(user),
        ],
      ),
    );
  }

  Widget _buildGameActions(BuildContext context) {
    return Column(
      children: <Widget>[
        ColorButton(
          onPressed: () => appRouter.goTo(SingleGamePage()),
          text: Strings.singleGame,
        ),
        const SizedBox(height: 24),
        ColorButton(
          onPressed: () => showNotImplementedDialog(context),
          text: Strings.multiPlayerGame,
        ),
        const SizedBox(height: 24),
        ColorButton(
          onPressed: () => appRouter.goTo(ContinueGamePage()),
          text: Strings.continueGame,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAuthButton(CurrentUser user) {
    if (user == null) {
      return TextButton(
        onPressed: _goToLogin,
        text: Strings.doYouWantToLogin,
      );
    }

    return Container();
  }

  void _goToLogin() {
    appRouter.startWith(const LoginPage());
  }
}
