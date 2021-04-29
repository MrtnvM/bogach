import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/texts/animated_price.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountBar extends HookWidget {
  const AccountBar({Key key}) : super(key: key);

  static const height = 54.0;

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final account = useCurrentGame((g) => g.participants[userId].account);
    final previousAccount = usePrevious(account);
    final gameboardTutorial = useGameboardTutorial();

    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: ColorRes.primaryWhiteColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 8,
          )
        ],
      ),
      padding: const EdgeInsets.only(left: 16, right: 16),
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            key: gameboardTutorial?.cashFlowKey,
            child: _buildItem(
              title: '${Strings.cashFlowShort}',
              value: account.cashFlow,
              previousValue: previousAccount?.cashFlow ?? account.cashFlow,
            ),
          ),
          _buildDivider(),
          Expanded(
            key: gameboardTutorial?.cashKey,
            child: _buildItem(
              title: '${Strings.cash}',
              value: account.cash,
              previousValue: previousAccount?.cash ?? account.cashFlow,
            ),
          ),
          _buildDivider(),
          Expanded(
            key: gameboardTutorial?.creditKey,
            child: _buildItem(
              title: '${Strings.credit}',
              value: account.credit,
              previousValue: previousAccount?.credit ?? account.credit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    @required String title,
    @required double value,
    @required double previousValue,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        AnimatedPrice(
          begin: previousValue,
          end: value,
          duration: const Duration(milliseconds: 500),
          style: Styles.tableHeaderTitleBlack.copyWith(
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Styles.bodyBlack.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 30,
      color: ColorRes.newGameBoardConditionDividerColor,
    );
  }
}
