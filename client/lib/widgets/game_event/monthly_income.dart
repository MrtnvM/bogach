import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';

class MonthlyIncomeWidget extends StatelessWidget {
  const MonthlyIncomeWidget({
    Key? key,
    this.assetCount,
    this.passiveIncomePerMonth,
    this.action,
  }) : super(key: key);

  final int? assetCount;
  final double? passiveIncomePerMonth;
  final BuySellAction? action;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final color = action!.map(
      buy: (_) => ColorRes.mainGreen,
      sell: (_) => ColorRes.mainRed,
    );

    final multiplier = action!.map(
      buy: (_) => 1,
      sell: (_) => -1,
    );

    return RichText(
      textScaleFactor: mediaQuery.textScaleFactor,
      text: TextSpan(
        children: [
          const TextSpan(text: Strings.incomePerMonth, style: Styles.bodyBlack),
          const WidgetSpan(child: SizedBox(width: 6)),
          TextSpan(
            text: (multiplier * assetCount! * passiveIncomePerMonth!).toPrice(),
            style: Styles.body1.copyWith(color: color),
          )
        ],
      ),
    );
  }
}
