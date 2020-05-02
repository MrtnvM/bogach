import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_asset_response_model.g.dart';

@JsonSerializable()
class StockAssetResponseModel {
  const StockAssetResponseModel({
    this.name,
    this.countInPortfolio,
    this.averagePrice,
    this.type,
  });

  factory StockAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StockAssetResponseModelFromJson(json);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'countInPortfolio')
  final int countInPortfolio;
  @JsonKey(name: 'averagePrice')
  final double averagePrice;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;

  Map<String, dynamic> toJson() => _$StockAssetResponseModelToJson(this);
}
