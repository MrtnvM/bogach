class GameEventInfoDialogModel {
  GameEventInfoDialogModel(
    this.title,
    this.description,
    this.keyPoints,
    this.riskLevel,
    this.profitabilityLevel,
    this.complexityLevel,
  );

  final String title;
  final String description;
  final Map<String, String> keyPoints;
  final Rating riskLevel;
  final Rating profitabilityLevel;
  final Rating complexityLevel;
}

enum Rating { low, medium, high }
