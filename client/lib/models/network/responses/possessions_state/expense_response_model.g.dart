// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExpenseResponseModel _$ExpenseResponseModelFromJson(Map<String, dynamic> json) {
  return ExpenseResponseModel(
    name: json['name'] as String,
    value: json['value'] as int,
  );
}

Map<String, dynamic> _$ExpenseResponseModelToJson(
        ExpenseResponseModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };
