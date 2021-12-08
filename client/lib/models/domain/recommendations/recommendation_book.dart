import 'package:cash_flow/models/domain/recommendations/recommendation_book_litres_info.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:cash_flow/models/domain/recommendations/recommendation_book_advantage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_book.freezed.dart';
part 'recommendation_book.g.dart';

@freezed
class RecommendationBook with _$RecommendationBook implements StoreListItem {
  factory RecommendationBook({
    required String bookId,
    required String coverUrl,
    required String color,
    required String title,
    required String author,
    required String? description,
    required String originalDescription,
    required int pagesCount,
    required RecommendationBookLitresInfo litres,
    required List<RecommendationBookAdvantage> advantages,
    required int updatedAt,
  }) = _RecommendationBook;

  RecommendationBook._();

  factory RecommendationBook.fromJson(Map<String, dynamic> json) =>
      _$RecommendationBookFromJson(json);

  @override
  Object get id => bookId;
}
