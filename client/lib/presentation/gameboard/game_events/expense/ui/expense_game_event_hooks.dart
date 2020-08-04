import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/insurance/insurance_asset.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/models/expense_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/expense/ui/expense_widget_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/income/models/empty_player_action.dart';
import 'package:cash_flow/presentation/gameboard/possessions/user_assets_hook.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

ExpenseWidgetData useExpenseEventData({
  @required GameEvent event,
}) {
  final ExpenseEventData eventData = event.data;
  final userInsurances = useUserAssetsWithType<InsuranceAsset>(
    AssetType.insurance,
  );
  final insurancesForEvent = userInsurances
      .where((i) => i.insuranceType == eventData.insuranceType)
      .toList();

  final insuranceCommonValue = insurancesForEvent.fold<int>(
    0,
    (previousValue, insurance) => previousValue + insurance.value,
  );

  final expenseValueWithInsurance = eventData.expense - insuranceCommonValue;

  var eventExpenseValue = expenseValueWithInsurance;
  if (expenseValueWithInsurance < 0) {
    eventExpenseValue = 0;
  }

  final data = {
    Strings.sum: '${(-eventExpenseValue).toPrice()}',
  };

  final expenseWidgetData = ExpenseWidgetData(
    eventName: event.name,
    eventDescription: event.description,
    data: data,
  );

  return expenseWidgetData;
}

VoidCallback useExpensePlayerActionHandler({
  @required GameEvent event,
}) {
  final gameActions = useGameActions();
  final context = useContext();

  return () {
    gameActions
        .sendPlayerAction(const EmptyPlayerAction(), event.id)
        .catchError((e) => handleError(context: context, exception: e));
  };
}
