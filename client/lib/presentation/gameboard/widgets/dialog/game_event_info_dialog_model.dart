import 'package:flutter/cupertino.dart';

class GameEventInfoDialogModel {
  GameEventInfoDialogModel({
    @required this.title,
    @required this.description,
    @required this.keyPoints,
    @required this.riskLevel,
    @required this.profitabilityLevel,
    @required this.complexityLevel,
  });

  final String title;
  final String description;
  final Map<String, String> keyPoints;
  final Rating riskLevel;
  final Rating profitabilityLevel;
  final Rating complexityLevel;
}

enum Rating { zero, low, medium, high }

extension RatingExtension on Rating {
  static int getRatingLevel(Rating rating) {
    if (rating == Rating.zero) {
      return 0;
    } else if (rating == Rating.low) {
      return 1;
    } else if (rating == Rating.medium) {
      return 2;
    } else {
      return 3;
    }
  }
}
