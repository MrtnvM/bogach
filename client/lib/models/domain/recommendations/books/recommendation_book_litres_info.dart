import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_book_litres_info.freezed.dart';
part 'recommendation_book_litres_info.g.dart';

@freezed
class RecommendationBookLitresInfo with _$RecommendationBookLitresInfo {
  factory RecommendationBookLitresInfo({
    required int price,
    required double rating,
    required int reviewCount,
    required String bookLink,
    required String bookFragmentLink,
  }) = _RecommendationBookLitresInfo;

  RecommendationBookLitresInfo._();

  factory RecommendationBookLitresInfo.fromJson(Map<String, dynamic> json) =>
      _$RecommendationBookLitresInfoFromJson(json);
}
