class ExpenseWidgetData {
  ExpenseWidgetData({
    required this.eventName,
    required this.eventDescription,
    required this.data,
  });

  final String eventName;
  final String eventDescription;
  final Map<String, String> data;
}
