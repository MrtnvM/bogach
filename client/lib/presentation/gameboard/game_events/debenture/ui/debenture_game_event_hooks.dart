import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/game/actions/send_player_move_action.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/debenture/debenture_asset.dart';
import 'package:cash_flow/models/domain/player_action/buy_sell_action.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_player_action.dart';
import 'package:cash_flow/presentation/gameboard/gameboard_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Map<String, String> useDebentureInfoTableData(GameEvent event) {
  final eventData = event.data as DebentureEventData;

  final data = {
    Strings.currentPrice: eventData.currentPrice.toPrice(),
    Strings.nominalCost: eventData.nominal.toPrice(),
    Strings.passiveIncomePerMonth:
        (eventData.profitabilityPercent / 12).toPercent(),
  };

  return data;
}

VoidCallback useDebenturePlayerActionHandler({
  required GameEvent event,
  required int selectedCount,
  required BuySellAction action,
}) {
  final context = useContext();
  final dispatch = useDispatcher();
  final isEnoughCash = useIsEnoughCashValidator();
  final gameContext = useCurrentGameContext();

  return () {
    final eventData = event.data as DebentureEventData;
    final price = eventData.currentPrice * selectedCount;

    if (isBuyAction(action) && !isEnoughCash(price)) {
      return;
    }

    final playerAction = DebenturePlayerAction(
      action,
      selectedCount,
      event.id,
    );

    dispatch(SendPlayerMoveAction(
      eventId: event.id,
      playerAction: playerAction,
      gameContext: gameContext,
    )).onError((e, st) => handleError(context: context, exception: e));
  };
}

DebentureAsset? useCurrentDebenture(GameEvent event) {
  final userId = useUserId()!;
  final currentDebenture = useCurrentGame((g) {
    final theSameDebenture = g?.participants[userId]?.possessionState.assets
        .where((a) => a.type == AssetType.debenture)
        .cast<DebentureAsset>()
        .firstWhereOrNull((s) => s.name == event.name);

    return theSameDebenture;
  });

  return currentDebenture;
}

GameEventInfoDialogModel useDebentureInfoDialogModel() {
  return useMemoized(
    () => GameEventInfoDialogModel(
      title: Strings.debentureDialogTitle,
      description: Strings.debentureDialogDescription,
      keyPoints: {
        Strings.debentureDialogKeyPoint1:
            Strings.debentureDialogKeyPointDescription1,
        Strings.debentureDialogKeyPoint2:
            Strings.debentureDialogKeyPointDescription2,
      },
      riskLevel: Rating.low,
      profitabilityLevel: Rating.low,
      complexityLevel: Rating.low,
    ),
  );
}
