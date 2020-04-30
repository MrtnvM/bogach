library user_possession_state;

import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/state/game/posessions/possession_asset.dart';
import 'package:cash_flow/models/state/game/posessions/possession_expense.dart';
import 'package:cash_flow/models/state/game/posessions/possession_income.dart';
import 'package:cash_flow/models/state/game/posessions/possession_liability.dart';

part 'user_possession_state.g.dart';

abstract class UserPossessionState
    implements Built<UserPossessionState, UserPossessionStateBuilder> {
  factory UserPossessionState(
          [void Function(UserPossessionStateBuilder b) updates]) =
      _$UserPossessionState;

  UserPossessionState._();

  PossessionAsset get assets;

  List<PossessionExpense> get expenses;

  PossessionIncome get incomes;

  List<PossessionLiability> get liabilities;
}
