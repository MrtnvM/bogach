// GENERATED CODE - DO NOT MODIFY BY HAND

part of login_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$LoginState extends LoginState {
  @override
  final RequestState loginRequestState;

  factory _$LoginState([void Function(LoginStateBuilder) updates]) =>
      (new LoginStateBuilder()..update(updates)).build();

  _$LoginState._({this.loginRequestState}) : super._() {
    if (loginRequestState == null) {
      throw new BuiltValueNullFieldError('LoginState', 'loginRequestState');
    }
  }

  @override
  LoginState rebuild(void Function(LoginStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginStateBuilder toBuilder() => new LoginStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginState && loginRequestState == other.loginRequestState;
  }

  @override
  int get hashCode {
    return $jf($jc(0, loginRequestState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('LoginState')
          ..add('loginRequestState', loginRequestState))
        .toString();
  }
}

class LoginStateBuilder implements Builder<LoginState, LoginStateBuilder> {
  _$LoginState _$v;

  RequestState _loginRequestState;
  RequestState get loginRequestState => _$this._loginRequestState;
  set loginRequestState(RequestState loginRequestState) =>
      _$this._loginRequestState = loginRequestState;

  LoginStateBuilder();

  LoginStateBuilder get _$this {
    if (_$v != null) {
      _loginRequestState = _$v.loginRequestState;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$LoginState;
  }

  @override
  void update(void Function(LoginStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$LoginState build() {
    final _$result =
        _$v ?? new _$LoginState._(loginRequestState: loginRequestState);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
