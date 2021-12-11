import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_hook.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class RecommnedationBookHeader extends HookWidget {
  const RecommnedationBookHeader();

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final book = useCurrentRecommendationBook();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: size(16)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _BackButton(),
            _BookCover(book.coverUrl),
            SizedBox(width: size(46)),
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

class _BackButton extends HookWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final buttonSize = size(40);

    return GestureDetector(
      onTap: appRouter.goBack,
      child: Padding(
        padding: EdgeInsets.only(
          left: size(10),
          right: size(16),
          bottom: size(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: ColorRes.backButtonColor,
            borderRadius: BorderRadius.circular(buttonSize / 2),
          ),
          width: buttonSize,
          height: buttonSize,
          child: Center(
            child: SvgPicture.asset(Images.backButton),
          ),
        ),
      ),
    );
  }
}

class _BookCover extends HookWidget {
  const _BookCover(this.imageUrl);

  final String imageUrl;

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
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          height: size(250),
        ),
      ),
    );
  }
}
