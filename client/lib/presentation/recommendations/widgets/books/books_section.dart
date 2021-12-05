import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/recommendations/widgets/books/book_item.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BooksSection extends HookWidget {
  const BooksSection();

  @override
  Widget build(BuildContext context) {
    final swiperController = useState(SwiperController());
    final size = useAdaptiveSize();
    final books = useGlobalState((s) => s.recommendations.books);

    return Column(
      children: [
        SizedBox(height: size(24)),
        SectionTitle(text: Strings.booksSectionTitle),
        SizedBox(height: size(4)),
        SizedBox(
          height: size(208),
          child: Swiper(
            controller: swiperController.value,
            itemCount: books?.items.length ?? 0,
            itemBuilder: (context, i) => BookItem(books!.items[i]),
          ),
        ),
      ],
    );
  }
}
