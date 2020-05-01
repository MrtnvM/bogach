library possession_income;

import 'package:built_value/built_value.dart';

part 'possession_income.g.dart';

abstract class PossessionIncome
    implements Built<PossessionIncome, PossessionIncomeBuilder> {
  factory PossessionIncome([void Function(PossessionIncomeBuilder b) updates]) =
      _$PossessionIncome;

  PossessionIncome._();

  int get salary;

  int get investments;

  int get business;

  int get realty;

  int get other;

  int get sum => salary + investments + business + realty + other;
}
