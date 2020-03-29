import 'package:cash_flow/presentation/new_gameboard/widgets/passesion_buttons.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/appbar/app_bar.dart';
import 'package:flutter/material.dart';

class NewGameBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CashAppBar(
        title: const Text('New Gameboard'),
        backgroundColor: ColorRes.primary,
      ),
      body: Container(
        color: ColorRes.newGameBoardHeaderBackground,
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0),
        child: PassessionButtons(),
      ),
    );
  }
}
