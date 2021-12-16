import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/recommendations/books/recommendation_book_advantage.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_hook.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommendationBookAdvantagesBlock extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final book = useCurrentRecommendationBook();
    final size = useAdaptiveSize();

    return SizedBox(
      height: size(36),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: size(20)),
        children: [
          for (var i = 0; i < book.advantages.length; i++) ...[
            _AdvantageItem(book.advantages[i]),
            if (i < book.advantages.length - 1) SizedBox(width: size(12))
          ]
        ],
      ),
    );
  }
}

class _AdvantageItem extends HookWidget {
  const _AdvantageItem(this.advantage);

  final RecommendationBookAdvantage advantage;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Container(
      padding: EdgeInsets.symmetric(vertical: size(8), horizontal: size(12)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 1,
          color: ColorRes.lightGrey,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(imageUrl: advantage.icon, height: size(20)),
          SizedBox(width: size(8)),
          Text(
            advantage.title,
            style: Styles.bodyBlackSemibold.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
