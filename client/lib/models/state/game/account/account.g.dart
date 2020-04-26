// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Account _$_$_AccountFromJson(Map<String, dynamic> json) {
  return _$_Account(
    cashFlow: (json['cashFlow'] as num)?.toDouble(),
    cash: (json['cash'] as num)?.toDouble(),
    credit: (json['credit'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$_$_AccountToJson(_$_Account instance) =>
    <String, dynamic>{
      'cashFlow': instance.cashFlow,
      'cash': instance.cash,
      'credit': instance.credit,
    };
