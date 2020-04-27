import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewBusinessGameEvent extends StatefulWidget {
  const NewBusinessGameEvent(this.viewModel) : assert(viewModel != null);

  final NewBusinessViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return NewBusinessGameEventState();
  }
}

class NewBusinessGameEventState extends State<NewBusinessGameEvent> {
  @override
  Widget build(BuildContext context) {
    return GameEvent(
      icon: Icons.business,
      name: Strings.newBusinessTitle,
      buttonsState: ButtonsState.normal,
      buttonsProperties: widget.viewModel.buttonsProperties,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildInfo(NewBusinessViewModel viewModel) {
    final map = {
      Strings.debt: viewModel.debt.toPrice(),
      Strings.passiveIncomePerMonth: viewModel.passiveIncomePerMonth.toPrice(),
      Strings.roi: viewModel.roi.toPercent(),
    };

    return InfoTable(map);
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildTitle(),
          const SizedBox(height: 8),
          _buildOfferedPrice(),
          const SizedBox(height: 8),
          _buildInfo(widget.viewModel),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return const Text(
      Strings.newBusinessDesc,
      style: Styles.body2,
    );
  }

  Widget _buildOfferedPrice() {
    return RichText(
      text: TextSpan(
        children: [
          const TextSpan(text: Strings.offeredPrice, style: Styles.body1),
          const WidgetSpan(
              child: SizedBox(
            width: 4,
          )),
          TextSpan(
              text: widget.viewModel.marketPrice.toPrice(),
              style: Styles.body2.copyWith(color: ColorRes.blue)),
        ],
      ),
    );
  }
}

class NewBusinessViewModel {
  const NewBusinessViewModel({
    this.debt,
    this.passiveIncomePerMonth,
    this.roi,
    this.marketPrice,
    this.buttonsProperties,
  });

  final int debt;
  final int passiveIncomePerMonth;
  final double roi;
  final int marketPrice;
  final ButtonsProperties buttonsProperties;
}
