import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/game/actions/start_new_month_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/participant/month_result.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar_button.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/table_divider.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MonthResultWidget extends HookWidget {
  const MonthResultWidget();

  @override
  Widget build(BuildContext context) {
    final month = useCurrentGame((g) => g!.state.monthNumber);
    final ad = useGlobalState((s) => s.game.monthResultAds[month]);
    final size = useAdaptiveSize();

    final dispatch = useDispatcher();
    final gameContext = useCurrentGameContext();

    final startNewMonth = () => dispatch(StartNewMonthAction(gameContext))
        .catchError((e) => handleError(context: context, exception: e));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MonthResultCard(),
        SizedBox(height: size(24)),
        if (ad != null) ...[
          Container(
            height: 84,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            child: AdWidget(ad: ad as AdWithView),
          ),
          SizedBox(height: size(24)),
        ],
        ActionBarButton(
          text: Strings.continueGame,
          color: ColorRes.mainGreen,
          onPressed: startNewMonth,
        )
      ],
    );
  }
}

class MonthResultCard extends HookWidget {
  static const green = ColorRes.green;
  static const red = ColorRes.red;

  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final month = useCurrentGame((g) => g!.state.monthNumber)!;
    final monthResults = useCurrentGame(
      (g) => g!.participants[userId!]!.progress.monthResults,
    )!;
    final calculateChange = useMonthChangeCalculator();

    final currentResults = monthResults[month - 1];
    final cashFlow = currentResults.totalIncome - currentResults.totalExpense;

    return CardContainer(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          _buildHeader(),
          const SizedBox(height: 24),
          _buildSubtitle('${Strings.financialResults}:'),
          const TableDivider(),
          _buildItem(
            title: '${Strings.incomes}:',
            value: currentResults.totalIncome.toPrice(),
            color: green,
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.expenses}:',
            value: currentResults.totalExpense.toPrice(),
            color: red,
          ),
          _buildItemDivider(),
          _buildItem(
            title: '${Strings.total}:',
            value: cashFlow.toPrice(),
            color: cashFlow >= 0 ? green : red,
          ),
          ..._buildFinResultsChanges(calculateChange),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            Strings.monthResult,
            style: Styles.tableHeaderTitleBlue,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtitle(String subtitle) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(subtitle, style: Styles.bodyBlackSemibold),
    );
  }

  Widget _buildItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Column(
        children: <Widget>[
          Row(
            children: [
              Expanded(child: Text(title, style: Styles.bodyBlack)),
              Text(
                value,
                style: Styles.bodyBlackSemibold.copyWith(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemDivider() {
    return TableDivider(
      color: ColorRes.newGameBoardInvestmentsDividerColor.withAlpha(150),
    );
  }

  List<Widget> _buildFinResultsChanges(
    double calculateChange(double Function(MonthResult result) selector),
  ) {
    final cashChange = calculateChange((r) => r.cash);
    final incomeChange = calculateChange((r) => r.totalIncome);
    final expenseChange = calculateChange((r) => r.totalExpense);
    final assetsChange = calculateChange((r) => r.totalAssets);
    final liabilityChange = calculateChange((r) => r.totalLiabilities);

    final results = [
      if (_shouldDisplayValue(cashChange))
        _buildItem(
          title: '${Strings.cash}:',
          value: cashChange.toPercentWithSign(),
          color: _getValueColor(cashChange, shouldReverse: false),
        ),
      if (_shouldDisplayValue(incomeChange))
        _buildItem(
          title: '${Strings.incomes}:',
          value: incomeChange.toPercentWithSign(),
          color: _getValueColor(incomeChange, shouldReverse: false),
        ),
      if (_shouldDisplayValue(expenseChange))
        _buildItem(
          title: '${Strings.expenses}:',
          value: expenseChange.toPercentWithSign(),
          color: _getValueColor(expenseChange, shouldReverse: true),
        ),
      if (_shouldDisplayValue(assetsChange))
        _buildItem(
          title: '${Strings.assets}:',
          value: assetsChange.toPercentWithSign(),
          color: _getValueColor(assetsChange, shouldReverse: false),
        ),
      if (_shouldDisplayValue(liabilityChange))
        _buildItem(
          title: '${Strings.liabilities}:',
          value: liabilityChange.toPercentWithSign(),
          color: _getValueColor(liabilityChange, shouldReverse: true),
        ),
    ];

    if (results.isEmpty) {
      return [];
    }

    return [
      const TableDivider(),
      const SizedBox(height: 20),
      _buildSubtitle('${Strings.financialResultsChange}:'),
      const TableDivider(),
      for (int i = 0; i < results.length; i++) ...[
        results[i],
        if (i != results.length - 1) _buildItemDivider(),
      ],
    ];
  }

  Color _getValueColor(double value, {bool? shouldReverse}) {
    final isValueTooLow = double.parse(value.toStringAsFixed(1)) == 0.0;

    if (isValueTooLow || value.isNaN || value.isInfinite) {
      return ColorRes.mainBlack;
    }

    if (value > 0 && !shouldReverse! || value < 0 && shouldReverse!) {
      return green;
    }

    return red;
  }

  bool _shouldDisplayValue(double value) {
    if (value.isNaN || value.isInfinite) {
      return false;
    }

    final isValueTooLow = double.parse(value.toStringAsFixed(1)) == 0.0;
    return !isValueTooLow;
  }
}

double Function(double Function(MonthResult)) useMonthChangeCalculator() {
  final userId = useUserId();
  final month = useCurrentGame((g) => g!.state.monthNumber)!;
  final monthResults = useCurrentGame(
    (g) => g!.participants[userId!]!.progress.monthResults,
  )!;

  final previousResults = monthResults[month - 2];
  final currentResults = monthResults[month - 1];

  final calculateChange = (double Function(MonthResult result) selector) {
    final currentValue = selector(currentResults);
    final previousValue = selector(previousResults);
    final change = (currentValue - previousValue) / previousValue;
    return change * 100;
  };

  return calculateChange;
}
