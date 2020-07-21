import 'package:cash_flow/analytics/event/base_analytics_event.dart';
import 'package:cash_flow/analytics/factory/base/base_event_factory.dart';

class StockBuyEventFactory implements BaseAnalyticsEventFactory {
  StockBuyEventFactory(this._count, this._stockName, this._price);

  static const String _eventName = 'stock_buy_event';
  static const String _countParam = 'stock_count';
  static const String _stockNameParam = 'stock_name';
  static const String _priceParam = 'stock_price';

  final int _count;
  final String _stockName;
  final int _price;

  @override
  BaseAnalyticsEvent createEvent() {
    final params = {
      _countParam: _count,
      _stockNameParam: _stockName,
      _priceParam: _price
    };
    final event = BaseAnalyticsEvent(_eventName, params: params);

    return event;
  }
}
