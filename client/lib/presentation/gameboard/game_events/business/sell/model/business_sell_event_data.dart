import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_sell_event_data.freezed.dart';
part 'business_sell_event_data.g.dart';

@freezed
class BusinessSellEventData
    with _$BusinessSellEventData
    implements GameEventData {
  factory BusinessSellEventData({
    String? businessId,
    int? currentPrice,
    int? fairPrice,
    int? downPayment,
    int? debt,
    int? passiveIncomePerMonth,
    int? payback,
    int? sellProbability,
  }) = _BusinessSellEventData;

  factory BusinessSellEventData.fromJson(Map<String, dynamic> json) =>
      _$BusinessSellEventDataFromJson(json);
}
