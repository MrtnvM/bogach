// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Expense _$_$_ExpenseFromJson(Map<String, dynamic> json) {
  return _$_Expense(
    name: json['name'] as String,
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_ExpenseToJson(_$_Expense instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
