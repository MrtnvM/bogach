import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/recommendations/books/recommendation_book_advantage.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shimmer/shimmer.dart';

// ignore: constant_identifier_names
const _ICON_SIZE = 18.0;

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
          CachedNetworkImage(
            imageUrl: advantage.icon,
            height: size(_ICON_SIZE),
            placeholder: (context, _) => const _IconPlaceholder(),
          ),
          SizedBox(width: size(8)),
          Expanded(
            child: AutoSizeText(
              advantage.title,
              style: Styles.bodyBlack.copyWith(fontSize: 12.5),
              maxLines: 1,
              minFontSize: 10,
            ),
          )
        ],
      ),
    );
  }
}

class _IconPlaceholder extends HookWidget {
  const _IconPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Shimmer.fromColors(
      baseColor: ColorRes.shimmerBaseColor,
      highlightColor: ColorRes.shimmerHightlightColor,
      child: Container(
        height: size(_ICON_SIZE),
        width: size(_ICON_SIZE),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: ColorRes.grey,
        ),
      ),
    );
  }
}
