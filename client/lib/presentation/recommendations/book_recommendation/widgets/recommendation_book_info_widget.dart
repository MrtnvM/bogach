import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_description.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_litres_block.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_parameters_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationBookInfoWidget extends HookWidget {
  const RecommendationBookInfoWidget();

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(size(16))),
      ),
      padding: EdgeInsets.symmetric(horizontal: size(16)),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: size(12)),
          RecommendationBookParametersGroup(),
          SizedBox(height: size(14)),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(height: size(16)),
                RecommendationBookDescription(),
                SizedBox(height: size(24)),
                RecommendationBookLitresBlock(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
