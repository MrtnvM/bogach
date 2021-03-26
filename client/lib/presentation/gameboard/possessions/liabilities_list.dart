import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/detail_row.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LiabilitiesList extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final liabilities = useCurrentGame(
      (g) => g.participants[userId].possessionState.liabilities,
    );

    final totalLiability = liabilities.fold<double>(0.0, (s, i) => s + i.value);

    return InfoTable(
      title: Strings.liabilities,
      titleValue: totalLiability.toPrice(),
      titleTextStyle: Styles.tableHeaderTitleBlack,
      titleValueStyle: Styles.tableHeaderValueBlack,
      rows: [
        for (final liability in liabilities)
          DetailRow(
            title: liability.name,
            value: liability.value.toPrice(),
            details: [
              '${Strings.monthlyPayment} ${liability.monthlyPayment.toPrice()}',
            ],
          )
      ],
    );
  }
}
