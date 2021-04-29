class BusinessesToSellData {
  BusinessesToSellData(this.businessesTableData);

  final List<BusinessToSellTableData>? businessesTableData;
}

class BusinessToSellTableData {
  BusinessToSellTableData({
    required this.businessId,
    required this.tableData,
  });

  final String businessId;
  final Map<String, String> tableData;
}
