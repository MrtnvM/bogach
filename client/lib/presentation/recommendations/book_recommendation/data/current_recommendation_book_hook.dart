import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/models/domain/recommendations/books/recommendation_book.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_data_provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

String useCurrentRecommendationBookId() {
  final context = useContext();
  final bookId = CurrentRecommendationBookDataProvider.of(context).bookId;
  return bookId;
}

RecommendationBook useCurrentRecommendationBook() {
  final bookId = useCurrentRecommendationBookId();
  final book = useGlobalState(
    (s) => s.recommendations.books.itemsMap[bookId],
  );

  return book!;
}
