import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WindfallIncomeGameEvent extends StatefulWidget {
  const WindfallIncomeGameEvent(this.viewModel) : assert(viewModel != null);

  final WindfallIncomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return WindfallIncomeGameEventState();
  }
}

class WindfallIncomeGameEventState extends State<WindfallIncomeGameEvent> {
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
                Icons.mood,
                color: ColorRes.white,
              ),
              const SizedBox(width: 12),
              Text(
                Strings.windfallIncomeTitle.toUpperCase(),
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
                Strings.windfallIncomeDesc,
                style: Styles.body2,
              ),
              const SizedBox(height: 8),
              _buildInfo(widget.viewModel),
              const EventButtons.skip(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildInfo(WindfallIncomeViewModel viewModel) {
    final map = {
      Strings.windfallIncome: viewModel.income.toPrice(),
    };

    return InfoTable(map);
  }
}

class WindfallIncomeViewModel {
  const WindfallIncomeViewModel({
    this.income,
  });

  final int income;
}
