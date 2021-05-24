import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'real_estate_buy_event_data.freezed.dart';
part 'real_estate_buy_event_data.g.dart';

@freezed
class RealEstateBuyEventData
    with _$RealEstateBuyEventData
    implements GameEventData {
  factory RealEstateBuyEventData({
    required String realEstateId,
    required int currentPrice,
    required int fairPrice,
    required int downPayment,
    required int debt,
    required int passiveIncomePerMonth,
    required int payback,
    required int sellProbability,
    required String assetName,
  }) = _RealEstateBuyEventData;

  factory RealEstateBuyEventData.fromJson(Map<String, dynamic> json) =>
      _$RealEstateBuyEventDataFromJson(json);
}
