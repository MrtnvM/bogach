// ignore_for_file: invalid_annotation_target

import 'package:cash_flow/utils/core/date.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'candle_data.freezed.dart';
part 'candle_data.g.dart';

@freezed
class CandleData with _$CandleData {
  factory CandleData({
    required double low,
    required double high,
    required double open,
    required double close,
    @JsonKey(fromJson: fromISO8601DateJson) DateTime? time,
  }) = _CandleData;

  factory CandleData.fromJson(Map<String, dynamic> json) =>
      _$CandleDataFromJson(json);
}
