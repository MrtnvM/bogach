import 'package:cash_flow/presentation/gameboard/game_events/business/buy/model/business_buy_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/investment/models/investment_event_data.dart';
import 'package:cash_flow/presentation/gameboard/game_events/stock/model/stock_event_data.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'game_event_type.freezed.dart';

const _debentureEventType = 'debenture-price-changed-event';
const _stockEventType = 'stock-price-changed-event';
const _businessBuyEventType = 'business-buy-event';

@freezed
abstract class GameEventType implements _$GameEventType {
  GameEventType._();

  factory GameEventType.debenture() = DebentureGameEventType;
  factory GameEventType.stock() = StockGameEventType;
  factory GameEventType.businessBuy() = BusinessBuyEventType;

  String typeTitle() => map(
        debenture: (_) => Strings.investments,
        stock: (_) => Strings.stock,
        businessBuy: (_) => Strings.business,
      );

  dynamic parseGameEventData(Map<String, dynamic> json) {
    return map(
      debenture: (_) => InvestmentEventData.fromJson(json),
      stock: (_) => StockEventData.fromJson(json),
      businessBuy: (_) => BusinessBuyEventData.fromJson(json),
    );
  }

  String jsonValue() => map(
        debenture: (_) => _debentureEventType,
        stock: (_) => _stockEventType,
        businessBuy: (_) => _businessBuyEventType,
      );

  static GameEventType fromJson(String json) {
    switch (json) {
      case _debentureEventType:
        return GameEventType.debenture();

      case _stockEventType:
        return GameEventType.stock();

      case _businessBuyEventType:
        return GameEventType.businessBuy();

      default:
        // TODO(Maxim): Add non fatal error; Remove throwing exception
        throw Exception('Unknown GameEventType value');
    }
  }

  static String toJson(GameEventType type) {
    return type.jsonValue();
  }
}
