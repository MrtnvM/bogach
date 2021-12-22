import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:cash_flow/widgets/containers/game_event_selector/game_event_selector_hook.dart';
import 'package:cash_flow/widgets/game_event/buy_sell_bar.dart';
import 'package:cash_flow/widgets/game_event/count_input.dart';
import 'package:cash_flow/widgets/game_event/monthly_income_info_widget.dart';
import 'package:cash_flow/widgets/game_event/total_info_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef OnPlayerActionParamsChanged = void Function(
  BuySellAction action,
  int selectedCount,
);

class GameEventSelectorWidget extends HookWidget {
  const GameEventSelectorWidget({
    required this.viewModel,
    required this.onPlayerActionParamsChanged,
    Key? key,
  }) : super(key: key);

  final SelectorViewModel viewModel;
  final OnPlayerActionParamsChanged onPlayerActionParamsChanged;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final hasValue = useState(false);
    final _selectedCount = useState(1);
    final _buySellAction = useState(const BuySellAction.buy());

    final hasMonthlyIncome =
        viewModel.changeableType && viewModel.passiveIncomePerMonth != 0;

    final selectorStateModel = normalizeSelectorState(
      currentAction: _buySellAction.value,
      selectedCount: _selectedCount.value,
      availableCash: viewModel.availableCash,
      maxCountToBuy: viewModel.maxCount!,
      currentPrice: viewModel.currentPrice!,
      alreadyHave: viewModel.alreadyHave!,
    );

    _selectedCount.value = selectorStateModel.selectedCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (viewModel.changeableType)
          BuySellBar(
            selectedAction: _buySellAction.value,
            onActionChanged: (action) {
              _selectedCount.value = 1;
              _buySellAction.value = action;
              onPlayerActionParamsChanged(action, _selectedCount.value);
            },
            canSell: selectorStateModel.canSell,
          ),
        CardContainer(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(6)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: <Widget>[
                CountInput(
                  selectedAction: _buySellAction.value,
                  availableCount:
                      _buySellAction.value == const BuySellAction.buy()
                          ? selectorStateModel.availableCount
                          : viewModel.alreadyHave!,
                  onCountChanged: (newCount, hasCountValue) {
                    hasValue.value = hasCountValue;
                    _selectedCount.value = newCount;

                    onPlayerActionParamsChanged(
                      _buySellAction.value,
                      _selectedCount.value,
                    );
                  },
                ),
                SizedBox(height: size(20)),
                if (hasMonthlyIncome) ...[
                  SizedBox(height: size(4)),
                  MonthlyIncomeInfoWidget(
                    selectedAction: _buySellAction.value,
                    monthlyIncome: hasValue.value
                        ? _selectedCount.value * viewModel.passiveIncomePerMonth
                        : 0,
                  ),
                  SizedBox(height: size(12)),
                  const Divider(color: ColorRes.divider, height: 0.5),
                  SizedBox(height: size(16)),
                ],
                TotalInfoWidget(
                  totalPrice: hasValue.value
                      ? _selectedCount.value * viewModel.currentPrice!
                      : 0,
                ),
                SizedBox(height: size(8)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SelectorViewModel {
  const SelectorViewModel({
    this.currentPrice,
    this.passiveIncomePerMonth = 0,
    this.alreadyHave,
    this.maxCount,
    this.changeableType = true,
    this.availableCash,
  });

  final double? currentPrice;
  final double passiveIncomePerMonth;
  final int? alreadyHave;
  final int? maxCount;
  final bool changeableType;
  final double? availableCash;
}
