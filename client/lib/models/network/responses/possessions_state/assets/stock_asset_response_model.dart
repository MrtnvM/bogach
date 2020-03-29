import 'package:cash_flow/models/network/responses/possessions_state/assets/asset_response_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'stock_asset_response_model.g.dart';

@JsonSerializable()
class StockAssetResponseModel {
  const StockAssetResponseModel({
    this.count,
    this.name,
    this.purchasePrice,
    this.total,
    this.type,
  });

  factory StockAssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StockAssetResponseModelFromJson(json);

  @JsonKey(name: 'count')
  final int count;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'purchasePrice')
  final int purchasePrice;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'type', defaultValue: AssetType.other)
  final AssetType type;

  Map<String, dynamic> toJson() => _$StockAssetResponseModelToJson(this);
}
