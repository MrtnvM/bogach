import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/config/actions/load_config_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/login/login_page.dart';
import 'package:cash_flow/presentation/multiplayer/create_multiplayer_game_page.dart';
import 'package:cash_flow/presentation/new_game/single_game_page.dart';
import 'package:cash_flow/presentation/quests/quests_page.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/buttons/text_button.dart';
import 'package:cash_flow/widgets/containers/cash_flow_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter_hooks/flutter_hooks.dart';

class MainPage extends HookWidget {
  const MainPage();

  @override
  Widget build(BuildContext context) {
    final user = useCurrentUser();
    final needAuthorization = user == null;
    final dispatch = useDispatcher();

    useEffect(() {
      dispatch(LoadConfigAction());
      return null;
    }, []);

    useEffect(() {
      AnalyticsSender.setUserId(user.userId);
      return null;
    }, [user]);

    return CashFlowScaffold(
      title: Strings.chooseGame,
      footerImage: Images.homeImage,
      showUser: true,
      child: Column(
        children: <Widget>[
          _buildGameActions(context),
          _buildAuthButton(needAuthorization),
        ],
      ),
    );
  }

  Widget _buildGameActions(BuildContext context) {
    return Column(
      children: <Widget>[
        ColorButton(
          onPressed: () {
            appRouter.goTo(SingleGamePage());
            AnalyticsSender.singleplayerPageOpen();
          },
          text: Strings.singleGame,
        ),
        const SizedBox(height: 24),
        ColorButton(
          onPressed: () => appRouter.goTo(QuestsPage()),
          text: Strings.gameLevels,
        ),
        const SizedBox(height: 24),
        ColorButton(
          onPressed: () {
            appRouter.goTo(CreateMultiplayerGamePage());
            AnalyticsSender.multiplayerLevelsPageOpen();
          },
          text: Strings.multiPlayerGame,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAuthButton(bool needAuthorization) {
    if (needAuthorization) {
      return TextButton(
        onPressed: _goToLogin,
        text: Strings.doYouWantToLogin,
      );
    }

    return Container();
  }

  void _goToLogin() {
    appRouter.startWith(LoginPage());
  }
}
