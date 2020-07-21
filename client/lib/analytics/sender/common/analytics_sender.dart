import 'package:cash_flow/analytics/event/base_analytics_event.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsSender {
  factory AnalyticsSender() {
    return _instance;
  }

  AnalyticsSender._internal();

  static final AnalyticsSender _instance = AnalyticsSender._internal();

  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();

  void sendEvent(BaseAnalyticsEvent event) {
    _firebaseAnalytics.logEvent(
      name: event.eventname,
      parameters: event.params,
    );
  }
}
