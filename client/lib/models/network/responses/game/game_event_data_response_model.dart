import 'package:json_annotation/json_annotation.dart';

part 'game_event_data_response_model.g.dart';

@JsonSerializable()
class GameEventDataResponseModel {
  const GameEventDataResponseModel({
    this.currentPrice,
    this.maxCount,
    this.nominal,
    this.profitabilityPercent,
  });

  factory GameEventDataResponseModel.fromJson(Map<String, dynamic> json) =>
      _$GameEventDataResponseModelFromJson(json);

  final int currentPrice;
  final int maxCount;
  final int nominal;
  final int profitabilityPercent;

  Map<String, dynamic> toJson() => _$GameEventDataResponseModelToJson(this);
}