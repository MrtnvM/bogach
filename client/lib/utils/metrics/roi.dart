import 'package:cash_flow/presentation/gameboard/game_events/investment/models/investment_event_data.dart';

abstract class ROI {
  static double fromInvestment(InvestmentEventData investment) {
    const monthInYear = 12;
    final roi = investment.profitabilityPercent * monthInYear;
    return roi.toDouble();
  }
}
