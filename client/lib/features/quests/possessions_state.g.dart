// GENERATED CODE - DO NOT MODIFY BY HAND

part of possessions_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PossessionsState extends PossessionsState {
  @override
  final RequestState getRequestState;
  @override
  final UserPossessionState userPossessionsState;

  factory _$PossessionsState(
          [void Function(PossessionsStateBuilder) updates]) =>
      (new PossessionsStateBuilder()..update(updates)).build();

  _$PossessionsState._({this.getRequestState, this.userPossessionsState})
      : super._() {
    if (getRequestState == null) {
      throw new BuiltValueNullFieldError('PossessionsState', 'getRequestState');
    }
  }

  @override
  PossessionsState rebuild(void Function(PossessionsStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PossessionsStateBuilder toBuilder() =>
      new PossessionsStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PossessionsState &&
        getRequestState == other.getRequestState &&
        userPossessionsState == other.userPossessionsState;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc(0, getRequestState.hashCode), userPossessionsState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PossessionsState')
          ..add('getRequestState', getRequestState)
          ..add('userPossessionsState', userPossessionsState))
        .toString();
  }
}

class PossessionsStateBuilder
    implements Builder<PossessionsState, PossessionsStateBuilder> {
  _$PossessionsState _$v;

  RequestState _getRequestState;
  RequestState get getRequestState => _$this._getRequestState;
  set getRequestState(RequestState getRequestState) =>
      _$this._getRequestState = getRequestState;

  UserPossessionStateBuilder _userPossessionsState;
  UserPossessionStateBuilder get userPossessionsState =>
      _$this._userPossessionsState ??= new UserPossessionStateBuilder();
  set userPossessionsState(UserPossessionStateBuilder userPossessionsState) =>
      _$this._userPossessionsState = userPossessionsState;

  PossessionsStateBuilder();

  PossessionsStateBuilder get _$this {
    if (_$v != null) {
      _getRequestState = _$v.getRequestState;
      _userPossessionsState = _$v.userPossessionsState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PossessionsState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PossessionsState;
  }

  @override
  void update(void Function(PossessionsStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PossessionsState build() {
    _$PossessionsState _$result;
    try {
      _$result = _$v ??
          new _$PossessionsState._(
              getRequestState: getRequestState,
              userPossessionsState: _userPossessionsState?.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'userPossessionsState';
        _userPossessionsState?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'PossessionsState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
