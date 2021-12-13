import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_hook.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecommnedationBookHeader extends HookWidget {
  const RecommnedationBookHeader({
    Key? key,
    this.bookCoverScale = 1,
  }) : super(key: key);

  final double bookCoverScale;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final book = useCurrentRecommendationBook();
    final notchSize = useNotchSize();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: notchSize.top + size(16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BookCover(
              imageUrl: book.coverUrl,
              imageScaleFactor: bookCoverScale,
            ),
          ],
        ),
        Container(
          margin: EdgeInsets.only(
            top: size(24),
            left: size(24),
            right: size(24),
            bottom: size(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                book.title,
                style: Styles.bodyBlackBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size(8)),
              Text(
                book.author,
                style: Styles.bodyBlack,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _BookCover extends HookWidget {
  const _BookCover({required this.imageUrl, this.imageScaleFactor = 1});

  final String imageUrl;
  final double imageScaleFactor;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            spreadRadius: 4,
            color: Colors.black.withOpacity(0.25),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Hero(
          tag: imageUrl,
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            height: size(250) * imageScaleFactor,
          ),
        ),
      ),
    );
  }
}
