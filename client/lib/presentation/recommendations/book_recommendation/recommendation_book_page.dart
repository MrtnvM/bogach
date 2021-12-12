import 'dart:math';

import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/data/current_recommendation_book_data_provider.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommendation_book_info_widget.dart';
import 'package:cash_flow/presentation/recommendations/book_recommendation/widgets/recommnendation_book_header.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/utils/ui/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecommendationBookPage extends HookWidget {
  const RecommendationBookPage(this.bookId);

  final String bookId;

  @override
  Widget build(BuildContext context) {
    final headerKey = useState(GlobalKey());
    final book = useGlobalState(
      (s) => s.recommendations.books.itemsMap[bookId],
    )!;
    final infoBlockMargin = useState(100.0);
    final infoTopPadding = useState(300.0);
    final infoBlockMinHeight = useState(0.0);
    final screenSize = useScreenSize();

    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
        infoBlockMargin.value = 0.0;

        final headerHeight = headerKey.value.currentContext?.size?.height ?? 0;
        infoTopPadding.value = headerHeight;
        infoBlockMinHeight.value = screenSize.height - headerHeight;
      });
    }, []);

    final scrollController = useScrollController();
    final bookCoverScale = useState(1.0);

    useEffect(() {
      final scrollListener = () {
        final scrollOffset =
            scrollController.hasClients ? scrollController.offset : 0;
        final scale = 1.0 - scrollOffset / screenSize.height;
        bookCoverScale.value = max(min(scale, 1.15), 0.85);
      };

      scrollController.addListener(scrollListener);
      return () => scrollController.removeListener(scrollListener);
    }, []);

    return CurrentRecommendationBookDataProvider(
      bookId: bookId,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          color: HexColor(book.color),
          child: Stack(
            children: [
              RecommnedationBookHeader(
                key: headerKey.value,
                bookCoverScale: bookCoverScale.value,
              ),
              Positioned.fill(
                child: AnimatedContainer(
                  margin: EdgeInsets.only(top: infoBlockMargin.value),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                  child: ListView(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: infoTopPadding.value),
                    children: [
                      RecommendationBookInfoWidget(
                        minHeight: infoBlockMinHeight.value,
                      ),
                    ],
                  ),
                ),
              ),
              const _BackButton(),
            ],
          ),
        ),
      ),
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
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
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
