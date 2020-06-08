import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MonthResultCard extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return InfoTable(
      title: Strings.monthResult,
      titleValue: '',
      rows: [
        TitleRow(title: Strings.financialResults, value: null),
      ],
    );
  }
}
