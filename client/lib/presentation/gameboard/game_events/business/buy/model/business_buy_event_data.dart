
import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_buy_event_data.freezed.dart';
part 'business_buy_event_data.g.dart';

@freezed
abstract class BusinessBuyEventData 
with _$BusinessBuyEventData 
implements GameEventData {
  factory BusinessBuyEventData({
     String businessId,
    int currentPrice,
    int fairPrice,
    int downPayment,
    int debt,
    int passiveIncomePerMonth,
    int payback,
    int sellProbability,
  }) = _BusinessBuyEventData;

  factory BusinessBuyEventData.fromJson(Map<String, dynamic> json) =>
      _$BusinessBuyEventDataFromJson(json);
}