import 'package:cash_flow/models/domain/user/current_user.dart';
import 'package:cash_flow/presentation/continue_game/continue_game_page.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/new_game/single_game_page.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/buttons/text_button.dart';
import 'package:cash_flow/widgets/texts/title_test.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_control_panel/control_panel.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> with ReduxState {
  @override
  Widget build(BuildContext context) {
    return AppStateConnector<CurrentUser>(
      converter: (s) => s.login.currentUser,
      builder: (context, user) => Scaffold(
        backgroundColor: ColorRes.mainGreen,
        body: _buildBody(user),
      ),
    );
  }

  Widget _buildBody(CurrentUser user) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.only(top: 32, left: 32, right: 32),
        child: Column(
          children: <Widget>[
            _buildHeader(user),
            _buildGameActions(user),
            _buildAuthButton(user),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(CurrentUser user) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildUser(user),
        const SizedBox(height: 24),
        const TitleText(Strings.chooseGame),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGameActions(CurrentUser user) {
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
    if (user?.fullName == null) {
      return TextButton(
        onPressed: _goToLogin,
        text: Strings.doYouWantToLogin,
      );
    }
    return const SizedBox(height: 0);
  }

  Widget _buildUser(CurrentUser user) {
    if (user?.fullName == null) {
      return const SizedBox(height: 32);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        UserAvatar(url: user.avatarUrl),
        const SizedBox(width: 12),
        Text(
          '${user.fullName}',
          style: Styles.body1,
        )
      ],
    );
  }

  Widget _buildImage() {
    return Expanded(
      child: Center(
        child: ControlPanelGate(
          child: Image.asset(
            Images.homeImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  void _goToLogin() {
    appRouter.startWith(const LoginPage());
  }
}
