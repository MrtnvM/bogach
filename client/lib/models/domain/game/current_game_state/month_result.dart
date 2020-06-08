import 'package:freezed_annotation/freezed_annotation.dart';

part 'month_result.freezed.dart';
part 'month_result.g.dart';

@freezed
abstract class MonthResult with _$MonthResult {
  factory MonthResult({
    @required double cash,
  }) = _MonthResult;

  factory MonthResult.fromJson(Map<String, dynamic> json) =>
      _$MonthResultFromJson(json);
}
