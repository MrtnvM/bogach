import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/configuration/cash_api_environment.dart';

void configureAnalytics(CashApiEnvironment environment) {
  AnalyticsSender.isEnabled = environment.isAnalyticsEnabled;

  switch (environment) {
    case CashApiEnvironment.production:
      AnalyticsSender.amplitudeAnalytics.init(
        '27f8a75e75a09129fd24cbc3a3c32119',
      );
      return;

    default:
      AnalyticsSender.amplitudeAnalytics.init(
        '1d1342311fc42410619a987520e84389',
      );
  }
}
