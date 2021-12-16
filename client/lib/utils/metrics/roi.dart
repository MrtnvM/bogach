import 'package:cash_flow/presentation/gameboard/game_events/debenture/models/debenture_event_data.dart';

// ignore: avoid_classes_with_only_static_members
abstract class ROI {
  static double fromInvestment(DebentureEventData investment) {
    const monthInYear = 12;
    final roi = investment.profitabilityPercent * monthInYear;
    return roi.toDouble();
  }
}
