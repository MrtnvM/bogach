import 'package:cash_flow/utils/core/date.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_course.freezed.dart';
part 'recommendation_course.g.dart';

@freezed
class RecommendationCourse
    with _$RecommendationCourse
    implements StoreListItem {
  factory RecommendationCourse({
    @JsonKey(name: 'id')
        required String courseId,
    required String profession,
    required String salaryText,
    required int salaryValue,
    @JsonKey(
      fromJson: fromISO8601DateJsonStrict,
      toJson: toISO8601DateJsonStrict,
    )
        required DateTime startDate,
    required int discount,
    required String source,
    required String url,
    required String imageUrl,
    required int updatedAt,
  }) = _RecommendationCourse;

  RecommendationCourse._();

  factory RecommendationCourse.fromJson(Map<String, dynamic> json) =>
      _$RecommendationCourseFromJson(json);

  @override
  Object get id => courseId;
}
