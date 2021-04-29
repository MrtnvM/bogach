import 'dart:collection';

import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:cash_flow/widgets/containers/info_table.dart';
import 'package:cash_flow/widgets/events/game_event_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WindfallIncomeGameEvent extends StatefulWidget {
  const WindfallIncomeGameEvent(this.viewModel);

  final WindfallIncomeViewModel viewModel;

  @override
  State<StatefulWidget> createState() {
    return WindfallIncomeGameEventState();
  }
}

class WindfallIncomeGameEventState extends State<WindfallIncomeGameEvent> {
  @override
  Widget build(BuildContext context) {
    return GameEventWidget(
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

    return InfoTable(LinkedHashMap.from(map));
  }

  Widget _buildDescription() {
    return const Text(
      Strings.windfallIncomeDesc,
      style: Styles.body2,
    );
  }
}

class WindfallIncomeViewModel {
  const WindfallIncomeViewModel({
    required this.income,
    required this.buttonsProperties,
  });

  final int income;
  final ButtonsProperties buttonsProperties;
}
