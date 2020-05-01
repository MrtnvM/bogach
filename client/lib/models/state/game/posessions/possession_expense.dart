library possession_expense;

import 'package:built_value/built_value.dart';

part 'possession_expense.g.dart';

abstract class PossessionExpense
    implements Built<PossessionExpense, PossessionExpenseBuilder> {
  factory PossessionExpense(
          [void Function(PossessionExpenseBuilder b) updates]) =
      _$PossessionExpense;

  PossessionExpense._();

  String get name;

  int get value;
}
