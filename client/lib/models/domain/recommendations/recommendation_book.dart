class RecommendationBookAdvantage {
  const RecommendationBookAdvantage({required this.title, required this.icon});

  final String title;
  final String icon;
}

class RecommendationBook {
  const RecommendationBook({
    required this.coverUrl,
    required this.title,
    required this.author,
    required this.advantages,
  });

  final String coverUrl;
  final String title;
  final String author;
  final List<RecommendationBookAdvantage> advantages;
}
