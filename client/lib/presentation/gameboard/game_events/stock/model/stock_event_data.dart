import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_event_data.freezed.dart';
part 'stock_event_data.g.dart';

@freezed
abstract class StockEventData with _$StockEventData implements GameEventData {
  factory StockEventData({
    double currentPrice,
    int availableCount,
    double fairPrice,
  }) = _StockEventData;

  factory StockEventData.fromJson(Map<String, dynamic> json) =>
      _$StockEventDataFromJson(json);
}
