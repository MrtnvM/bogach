// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'possession_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PossessionState _$_$_PossessionStateFromJson(Map<String, dynamic> json) {
  return _$_PossessionState(
    incomes: (json['incomes'] as List)
        ?.map((e) =>
            e == null ? null : Income.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    expenses: (json['expenses'] as List)
        ?.map((e) =>
            e == null ? null : Expense.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    assets: (json['assets'] as List)
        ?.map(
            (e) => e == null ? null : Asset.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    liabilities: (json['liabilities'] as List)
        ?.map((e) =>
            e == null ? null : Liability.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$_PossessionStateToJson(_$_PossessionState instance) =>
    <String, dynamic>{
      'incomes': instance.incomes?.map((e) => e?.toJson())?.toList(),
      'expenses': instance.expenses?.map((e) => e?.toJson())?.toList(),
      'assets': instance.assets?.map((e) => e?.toJson())?.toList(),
      'liabilities': instance.liabilities?.map((e) => e?.toJson())?.toList(),
    };
