import 'package:dash_kit_core/dash_kit_core.dart';

class RecommendationBookAdvantage {
  const RecommendationBookAdvantage({required this.title, required this.icon});

  final String title;
  final String icon;
}

class RecommendationBook extends StoreListItem {
  RecommendationBook({
    required this.bookId,
    required this.coverUrl,
    required this.color,
    required this.title,
    required this.author,
    required this.description,
    required this.pageCount,
    required this.rating,
    required this.reviewCount,
    required this.advantages,
    required this.link,
    required this.readerLink,
  });

  final String bookId;
  final String coverUrl;
  final String color;
  final String title;
  final String author;
  final String description;
  final int pageCount;
  final double rating;
  final int reviewCount;
  final String link;
  final String readerLink;
  final List<RecommendationBookAdvantage> advantages;

  @override
  Object get id => bookId;
}
