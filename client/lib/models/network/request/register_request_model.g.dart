// GENERATED CODE - DO NOT MODIFY BY HAND

part of register_request_model;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RegisterRequestModel extends RegisterRequestModel {
  @override
  final String nickName;
  @override
  final String email;
  @override
  final String password;
  @override
  final String repeatPassword;

  factory _$RegisterRequestModel(
          [void Function(RegisterRequestModelBuilder) updates]) =>
      (new RegisterRequestModelBuilder()..update(updates)).build();

  _$RegisterRequestModel._(
      {this.nickName, this.email, this.password, this.repeatPassword})
      : super._() {
    if (nickName == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'nickName');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'email');
    }
    if (password == null) {
      throw new BuiltValueNullFieldError('RegisterRequestModel', 'password');
    }
    if (repeatPassword == null) {
      throw new BuiltValueNullFieldError(
          'RegisterRequestModel', 'repeatPassword');
    }
  }

  @override
  RegisterRequestModel rebuild(
          void Function(RegisterRequestModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterRequestModelBuilder toBuilder() =>
      new RegisterRequestModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterRequestModel &&
        nickName == other.nickName &&
        email == other.email &&
        password == other.password &&
        repeatPassword == other.repeatPassword;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, nickName.hashCode), email.hashCode), password.hashCode),
        repeatPassword.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('RegisterRequestModel')
          ..add('nickName', nickName)
          ..add('email', email)
          ..add('password', password)
          ..add('repeatPassword', repeatPassword))
        .toString();
  }
}

class RegisterRequestModelBuilder
    implements Builder<RegisterRequestModel, RegisterRequestModelBuilder> {
  _$RegisterRequestModel _$v;

  String _nickName;
  String get nickName => _$this._nickName;
  set nickName(String nickName) => _$this._nickName = nickName;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _password;
  String get password => _$this._password;
  set password(String password) => _$this._password = password;

  String _repeatPassword;
  String get repeatPassword => _$this._repeatPassword;
  set repeatPassword(String repeatPassword) =>
      _$this._repeatPassword = repeatPassword;

  RegisterRequestModelBuilder();

  RegisterRequestModelBuilder get _$this {
    if (_$v != null) {
      _nickName = _$v.nickName;
      _email = _$v.email;
      _password = _$v.password;
      _repeatPassword = _$v.repeatPassword;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterRequestModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$RegisterRequestModel;
  }

  @override
  void update(void Function(RegisterRequestModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$RegisterRequestModel build() {
    final _$result = _$v ??
        new _$RegisterRequestModel._(
            nickName: nickName,
            email: email,
            password: password,
            repeatPassword: repeatPassword);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
