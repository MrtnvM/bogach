// GENERATED CODE - DO NOT MODIFY BY HAND

part of network;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RequestState _$idle = const RequestState._('idle');
const RequestState _$inProgress = const RequestState._('inProgress');
const RequestState _$success = const RequestState._('success');
const RequestState _$error = const RequestState._('error');

RequestState _$valueOf(String name) {
  switch (name) {
    case 'idle':
      return _$idle;
    case 'inProgress':
      return _$inProgress;
    case 'success':
      return _$success;
    case 'error':
      return _$error;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RequestState> _$values =
    new BuiltSet<RequestState>(const <RequestState>[
  _$idle,
  _$inProgress,
  _$success,
  _$error,
]);

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
