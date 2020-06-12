import 'package:flutter/cupertino.dart';

class ExpenseWidgetData {
  ExpenseWidgetData({
    @required this.eventName,
    @required this.eventDescription,
    @required this.data,
  })  : assert(eventName != null),
        assert(eventDescription != null),
        assert(data != null);

  final String eventName;
  final String eventDescription;
  final Map<String, String> data;
}
