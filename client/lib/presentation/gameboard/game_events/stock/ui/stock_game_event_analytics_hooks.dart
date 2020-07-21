import 'package:cash_flow/analytics/sender/stock_analytics_sender.dart';

Function(int, String, double) useBuyStockAnalyticsSender() {
  return StockAnalyticsSender.sendBuyStockEvent;
}
