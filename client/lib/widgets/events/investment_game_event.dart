import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/event_selector.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InvestmentGameEvent extends StatefulWidget {
  const InvestmentGameEvent(this.viewModel);

  final InvestmentViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return InvestmentGameEventState();
  }
}

class InvestmentGameEventState extends State<InvestmentGameEvent> {
  @override
  Widget build(BuildContext context) {
    return GameEvent(
      icon: Icons.home,
      name: Strings.investments,
      buttonsState: ButtonsState.normal,
      buttonsProperties: widget.viewModel.buttonsProperties,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSellingPrice(),
          const SizedBox(height: 8),
          _buildInfo(widget.viewModel),
          _buildSelector(widget.viewModel),
        ],
      ),
    );
  }

  Widget _buildInfo(InvestmentViewModel viewModel) {
    final map = {
      Strings.investmentType: viewModel.type,
      Strings.nominalCost: viewModel.nominalCost.toPrice(),
      Strings.passiveIncomePerMonth: viewModel.passiveIncomePerMonth.toPrice(),
      Strings.roi: viewModel.roi.toPercent(),
      Strings.alreadyHave: viewModel.alreadyHave == 0
          ? viewModel.alreadyHave.toString()
          : Strings.getUserAvailableCount(
              viewModel.alreadyHave.toString(),
              viewModel.currentPrice.toPrice(),
            ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      child: InfoTable(map),
    );
  }

  Widget _buildSellingPrice() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: RichText(
        text: TextSpan(
          children: [
            const TextSpan(text: Strings.currentPrice, style: Styles.body1),
            const WidgetSpan(
              child: SizedBox(
                width: 4,
              ),
            ),
            TextSpan(
                text: widget.viewModel.currentPrice.toPrice(),
                style: Styles.body2.copyWith(color: ColorRes.blue)),
          ],
        ),
      ),
    );
  }

  Widget _buildSelector(InvestmentViewModel viewModel) {
    final selectorViewModel = SelectorViewModel(
      currentPrice: viewModel.currentPrice,
      passiveIncomePerMonth: viewModel.passiveIncomePerMonth,
      alreadyHave: viewModel.alreadyHave,
      maxCount: viewModel.maxCount,
      changeableType: true,
    );

    return GameEventSelector(selectorViewModel);
  }
}

class InvestmentViewModel {
  const InvestmentViewModel({
    this.currentPrice,
    this.type,
    this.nominalCost,
    this.passiveIncomePerMonth,
    this.roi,
    this.alreadyHave,
    this.maxCount,
    this.buttonsProperties,
  });

  final int currentPrice;
  final String type;
  final int nominalCost;
  final int passiveIncomePerMonth;
  final double roi;
  final int alreadyHave;
  final int maxCount;
  final ButtonsProperties buttonsProperties;
}
