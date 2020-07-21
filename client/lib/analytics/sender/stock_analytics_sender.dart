import 'package:cash_flow/analytics/factory/widget/stock/stock_buy_event_factory.dart';
import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';

class StockAnalyticsSender {
  static void sendBuyStockEvent(int count, String stockName, double price) {
    final event = StockBuyEventFactory(
      count,
      stockName,
      price.toInt(),
    ).createEvent();
    AnalyticsSender().sendEvent(event);
  }
}
