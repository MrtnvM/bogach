import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MonthlyIncomeInfoWidget extends HookWidget {
  const MonthlyIncomeInfoWidget({
    required this.selectedAction,
    required this.monthlyIncome,
  });

  final BuySellAction selectedAction;
  final double monthlyIncome;

  @override
  Widget build(BuildContext context) {
    final sign = monthlyIncome == 0
        ? ''
        : selectedAction == const BuySellAction.buy()
            ? '+'
            : '-';

    return Row(
      children: [
        Expanded(
          child: Text(
            Strings.incomePerMonth,
            style: Styles.infoBlockValue.copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          '$sign${monthlyIncome.toPriceWithoutSymbol()}',
          style: Styles.infoBlockValue.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
        Text(
          ' ${Strings.rubleSymbol}',
          style: Styles.infoBlockDescription.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
