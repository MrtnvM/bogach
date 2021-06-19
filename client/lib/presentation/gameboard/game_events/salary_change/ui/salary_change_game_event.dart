import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/salary_change/models/salary_change_event_data.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SalaryChangeEvent extends HookWidget {
  const SalaryChangeEvent(this.event);

  final GameEvent event;

  SalaryChangeEventData get eventData => event.data as SalaryChangeEventData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InfoTable(
          title: event.name,
          subtitle: Strings.salaryChange,
          image: Images.eventSalaryChange,
          withShadow: false,
          description: event.description,
          rows: <Widget>[
            TitleRow(
              title: Strings.salaryChangeTitle,
              value: eventData.value.toPriceWithSign(),
            ),
          ],
        ),
      ],
    );
  }
}
