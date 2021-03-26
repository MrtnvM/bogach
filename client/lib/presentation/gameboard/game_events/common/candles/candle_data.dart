import 'package:cash_flow/utils/core/date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'candle_data.freezed.dart';
part 'candle_data.g.dart';

@freezed
abstract class CandleData with _$CandleData {
  factory CandleData({
    double low,
    double high,
    double open,
    double close,
    @JsonKey(fromJson: fromISO8601DateJson) DateTime time,
  }) = _CandleData;

  factory CandleData.fromJson(Map<String, dynamic> json) =>
      _$CandleDataFromJson(json);
}
