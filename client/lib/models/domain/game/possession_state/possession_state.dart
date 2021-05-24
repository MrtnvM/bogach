import 'package:freezed_annotation/freezed_annotation.dart';

import 'assets/asset.dart';
import 'expenses/expense.dart';
import 'incomes/income.dart';
import 'liabilities/liability.dart';

part 'possession_state.freezed.dart';
part 'possession_state.g.dart';

@freezed
class PossessionState with _$PossessionState {
  factory PossessionState({
    @JsonKey(defaultValue: []) required List<Income> incomes,
    @JsonKey(defaultValue: []) required List<Expense> expenses,
    @JsonKey(defaultValue: []) required List<Asset> assets,
    @JsonKey(defaultValue: []) required List<Liability> liabilities,
  }) = _PossessionState;

  factory PossessionState.fromJson(Map<String, dynamic> json) =>
      _$PossessionStateFromJson(json);
}
