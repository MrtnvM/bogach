library network;

import 'package:built_value/built_value.dart';
import 'package:built_collection/built_collection.dart';

part 'request_state.g.dart';

class RequestState extends EnumClass {
  const RequestState._(String name) : super(name);

  static const RequestState idle = _$idle;
  static const RequestState inProgress = _$inProgress;
  static const RequestState success = _$success;
  static const RequestState error = _$error;

  static BuiltSet<RequestState> get values => _$values;

  static RequestState valueOf(String name) => _$valueOf(name);

  bool get isInProgress => this == RequestState.inProgress;

  bool get isIdle => this == RequestState.idle;

  bool get isSucceed => this == RequestState.success;

  bool get isFailed => this == RequestState.error;
}
