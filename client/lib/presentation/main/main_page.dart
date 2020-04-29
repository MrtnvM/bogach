import 'package:cash_flow/presentation/new_game/single_game_page.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/game_board.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:cash_flow/widgets/texts/title_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage();

  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CashAppBar(
        title: null,
        backgroundColor: ColorRes.darkBlue,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      color: ColorRes.darkBlue,
      padding: const EdgeInsets.only(top: 80, left: 32, right: 32),
      child: Column(
        children: <Widget>[
          const TitleText(Strings.chooseGame),
          const SizedBox(height: 24),
          ColorButton(
            onPressed: () => appRouter.goTo(SingleGamePage()),
            text: Strings.singleGame,
          ),
          const SizedBox(height: 24),
          ColorButton(
            onPressed: () => appRouter.goTo(GameBoard()),
            text: Strings.multiPlayerGame,
          ),
          const SizedBox(height: 24),
          ColorButton(
            onPressed: () => appRouter.goTo(GameBoard()),
            text: Strings.continueGame,
          ),
        ],
      ),
    );
  }
}
