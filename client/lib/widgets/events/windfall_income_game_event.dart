import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event.dart';
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
    return GameEvent(
      icon: Icons.mood,
      name: Strings.windfallIncomeTitle,
      buttonsState: ButtonsState.skip,
      buttonsProperties: widget.viewModel.buttonsProperties,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildDescription(),
            const SizedBox(height: 8),
            _buildInfo(widget.viewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(WindfallIncomeViewModel viewModel) {
    final map = {
      Strings.windfallIncome: viewModel.income.toPrice(),
    };

    return InfoTable(map);
  }

  Widget _buildDescription() {
    return Text(
      Strings.windfallIncomeDesc,
      style: Styles.body2,
    );
  }
}

class WindfallIncomeViewModel {
  const WindfallIncomeViewModel({
    this.income,
    this.buttonsProperties,
  });

  final int income;
  final ButtonsProperties buttonsProperties;
}
