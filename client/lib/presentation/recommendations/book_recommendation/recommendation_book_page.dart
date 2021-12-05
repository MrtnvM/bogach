import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_data_provider.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_hook.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_info_widget.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommnendation_book_header.dart';
import 'package:cash_flow/utils/ui/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationBookPage extends HookWidget {
  const RecommendationBookPage(this.bookId);

  final String bookId;

  @override
  Widget build(BuildContext context) {
    final book = useGlobalState(
      (s) => s.recommendations.books.itemsMap[bookId],
    )!;

    return CurrentRecommendationBookDataProvider(
      bookId: bookId,
      child: Scaffold(
        body: Container(
          color: HexColor(book.color),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              const RecommnedationBookHeader(),
              const Expanded(child: RecommendationBookInfoWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
