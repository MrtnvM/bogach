import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/models/insurance_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/insurance/ui/insurance_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_content.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class InsuranceGameEvent extends HookWidget {
  const InsuranceGameEvent(this.event);

  final GameEvent event;
  InsuranceEventData get eventData => event.data as InsuranceEventData;

  @override
  Widget build(BuildContext context) {
    final infoTableData = useInsuranceInfoTableData(event);
    final insuranceInfoDialogModel = useInsuranceInfoDialogModel();

    return Column(
      children: <Widget>[
        InfoTable(
          title: event.name,
          subtitle: Strings.insuranceTitle,
          image: Images.eventInsurance,
          description: event.description,
          withShadow: false,
          rows: <Widget>[
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
          onInfoClick: () {
            AnalyticsSender.infoButtonClick(insuranceInfoDialogModel.title);

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      insuranceInfoDialogModel.title,
                      style: Styles.tableHeaderTitleBlack,
                    ),
                  ),
                  content: GameEventInfoDialogContent(
                    insuranceInfoDialogModel,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
