import 'package:built_value/built_value.dart';
import 'package:cash_flow/models/domain/recommendations/recommendation_book.dart';
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
        (b) => b..books = StoreList<RecommendationBook>(),
      );
}
