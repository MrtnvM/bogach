import 'package:freezed_annotation/freezed_annotation.dart';

part 'income.freezed.dart';
part 'income.g.dart';

@freezed
abstract class Income with _$Income {
  factory Income({
    @required String name,
    @required double value,
    @JsonKey(unknownEnumValue: IncomeType.other) @required IncomeType type,
  }) = _Income;

  factory Income.fromJson(Map<String, dynamic> json) => _$IncomeFromJson(json);
}

enum IncomeType { salary, realty, investment, business, other }
