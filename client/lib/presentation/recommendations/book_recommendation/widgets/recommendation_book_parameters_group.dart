import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_hook.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_param.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationBookParametersGroup extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final book = useCurrentRecommendationBook();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RecommendationBookParam(
          icon: Icons.auto_stories,
          title: Strings.pages,
          paramValue: book.pageCount.toString(),
        ),
        RecommendationBookParam(
          icon: Icons.star,
          title: Strings.rating,
          paramValue: book.rating.toString(),
        ),
        RecommendationBookParam(
          icon: Icons.reviews,
          title: Strings.reviews,
          paramValue: book.reviewCount.toString(),
        ),
      ],
    );
  }
}
