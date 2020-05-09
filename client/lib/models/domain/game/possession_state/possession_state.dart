import 'package:freezed_annotation/freezed_annotation.dart';

import 'assets/asset.dart';
import 'expenses/expense.dart';
import 'incomes/income.dart';
import 'liabilities/liability.dart';

part 'possession_state.freezed.dart';
part 'possession_state.g.dart';

@freezed
abstract class PossessionState with _$PossessionState {
  factory PossessionState({
    @required List<Income> incomes,
    @required List<Expense> expenses,
    @required List<Asset> assets,
    @required List<Liability> liabilities,
  }) = _PossessionState;

  factory PossessionState.fromJson(Map<String, dynamic> json) =>
      _$PossessionStateFromJson(json);
}
