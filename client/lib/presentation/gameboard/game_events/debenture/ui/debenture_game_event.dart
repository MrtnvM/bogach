import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/ui/debenture_game_event_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/action_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/info_table.dart';
import 'package:cash_flow/presentation/gameboard/widgets/table/title_row.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/containers/game_event_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class DebentureGameEvent extends HookWidget {
  const DebentureGameEvent({Key key, @required this.event}) : super(key: key);
  final GameEvent event;

  DebentureEventData get eventData => event.data;

  @override
  Widget build(BuildContext context) {
    final buySellAction = useState(const BuySellAction.buy());
    final selectedCount = useState(0);
    final infoTableData = useDebentureInfoTableData(event);
    final gameActions = useGameActions();
    final sendPlayerAction = useDebenturePlayerActionHandler(
      event: event,
      selectedCount: selectedCount.value,
      action: buySellAction.value,
    );

    const alreadyHave = 0; // TODO(Maxim): replace with real value

    final selectorViewModel = SelectorViewModel(
      currentPrice: eventData.currentPrice,
      passiveIncomePerMonth: eventData.profitabilityPercent,
      alreadyHave: alreadyHave,
      maxCount: eventData.availableCount,
      changeableType: true,
    );

    return Column(
      children: <Widget>[
        InfoTable(
          title: Strings.investments,
          rows: <Widget>[
            for (final item in infoTableData.entries)
              TitleRow(title: item.key, value: item.value)
          ],
        ),
        const SizedBox(height: 24),
        GameEventSelector(
          viewModel: selectorViewModel,
          onPlayerActionParamsChanged: (action, count) {
            selectedCount.value = count;
            buySellAction.value = action;
          },
        ),
        const SizedBox(height: 28),
        PlayerActionBar(
          confirm: sendPlayerAction,
          skip: gameActions.skipPlayerAction,
        )
      ],
    );
  }
}
