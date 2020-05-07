import 'package:cash_flow/models/state/game/possession_state/assets/asset.dart';
import 'package:cash_flow/models/state/game/possession_state/expenses/expense.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cash_flow/models/state/game/possession_state/incomes/income.dart';

part 'possession_state.freezed.dart';
part 'possession_state.g.dart';

@freezed
abstract class PossessionState with _$PossessionState {
  factory PossessionState({
    @required List<Income> incomes,
    @required List<Expense> expenses,
    @required List<Asset> assets,
  }) = _PossessionState;

  factory PossessionState.fromJson(Map<String, dynamic> json) =>
      _$PossessionStateFromJson(json);
}
