import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/recommendations/books/recommendation_book.dart';
import 'package:cash_flow/models/domain/recommendations/courses/recommendation_course.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

part 'recommendations_state.g.dart';

abstract class RecommendationsState
    implements Built<RecommendationsState, RecommendationsStateBuilder> {
  factory RecommendationsState(
          [void Function(RecommendationsStateBuilder)? updates]) =
      _$RecommendationsState;

  RecommendationsState._();

  StoreList<RecommendationBook> get books;
  StoreList<RecommendationCourse> get courses;

  static RecommendationsState initial() => RecommendationsState(
        (b) => b
          ..books = StoreList<RecommendationBook>()
          ..courses = StoreList<RecommendationCourse>(),
      );
}
