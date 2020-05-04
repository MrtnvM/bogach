import 'package:cash_flow/models/domain/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_event_data.freezed.dart';
part 'stock_event_data.g.dart';

@freezed
abstract class StockEventData
    with _$StockEventData
    implements GameEventData {
  factory StockEventData({
    int currentPrice,
    int availableCount,
    int nominal,
  }) = _StockEventData;

  factory StockEventData.fromJson(Map<String, dynamic> json) =>
      _$StockEventDataFromJson(json);
}
