import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_buy_event_data.freezed.dart';
part 'business_buy_event_data.g.dart';

@freezed
class BusinessBuyEventData
    with _$BusinessBuyEventData
    implements GameEventData {
  factory BusinessBuyEventData({
    required String businessId,
    required int currentPrice,
    required int fairPrice,
    required int downPayment,
    required int debt,
    required int passiveIncomePerMonth,
    required int payback,
    required int sellProbability,
  }) = _BusinessBuyEventData;

  factory BusinessBuyEventData.fromJson(Map<String, dynamic> json) =>
      _$BusinessBuyEventDataFromJson(json);
}
