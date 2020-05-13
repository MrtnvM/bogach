import 'package:cash_flow/presentation/new_gameboard/widgets/bars/bottom_bar.dart';

import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart' hide Table;

import 'info_table.dart';

class FinancesBoard extends StatelessWidget {
  final Key backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    const imageAspectRatio = 2.03;
    final imageHeight = screenWidth / imageAspectRatio;
    final contentOffset = imageHeight * 0.21;

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
          ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 60, left: 16),
                    child: GestureDetector(
                      onTap: () {},
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorRes.primaryWhiteColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 60),
                    alignment: Alignment.center,
                    child: Text(
                      'Финансы',
                      style: TextStyle(
                        color: ColorRes.primaryYellowColor,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                        top: contentOffset, left: 16, right: 16),
                    child: const InfoTable(
                      title: 'Доходы',
                      titleValue: '1Р',
                      rows: [],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: const InfoTable(
                      title: 'Расходы',
                      titleValue: '1 000Р',
                      rows: [],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: const InfoTable(
                      title: 'Активы',
                      titleValue: '1 000Р',
                      rows: [],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 16, left: 16, right: 16),
                    child: const InfoTable(
                      title: 'Пассивы',
                      titleValue: '1 000Р',
                      rows: [],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
