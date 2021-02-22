import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/stock/stock_asset.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_player_action.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Map<String, String> useStockInfoTableData(GameEvent event) {
  final currentStock = useCurrentStock(event);
  final isQuest = useIsQuestGame();
  final alreadyHave = currentStock?.countInPortfolio ?? 0;

  final StockEventData eventData = event.data;
  final currentPrice = eventData.currentPrice;
  final previousPrice = currentStock?.averagePrice;
  final priceChange = previousPrice == null
      ? 0.0
      : ((currentPrice - previousPrice) / previousPrice) * 100;

  final data = {
    if (isQuest) Strings.currentPrice: eventData.currentPrice.toPrice(),
    if (isQuest) Strings.yearAvaragePrice: eventData.fairPrice.toPrice(),
    Strings.alreadyHave: alreadyHave == 0
        ? alreadyHave.toString()
        : Strings.getUserAvailableCount(
            currentStock.countInPortfolio.toString(),
            currentStock.averagePrice.toPrice(),
          ),
    if (alreadyHave > 0)
      Strings.changeInPortfolio: priceChange.toPercentWithSign(),
  };

  return data;
}

VoidCallback useStockPlayerActionHandler({
  @required GameEvent event,
  @required int selectedCount,
  @required BuySellAction action,
}) {
  final context = useContext();
  final dispatch = useDispatcher();
  final isEnoughCash = useIsEnoughCashValidator();

  return () {
    final StockEventData eventData = event.data;
    final totalPrice = eventData.currentPrice * selectedCount;

    if (isBuyAction(action) && !isEnoughCash(totalPrice)) {
      return;
    }

    final playerAction = StockPlayerAction(
      action,
      selectedCount,
      event.id,
    );

    dispatch(
      SendPlayerMoveAction(eventId: event.id, playerAction: playerAction),
    ).catchError((e) {
      handleError(context: context, exception: e);
    });
  };
}

StockAsset useCurrentStock(GameEvent event) {
  final userId = useUserId();
  final stockAssets = useCurrentGame((g) {
    return g.participants[userId].possessionState.assets
        .where((a) => a.type == AssetType.stock)
        .cast<StockAsset>()
        .toList();
  });

  final currentStock = stockAssets.firstWhere(
    (s) => s.name == event.name,
    orElse: () => null,
  );

  return currentStock;
}

GameEventInfoDialogModel useStockInfoDialogModel() {
  return useMemoized(
    () => GameEventInfoDialogModel(
      title: Strings.stockDialogTitle,
      description: Strings.stockDialogDescription,
      keyPoints: {
        Strings.stockDialogKeyPoint1: Strings.stockDialogKeyPointDescription1,
        Strings.stockDialogKeyPoint2: Strings.stockDialogKeyPointDescription2,
      },
      riskLevel: Rating.high,
      profitabilityLevel: Rating.high,
      complexityLevel: Rating.high,
    ),
  );
}
