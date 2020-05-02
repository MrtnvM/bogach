// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_state_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountStateResponseModel _$AccountStateResponseModelFromJson(
    Map<String, dynamic> json) {
  return AccountStateResponseModel(
    cash: (json['cash'] as num)?.toDouble(),
    cashFlow: (json['cashFlow'] as num)?.toDouble(),
    credit: (json['credit'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$AccountStateResponseModelToJson(
        AccountStateResponseModel instance) =>
    <String, dynamic>{
      'cash': instance.cash,
      'cashFlow': instance.cashFlow,
      'credit': instance.credit,
    };
