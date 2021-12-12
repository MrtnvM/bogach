import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_hook.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationBookDescription extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final book = useCurrentRecommendationBook();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size(20)),
      child: Text(
        book.description ?? book.originalDescription,
        style: Styles.bodyBlack,
      ),
    );
  }
}
