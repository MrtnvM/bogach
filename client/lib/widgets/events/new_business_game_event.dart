import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: ColorRes.grey,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.business,
                color: ColorRes.white,
              ),
              const SizedBox(width: 12),
              Text(
                Strings.newBusinessTitle.toUpperCase(),
                style: Styles.subhead.copyWith(color: ColorRes.white),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Strings.newBusinessDesc,
                style: Styles.body2,
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(text: Strings.offeredPrice, style: Styles.body1),
                    const WidgetSpan(
                        child: SizedBox(
                      width: 4,
                    )),
                    TextSpan(
                        text: widget.viewModel.marketPrice.toPrice(),
                        style: Styles.body2.copyWith(color: ColorRes.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildInfo(widget.viewModel),
              EventButtons(),
            ],
          ),
        )
      ],
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
}

class NewBusinessViewModel {
  const NewBusinessViewModel({
    this.debt,
    this.passiveIncomePerMonth,
    this.roi,
    this.marketPrice,
  });

  final int debt;
  final int passiveIncomePerMonth;
  final double roi;
  final int marketPrice;
}
