import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AccountBar extends HookWidget {
  const AccountBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final account = useCurrentGame((g) => g.accounts[userId]);

    return Container(
      width: double.infinity,
      height: 35,
      color: ColorRes.primaryWhiteColor,
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildItem(
              title: '${Strings.cashFlowShort}',
              value: account.cashFlow,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildItem(
              title: '${Strings.cash}',
              value: account.cash,
            ),
          ),
          _buildDivider(),
          Expanded(
            child: _buildItem(
              title: '${Strings.credit}',
              value: account.credit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({String title, double value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          value.toPrice(),
          style: Styles.tableHeaderTitleBlack.copyWith(
            fontSize: 12,
          ),
        ),
        const Spacer(),
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
