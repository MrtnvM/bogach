import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/new_game/single_game_page.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/models/domain/game_context.dart';
import 'package:cash_flow/models/state/user/current_user.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/game_board.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
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
        appBar: CashAppBar(
          title: null,
          backgroundColor: ColorRes.mainGreen,
          elevation: 0,
        ),
        body: _buildBody(user),
      ),
    );
  }

  Widget _buildBody(CurrentUser user) {
    return Container(
      color: ColorRes.mainGreen,
      padding: const EdgeInsets.only(top: 80, left: 32, right: 32),
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return Column(
              children: <Widget>[
                _buildUserInfo(user),
                _buildGameActions(user),
              ],
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildUserInfo(CurrentUser user) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Welcome, ${user.fullName}'),
        const SizedBox(height: 16),
        ControlPanelGate(child: UserAvatar(url: user.avatarUrl)),
        const SizedBox(height: 16),
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
          onPressed: () => appRouter.goTo(
            GameBoard(
              gameContext: GameContext(
                gameId: '669f786f-fb51-46c4-8896-d9ae7dffa576',
                userId: user.userId,
              ),
            ),
          ),
          text: Strings.continueGame,
        )
      ],
    );
  }
}
