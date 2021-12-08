import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/widgets/books/book_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:shimmer/shimmer.dart';

class BooksSection extends HookWidget {
  const BooksSection();

  @override
  Widget build(BuildContext context) {
    final swiperController = useState(SwiperController());
    final size = useAdaptiveSize();
    final books = useGlobalState((s) => s.recommendations.books);
    final itemCount = books?.items.length ?? 0;
    final bookSectionSize = size(208);

    return Column(
      children: [
        SizedBox(height: size(24)),
        SectionTitle(text: Strings.booksSectionTitle),
        SizedBox(height: size(4)),
        if (itemCount > 0)
          SizedBox(
            height: bookSectionSize,
            child: Swiper(
              controller: swiperController.value,
              itemCount: itemCount,
              itemBuilder: (context, i) => BookItem(books!.items[i]),
            ),
          )
        else
          _buildShimmerLoader(bookSectionSize),
      ],
    );
  }

  Widget _buildShimmerLoader(double size) {
    return Shimmer.fromColors(
      baseColor: ColorRes.shimmerBaseColor,
      highlightColor: ColorRes.shimmerHightlightColor,
      child: Container(
        height: size,
        margin: const EdgeInsets.only(left: 20, right: 20, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.black,
        ),
      ),
    );
  }
}
