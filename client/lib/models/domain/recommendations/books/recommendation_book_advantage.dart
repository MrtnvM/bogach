import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_book_advantage.freezed.dart';
part 'recommendation_book_advantage.g.dart';

@freezed
class RecommendationBookAdvantage with _$RecommendationBookAdvantage {
  factory RecommendationBookAdvantage({
    required String title,
    required String icon,
  }) = _RecommendationBookAdvantage;

  factory RecommendationBookAdvantage.fromJson(Map<String, dynamic> json) =>
      _$RecommendationBookAdvantageFromJson(json);
}
