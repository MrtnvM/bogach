import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/models/state/user/current_user.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/game_board.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          title: const Text('Main page'),
          backgroundColor: ColorRes.primary,
        ),
        body: _buildBody(user),
      ),
    );
  }

  Widget _buildBody(CurrentUser user) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Column(
              children: <Widget>[
                Text('Welcome, ${user.fullName}'),
                FlatButton(
                  onPressed: () => appRouter.goTo(GameBoard()),
                  child: const Text('Go to GameBoard'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
