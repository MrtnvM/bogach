import 'package:cash_flow/models/domain/game/possession_state/assets/business/business_asset.dart';

class BusinessesToSellData {
  BusinessesToSellData(this.businessToSell, this.businessToSellData);

  final List<BusinessAsset> businessToSell;
  final List<BusinessToSellData> businessToSellData;
}

class BusinessToSellData {
  BusinessToSellData(this.tableData);

  final Map<String, String> tableData;
}
