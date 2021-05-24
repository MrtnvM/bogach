import 'package:freezed_annotation/freezed_annotation.dart';

part 'winner.freezed.dart';
part 'winner.g.dart';

@freezed
class Winner with _$Winner {
  factory Winner({
    required String userId,
    required double targetValue,
  }) = _Winner;

  factory Winner.fromJson(Map<String, dynamic> json) => _$WinnerFromJson(json);
}
