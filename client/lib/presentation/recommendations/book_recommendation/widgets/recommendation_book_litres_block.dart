import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_hook.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class RecommendationBookLitresBlock extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();
    final book = useCurrentRecommendationBook();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(Images.litresLogo, height: size(16)),
          SizedBox(height: size(20)),
          _LitresButton(
            color: ColorRes.litresOrange,
            title: Strings.readFragment,
            onTap: () {
              AnalyticsSender.recommendationBookReadFragment(book.bookId);
              launch(book.litres.bookFragmentLink);
            },
          ),
          SizedBox(height: size(8)),
          _LitresButton(
            color: ColorRes.litresGreen,
            title: Strings.buyFor + book.litres.price.toPrice(),
            onTap: () {
              AnalyticsSender.recomendationBookBuy(book.bookId);
              launch(book.litres.bookLink);
            },
          ),
        ],
      ),
    );
  }
}

class _LitresButton extends HookWidget {
  const _LitresButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = useAdaptiveSize();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: color,
        ),
        padding: EdgeInsets.symmetric(
          vertical: size(8),
          horizontal: size(24),
        ),
        child: Text(title, style: Styles.bodySemibold),
      ),
    );
  }
}
