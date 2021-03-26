import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'real_estate_buy_event_data.freezed.dart';
part 'real_estate_buy_event_data.g.dart';

@freezed
abstract class RealEstateBuyEventData
    with _$RealEstateBuyEventData
    implements GameEventData {
  factory RealEstateBuyEventData({
    String realEstateId,
    int currentPrice,
    int fairPrice,
    int downPayment,
    int debt,
    int passiveIncomePerMonth,
    int payback,
    int sellProbability,
    String assetName,
  }) = _RealEstateBuyEventData;

  factory RealEstateBuyEventData.fromJson(Map<String, dynamic> json) =>
      _$RealEstateBuyEventDataFromJson(json);
}
