import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class MonthResultCard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final userId = useUserId();
    final month = useCurrentGame((g) => g.state.monthNumber);
    final monthResults = useCurrentGame(
      (g) => g.state.participantsProgress[userId].monthResults,
    );

    final cash =
        monthResults['${month - 1}'].cash - monthResults['${month - 2}'].cash;

    return InfoTable(
      title: Strings.monthResult,
      titleValue: '',
      rows: [
        TitleRow(title: Strings.financialResults, value: null),
        TitleRow(title: Strings.incomes, value: cash.toPrice()),
      ],
    );
  }
}
