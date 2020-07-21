import 'package:cash_flow/analytics/event/base_analytics_event.dart';

abstract class BaseAnalyticsEventFactory {
  BaseAnalyticsEvent createEvent();
}
