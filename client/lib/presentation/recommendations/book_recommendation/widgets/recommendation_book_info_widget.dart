import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_advantages_block.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_description.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_litres_block.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_parameters_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationBookInfoWidget extends HookWidget {
  const RecommendationBookInfoWidget({this.minHeight = 0});

  final double minHeight;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(size(16))),
        boxShadow: const [
          BoxShadow(
            spreadRadius: 3,
            blurRadius: 10,
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: size(12)),
          RecommendationBookParametersGroup(),
          SizedBox(height: size(14)),
          Divider(height: 1, indent: size(16), endIndent: size(16)),
          SizedBox(height: size(16)),
          RecommendationBookAdvantagesBlock(),
          SizedBox(height: size(16)),
          RecommendationBookDescription(),
          SizedBox(height: size(24)),
          RecommendationBookLitresBlock(),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 8,
          ),
        ],
      ),
    );
  }
}
