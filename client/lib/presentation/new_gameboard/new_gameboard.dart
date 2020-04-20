import 'package:cash_flow/presentation/new_gameboard/widgets/condition.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/investments_info.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/progress_bar.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/stack_train.dart';
import 'package:cash_flow/resources/colors.dart';

import 'package:flutter/material.dart';

class NewGameBoard extends StatelessWidget {
  final Key backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    const imageAspectRatio = 2.03;
    final imageHeight = screenWidth / imageAspectRatio;
    final contentOffset = imageHeight * 0.76;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            constraints: const BoxConstraints.expand(),
            color: ColorRes.primaryWhiteColor,
          ),
          Container(
            color: ColorRes.primaryBackgroundColor,
            height: imageHeight,
            alignment: Alignment.bottomCenter,
            child: Image(
              key: backgroundImageKey,
              image: const AssetImage('assets/images/png/many_money.png'),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 60),
            alignment: Alignment.center,
            child: Column(
              children: const <Widget>[
                Text(
                  'Охранник',
                  style: TextStyle(
                    color: ColorRes.primaryYellowColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'уровень 3',
                  style: TextStyle(
                    color: ColorRes.levelColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w200,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: contentOffset, left: 16, right: 16),
            child: Column(
              children: <Widget>[
                const ProgressBar('20 000₽', '80 000₽'),
                const SizedBox(height: 16),
                const Condition('7 000₽', '100 000₽', '200 000₽'),
                const SizedBox(height: 20),
                const InvestmentsInfo(
                  currentPrice: '7 000₽',
                  name: 'Облигации',
                  nominalValue: '1 000₽',
                  passiveIncomePerNonth: '40₽',
                  roiPerYear: '60%',
                  inStock: '0',
                ),
                const SizedBox(height: 16),
                Container(
                  height: 46,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorRes.gameButtonColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5)),
                          ),
                          child: const Text('Купить'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
