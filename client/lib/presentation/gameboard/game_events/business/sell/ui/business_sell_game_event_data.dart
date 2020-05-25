class BusinessesToSellData {
  BusinessesToSellData(this.businessesTableData);

  final List<BusinessToSellTableData> businessesTableData;
}

class BusinessToSellTableData {
  BusinessToSellTableData({
    this.businessId,
    this.tableData,
  });

  final String businessId;
  final Map<String, String> tableData;
}
