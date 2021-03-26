import 'package:cash_flow/models/domain/game/game_event/game_event.dart';
import 'package:cash_flow/models/domain/game/possession_state/assets/insurance/insurance_asset.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'expense_event_data.freezed.dart';

part 'expense_event_data.g.dart';

@freezed
abstract class ExpenseEventData
    with _$ExpenseEventData
    implements GameEventData {
  factory ExpenseEventData({
    @required int expense,
    @nullable InsuranceType insuranceType,
  }) = _ExpenseEventData;

  factory ExpenseEventData.fromJson(Map<String, dynamic> json) =>
      _$ExpenseEventDataFromJson(json);
}
