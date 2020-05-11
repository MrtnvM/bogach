import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/continue_game/widgets/user_game_list.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/widgets/texts/title_test.dart';

class ContinueGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CashAppBar(
        title: const TitleText(Strings.continueGame),
        backgroundColor: ColorRes.mainGreen,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: ColorRes.mainGreen,
          child: UserGameList(),
        ),
        Positioned(
          bottom: 40,
          child: Container(
            height: 50,
            width: 200,
            child: ColorButton(
              text: Strings.goBack,
              onPressed: appRouter.goBack,
              color: ColorRes.yellow,
            ),
          ),
        )
      ],
    );
  }
}
