import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/indicators_table.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LiabilitiesList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final liabilities = useCurrentGame(
      (g) => g.possessionState[userId].incomes,
    );

    final totalLiability = liabilities.fold<double>(0.0, (s, i) => s + i.value);

    return IndicatorsTable(
      context: context,
      name: Strings.liabilities,
      result: totalLiability.toPrice(),
      rows: [
        for (var liability in liabilities)
          RowItem(name: liability.name, value: liability.value.toPrice())
      ],
    );
  }
}
