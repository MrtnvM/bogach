import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
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
        title: const Text('Main page'),
        backgroundColor: ColorRes.primary,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Column(
                children: <Widget>[
                  const Text('Welcome!'),
                  FlatButton(
                    onPressed: () => appRouter.goTo(GameBoard()),
                    child: const Text('Go to GameBoard'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
