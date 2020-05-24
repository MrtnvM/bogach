import 'package:cash_flow/models/domain/game/possession_state/assets/business/business_asset.dart';

class BusinessesToSellData {
  BusinessesToSellData(this.businessesAssets, this.businessesTableData);

  final List<BusinessAsset> businessesAssets;
  final List<BusinessToSellTableData> businessesTableData;
}

class BusinessToSellTableData {
  BusinessToSellTableData(this.tableData);

  final Map<String, String> tableData;
}
