import 'package:cash_flow/presentation/gameboard/game_events/investment/models/investment_event_data.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'game_event_type.freezed.dart';

const _debentureEventType = 'debenture-price-changed-event';
const _stockEventType = 'stock-price-changed-event';

@freezed
abstract class GameEventType implements _$GameEventType {
  GameEventType._();

  factory GameEventType.debenture() = DebentureGameEventType;
  factory GameEventType.stock() = StockGameEventType;

  String typeTitle() => map(
        debenture: (_) => Strings.investments,
        stock: (_) => Strings.stock,
      );

  dynamic parseGameEventData(Map<String, dynamic> json) {
    return map(
      debenture: (_) => InvestmentEventData.fromJson(json),
      stock: (_) => throw Exception('Not implemented'),
    );
  }

  String jsonValue() => map(
        debenture: (_) => _debentureEventType,
        stock: (_) => _stockEventType,
      );

  static GameEventType fromJson(String json) {
    switch (json) {
      case _debentureEventType:
        return GameEventType.debenture();

      case _stockEventType:
        return GameEventType.stock();

      default:
        // TODO(Maxim): Add non fatal error; Remove throwing exception
        throw Exception('Unknown GameEventType value');
    }
  }
}
