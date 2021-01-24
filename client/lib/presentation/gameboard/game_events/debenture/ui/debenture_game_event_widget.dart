import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/ui/debenture_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_content.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/game_event_selector/game_event_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DebentureGameEventWidget extends HookWidget {
  const DebentureGameEventWidget({
    @required this.event,
    Key key,
  }) : super(key: key);
  final GameEvent event;

  DebentureEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final buySellAction = useState(const BuySellAction.buy());
    final selectedCount = useState(1);
    final infoTableData = useDebentureInfoTableData(event);
    final sendPlayerAction = useDebenturePlayerActionHandler(
      event: event,
      selectedCount: selectedCount.value,
      action: buySellAction.value,
    );

    final userId = useUserId();
    final cash = useCurrentGame((g) => g.participants[userId].account.cash);

    final alreadyHave = useCurrentDebenture(event)?.count ?? 0;
    final passiveIncomePerMonth =
        eventData.nominal * eventData.profitabilityPercent / 100 / 12;

    final debentureDialogInfoModel = useDebentureInfoDialogModel();

    final dispatch = useDispatcher();

    final selectorViewModel = SelectorViewModel(
      currentPrice: eventData.currentPrice,
      passiveIncomePerMonth: passiveIncomePerMonth,
      alreadyHave: alreadyHave,
      maxCount: eventData.availableCount,
      changeableType: true,
      availableCash: cash,
    );

    return Column(
      children: <Widget>[
        InfoTable(
          title: Strings.debentures,
          withShadow: false,
          rows: <Widget>[
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
          onInfoClick: () {
            AnalyticsSender.infoButtonClick(debentureDialogInfoModel.title);

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      debentureDialogInfoModel.title,
                      style: Styles.tableHeaderTitleBlack,
                    ),
                  ),
                  content: GameEventInfoDialogContent(debentureDialogInfoModel),
                );
              },
            );
          },
        ),
        const SizedBox(height: 24),
        GameEventSelectorWidget(
          key: ValueKey(event.id),
          viewModel: selectorViewModel,
          onPlayerActionParamsChanged: (action, count) {
            selectedCount.value = count;
            buySellAction.value = action;
          },
        ),
        const SizedBox(height: 28),
        PlayerActionBar(
          confirm: () {
            sendPlayerAction();
            AnalyticsSender.buySellDebenture(
              buySellAction.value,
              selectedCount.value,
              event.name,
              eventData.currentPrice,
            );
          },
          skip: () {
            dispatch(SendPlayerMoveAction(eventId: event.id));

            AnalyticsSender.skipBuySellDebenture(
              buySellAction.value,
              event.name,
              eventData.currentPrice,
            );
          },
        )
      ],
    );
  }
}
