import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/recommendations/recommendation_book.dart';
import 'package:cash_flow/presentation/recommendations/widgets/books/book_item.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/progress/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const recommendationsBooks = [
  RecommendationBook(
    title: 'Самый богатый человек в Вавилоне',
    author: 'Джордж Клейсон',
    coverUrl:
        'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fbook_covers%2Fvavilon.jpeg?alt=media&token=bb47c3cf-e4f6-4c07-a17b-799e36acc70c',
    advantages: [
      RecommendationBookAdvantage(
        icon: Images.iconMindset,
        title: 'Мышление',
      ),
      RecommendationBookAdvantage(
        icon: Images.iconFinances,
        title: 'Личные финансы',
      ),
      RecommendationBookAdvantage(
        icon: Images.iconEnergy,
        title: 'Мотивация',
      ),
    ],
  ),
  RecommendationBook(
    title: 'Мани, или Азбука денег',
    author: 'Бодо Шефер',
    coverUrl:
        'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fbook_covers%2Fmoney-azbuka-deneg.jpeg?alt=media&token=3b345477-a1fa-4c0f-83cc-ab634b1f4df5',
    advantages: [
      RecommendationBookAdvantage(
        icon: Images.iconMindset,
        title: 'Мышление',
      ),
      RecommendationBookAdvantage(
        icon: Images.iconFinances,
        title: 'Личные финансы',
      ),
      RecommendationBookAdvantage(
        icon: Images.iconEnergy,
        title: 'Мотивация',
      ),
    ],
  ),
  RecommendationBook(
    title: 'Хулиномика. Хулиганская экономика.',
    author: 'Алексей Марков',
    coverUrl:
        'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fbook_covers%2Fhulinomika.jpeg?alt=media&token=ee9b0cf6-2da2-417d-a4f5-53b52e6dd2ef',
    advantages: [
      RecommendationBookAdvantage(
        icon: Images.iconMindset,
        title: 'Мышление',
      ),
      RecommendationBookAdvantage(
        icon: Images.iconFinances,
        title: 'Личные финансы',
      ),
      RecommendationBookAdvantage(
        icon: Images.iconEnergy,
        title: 'Мотивация',
      ),
    ],
  )
];

class BooksSection extends HookWidget {
  const BooksSection();

  @override
  Widget build(BuildContext context) {
    final swiperController = useState(SwiperController());
    final size = useAdaptiveSize();

    return Column(
      children: [
        SizedBox(height: size(24)),
        SectionTitle(text: Strings.booksSectionTitle),
        SizedBox(height: size(4)),
        SizedBox(
          height: size(208),
          child: Swiper(
            controller: swiperController.value,
            itemCount: recommendationsBooks.length,
            itemBuilder: (context, i) => BookItem(recommendationsBooks[i]),
          ),
        ),
      ],
    );
  }
}
