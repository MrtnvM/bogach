import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/recommendations/recommendation_book.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'recommendations_state.g.dart';

abstract class RecommendationsState
    implements Built<RecommendationsState, RecommendationsStateBuilder> {
  factory RecommendationsState(
          [void Function(RecommendationsStateBuilder)? updates]) =
      _$RecommendationsState;

  RecommendationsState._();

  StoreList<RecommendationBook> get books;

  static RecommendationsState initial() => RecommendationsState(
        (b) => b
          ..books = StoreList<RecommendationBook>(
            [
              RecommendationBook(
                bookId: 'book1',
                title: 'Самый богатый человек в Вавилоне',
                author: 'Джордж Клейсон',
                description:
                    'Автор этой книги уверен: чтобы исполнить все свои замыслы и желания, Вы прежде всего должны добиться успеха в денежных вопросах, используя принципы управления личными финансами, изложенные на её страницах.\n\nДля широкого круга читателей.',
                link: 'https://www.litres.ru/23593618/?lfrom=432409830',
                readerLink:
                    'https://www.litres.ru/pages/quickread/?art=23593618&skin=normal&lfrom=432409830&l=432409830&widget=1.00&iframe=1',
                color: '#F8F9C2',
                pageCount: 140,
                rating: 4.8,
                reviewCount: 11209,
                coverUrl:
                    'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fbook_covers%2Fvavilon.jpeg?alt=media&token=bb47c3cf-e4f6-4c07-a17b-799e36acc70c',
                advantages: const [
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
                bookId: 'book2',
                title: 'Мани, или Азбука денег',
                author: 'Бодо Шефер',
                color: 'CBE3FF',
                description:
                    'Исповедуя расхожий тезис о том, что каждый человек от рождения имеет право быть богатым, автор подробно (на «детском» уровне) разъясняет широкому кругу читателей процессы обращения с деньгами: как их сберегать, как с выгодой тратить, как гасить долги – короче говоря, как заработать первый миллион…',
                link: 'https://www.litres.ru/11279349/?lfrom=432409830',
                readerLink:
                    'https://www.litres.ru/pages/quickread/?art=11279349&skin=normal&lfrom=432409830&l=432409830&widget=1.00&iframe=1',
                pageCount: 160,
                rating: 4.8,
                reviewCount: 1366,
                coverUrl:
                    'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fbook_covers%2Fmoney-azbuka-deneg.jpeg?alt=media&token=3b345477-a1fa-4c0f-83cc-ab634b1f4df5',
                advantages: const [
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
                bookId: 'book3',
                title: 'Хулиномика. Хулиганская экономика.',
                author: 'Алексей Марков',
                description:
                    'Идеальный учебник для тех, кто не любит учиться по скучным талмудам!\n\nЭкономика – это очень скучно. Куча непонятных заумных слов и формул? Кто вам такое сказал? Экономика это интересно и просто! Вы просто не знаете, с каким соусом ее нужно подавать, на какой стороне пережевывать и долго ли жевать. Все базовые знания о ней и много больше вы получите из книги «Хулиномика».\n\nКнига содержит нецензурную брань',
                link: 'https://www.litres.ru/25578317/?lfrom=432409830',
                readerLink:
                    'https://www.litres.ru/pages/quickread/?art=25578317&skin=normal&lfrom=432409830&l=432409830&widget=1.00&iframe=1',
                color: 'FF9F98',
                pageCount: 390,
                rating: 4.5,
                reviewCount: 668,
                coverUrl:
                    'https://firebasestorage.googleapis.com/v0/b/cash-flow-staging.appspot.com/o/recommendations%2Fbook_covers%2Fhulinomika.jpeg?alt=media&token=ee9b0cf6-2da2-417d-a4f5-53b52e6dd2ef',
                advantages: const [
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
            ],
          ),
      );
}
