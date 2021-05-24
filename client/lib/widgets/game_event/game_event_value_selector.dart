import 'dart:math';

import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/game_event/monthly_income.dart';
import 'package:cash_flow/widgets/game_event/value_slider.dart';
import 'package:flutter/material.dart';

typedef OnCountChangedCallback = void Function(int count);

class GameEventValueSelector extends StatelessWidget {
  const GameEventValueSelector({
    required this.action,
    required this.selectedCount,
    required this.currentPrice,
    required this.availableCount,
    required this.maxCount,
    required this.minCount,
    required this.isChangeableType,
    required this.onCountChanged,
    required this.passiveIncomePerMonth,
    Key? key,
  })  : super(key: key);

  final BuySellAction action;
  final int selectedCount;
  final double currentPrice;
  final int availableCount;
  final int maxCount;
  final int minCount;
  final double passiveIncomePerMonth;
  final OnCountChangedCallback onCountChanged;
  final bool isChangeableType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ValueSlider(
          currentPrice: currentPrice,
          currentAction: action,
          selectedCount: selectedCount,
          maxCount: maxCount,
          minCount: minCount,
          onCountChanged: onCountChanged,
        ),
        if (isChangeableType && passiveIncomePerMonth != 0)
          MonthlyIncomeWidget(
            action: action,
            assetCount: selectedCount,
            passiveIncomePerMonth: passiveIncomePerMonth,
          ),
        const SizedBox(height: 10),
        const Divider(),
        _buildBuySellButtons(context),
      ],
    );
  }

  Widget _buildBuySellButtons(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: _buildAvailableButton(context)),
        Expanded(child: _buildSelectAllButton(context)),
      ],
    );
  }

  Widget _buildSelectAllButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final title = action.map(
      buy: (_) => Strings.buyAllAvailable,
      sell: (_) => Strings.sellAllAvailable,
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        action.when(buy: () {
          if (availableCount > 0) {
            onCountChanged(min(availableCount, maxCount));
          }
        }, sell: () {
          onCountChanged(availableCount);
        });
      },
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: RichText(
          textScaleFactor: mediaQuery.textScaleFactor,
          text: TextSpan(
            children: [
              TextSpan(
                text: title,
                style: Styles.body1.copyWith(
                  decoration: TextDecoration.underline,
                  color: ColorRes.mainGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvailableButton(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: RichText(
        textScaleFactor: mediaQuery.textScaleFactor,
        text: TextSpan(
          children: [
            TextSpan(
              text: Strings.available,
              style: Styles.body1.copyWith(
                color: ColorRes.black64,
              ),
            ),
            const WidgetSpan(child: SizedBox(width: 8)),
            TextSpan(
              text: availableCount.toStringAsFixed(0),
              style: Styles.bodyBlack,
            ),
          ],
        ),
      ),
    );
  }
}
