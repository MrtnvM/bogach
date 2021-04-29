import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/models/real_estate_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/real_estate/ui/real_estate_buy_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_content.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RealEstateBuyGameEvent extends HookWidget {
  const RealEstateBuyGameEvent(this.event) : assert(event != null);

  final GameEvent event;
  RealEstateBuyEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final infoTableData = useRealEstateBuyInfoTableData(event);
    final sendPlayerAction = useRealEstateBuyPlayerActionHandler(event);
    final skipPlayerAction = useSkipAction(event.id);
    final realEstateDialogInfoModel = useRealEstateInfoDialogModel();

    return Column(
      children: <Widget>[
        InfoTable(
          title: Strings.property,
          subtitle: Strings.realty,
          image: Images.eventRealEstate,
          withShadow: false,
          rows: <Widget>[
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
          onInfoClick: () {
            AnalyticsSender.infoButtonClick(realEstateDialogInfoModel.title);

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      realEstateDialogInfoModel.title,
                      style: Styles.tableHeaderTitleBlack,
                    ),
                  ),
                  content: GameEventInfoDialogContent(
                    realEstateDialogInfoModel,
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 28),
        PlayerActionBar(
          confirm: () {
            sendPlayerAction();
            AnalyticsSender.buyRealEstate(
              event.name,
              eventData.currentPrice,
            );
          },
          skip: () {
            skipPlayerAction();

            AnalyticsSender.skipBuyRealEstate(
              event.name,
              eventData.currentPrice,
            );
          },
        )
      ],
    );
  }
}
