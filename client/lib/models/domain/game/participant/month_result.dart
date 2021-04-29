import 'package:freezed_annotation/freezed_annotation.dart';

part 'month_result.freezed.dart';
part 'month_result.g.dart';

@freezed
class MonthResult with _$MonthResult {
  factory MonthResult({
    required double cash,
    required double totalIncome,
    required double totalExpense,
    required double totalAssets,
    required double totalLiabilities,
  }) = _MonthResult;

  factory MonthResult.fromJson(Map<String, dynamic> json) =>
      _$MonthResultFromJson(json);
}
