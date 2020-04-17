// GENERATED CODE - DO NOT MODIFY BY HAND

part of registration_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegistrationState extends RegistrationState {
  @override
  final RequestState requestState;

  factory _$RegistrationState(
          [void Function(RegistrationStateBuilder) updates]) =>
      (new RegistrationStateBuilder()..update(updates)).build();

  _$RegistrationState._({this.requestState}) : super._() {
    if (requestState == null) {
      throw new BuiltValueNullFieldError('RegistrationState', 'requestState');
    }
  }

  @override
  RegistrationState rebuild(void Function(RegistrationStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegistrationStateBuilder toBuilder() =>
      new RegistrationStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegistrationState && requestState == other.requestState;
  }

  @override
  int get hashCode {
    return $jf($jc(0, requestState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RegistrationState')
          ..add('requestState', requestState))
        .toString();
  }
}

class RegistrationStateBuilder
    implements Builder<RegistrationState, RegistrationStateBuilder> {
  _$RegistrationState _$v;

  RequestState _requestState;
  RequestState get requestState => _$this._requestState;
  set requestState(RequestState requestState) =>
      _$this._requestState = requestState;

  RegistrationStateBuilder();

  RegistrationStateBuilder get _$this {
    if (_$v != null) {
      _requestState = _$v.requestState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegistrationState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RegistrationState;
  }

  @override
  void update(void Function(RegistrationStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RegistrationState build() {
    final _$result =
        _$v ?? new _$RegistrationState._(requestState: requestState);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
