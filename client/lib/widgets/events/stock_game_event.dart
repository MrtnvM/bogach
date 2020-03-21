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

class StockGameEvent extends StatefulWidget {
  const StockGameEvent(this.viewModel);

  final StockViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return StockGameEventState();
  }
}

class StockGameEventState extends State<StockGameEvent> {
  @override
  Widget build(BuildContext context) {
    return GameEvent(
      icon: Icons.home,
      name: Strings.stockMarketTitle,
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

  Widget _buildInfo(StockViewModel viewModel) {
    final map = {
      Strings.investmentType: Strings.stocks(viewModel.type),
      Strings.nominalCost: viewModel.nominalCost.toPrice(),
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
            TextSpan(text: Strings.currentPrice, style: Styles.body1),
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

  Widget _buildSelector(StockViewModel viewModel) {
    final selectorViewModel = SelectorViewModel(
      currentPrice: viewModel.currentPrice,
      alreadyHave: viewModel.alreadyHave,
      maxCount: viewModel.maxCount,
      changeableType: false,
    );

    return GameEventSelector(selectorViewModel);
  }
}

class StockViewModel {
  const StockViewModel({
    this.currentPrice,
    this.type,
    this.nominalCost,
    this.alreadyHave,
    this.maxCount,
    this.buttonsProperties,
  });

  final int currentPrice;
  final String type;
  final int nominalCost;
  final int alreadyHave;
  final int maxCount;
  final ButtonsProperties buttonsProperties;
}
