import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/ui/stock_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/chart/stock/chart/chart_widget.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_content.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/game_event_selector/game_event_selector_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StockGameEvent extends HookWidget {
  const StockGameEvent(this.event);

  final GameEvent event;

  StockEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final buySellAction = useState(const BuySellAction.buy());
    final selectedCount = useState(1);
    final infoTableData = useStockInfoTableData(event);
    final isQuest = useIsQuestGame();
    final sendPlayerAction = useStockPlayerActionHandler(
      event: event,
      selectedCount: selectedCount.value,
      action: buySellAction.value,
    );
    final skipPlayerAction = useSkipAction(event.id);

    final userId = useUserId();
    final cash = useCurrentGame((g) => g.participants[userId].account.cash);
    final alreadyHaveCount = useCurrentStock(event)?.countInPortfolio ?? 0;

    final stockDialogInfoModel = useStockInfoDialogModel();

    final selectorViewModel = SelectorViewModel(
      currentPrice: eventData.currentPrice,
      alreadyHave: alreadyHaveCount,
      maxCount: eventData.availableCount,
      changeableType: true,
      availableCash: cash,
    );

    return Column(
      children: <Widget>[
        InfoTable(
          title: '${event.name}',
          subtitle: Strings.stock,
          image: event.image ?? Images.eventStock,
          withShadow: false,
          rows: <Widget>[
            if (!isQuest)
              ChartWidget(
                candles: eventData.candles,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                backgroundColor: ColorRes.transparent,
              ),
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
          onInfoClick: () {
            AnalyticsSender.infoButtonClick(stockDialogInfoModel.title);

            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      stockDialogInfoModel.title,
                      style: Styles.tableHeaderTitleBlack,
                    ),
                  ),
                  content: GameEventInfoDialogContent(stockDialogInfoModel),
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
            AnalyticsSender.buySellStock(
              buySellAction.value,
              selectedCount.value,
              event.name,
              eventData.currentPrice,
            );
          },
          skip: () {
            skipPlayerAction();

            AnalyticsSender.skipBuySellStock(
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
