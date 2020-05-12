import 'package:cash_flow/models/domain/game/account/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/action_button.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/bars/bottom_bar.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/investments_info.dart';
import 'package:cash_flow/presentation/new_gameboard/widgets/progress_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';

class NewGameBoard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final account = useCurrentGame((g) => g?.accounts[userId]);
    final target = useCurrentGame((g) => g?.target);
    final targetTitle = mapTargetTypeToString(target.type);

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    const imageAspectRatio = 2.03;
    final imageHeight = screenWidth / imageAspectRatio;
    final contentOffset = imageHeight * 0.76;

    final items = [
      BottomBarItem(title: 'Финансы', image: Images.financesBarIcon),
      BottomBarItem(title: 'Действия', image: Images.gameBoardBarIcon),
      BottomBarItem(title: 'История', image: Images.historyBarIcon),
    ];

    if (account == null || target == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: ColorRes.primaryWhiteColor,
      body: Stack(
        children: <Widget>[
          _buildHeaderImage(imageHeight),
          NavigationBar(title: targetTitle),
          Container(
            padding: EdgeInsets.only(top: contentOffset, left: 16, right: 16),
            child: _buildContent(account),
          ),
        ],
      ),
      bottomNavigationBar: BottomBar(items: items),
    );
  }

  Column _buildContent(Account account) {
    return Column(
      children: <Widget>[
        const ProgressBar(),
        const SizedBox(height: 16),
        const AccountBar(),
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
          alignment: Alignment.center,
          height: 46,
          child: Row(
            children: [
              Expanded(
                child: ActionButton(
                  color: Colors.orange,
                  text: 'Взять\nкредит',
                  maxLines: 2,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: ActionButton(
                  color: Colors.green,
                  text: 'Ок',
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: ActionButton(
                  color: Colors.grey,
                  text: 'Пропустить',
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _buildHeaderImage(double imageHeight) {
    return Container(
      color: ColorRes.primaryBackgroundColor,
      height: imageHeight,
      alignment: Alignment.bottomCenter,
      child: const Image(image: AssetImage(Images.money)),
    );
  }
}
