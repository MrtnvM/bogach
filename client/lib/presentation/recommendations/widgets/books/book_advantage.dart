import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/recommendations/recommendation_book_advantage.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BookAdvantageWidget extends HookWidget {
  const BookAdvantageWidget({required this.advantage});

  final RecommendationBookAdvantage advantage;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final height = size(21);

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: size(0)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedNetworkImage(imageUrl: advantage.icon, height: size(17)),
          SizedBox(width: size(6)),
          Text(advantage.title, style: Styles.bodyBlack.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
