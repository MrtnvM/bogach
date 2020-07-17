import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'domain_game_error.freezed.dart';
part 'domain_game_error.g.dart';

@freezed
abstract class DomainGameError with _$DomainGameError {
  factory DomainGameError({
    @required String type,
    @required String code,
    @required Map<String, String> message,
  }) = _DomainGameError;

  factory DomainGameError.fromJson(Map<String, dynamic> json) =>
      _$DomainGameErrorFromJson(json);
}
