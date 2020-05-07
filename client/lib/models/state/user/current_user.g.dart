// GENERATED CODE - DO NOT MODIFY BY HAND

part of current_user;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CurrentUser extends CurrentUser {
  @override
  final String fullName;
  @override
  final String avatarUrl;
  @override
  final String userId;

  factory _$CurrentUser([void Function(CurrentUserBuilder) updates]) =>
      (new CurrentUserBuilder()..update(updates)).build();

  _$CurrentUser._({this.fullName, this.avatarUrl, this.userId}) : super._() {
    if (fullName == null) {
      throw new BuiltValueNullFieldError('CurrentUser', 'fullName');
    }
    if (userId == null) {
      throw new BuiltValueNullFieldError('CurrentUser', 'userId');
    }
  }

  @override
  CurrentUser rebuild(void Function(CurrentUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CurrentUserBuilder toBuilder() => new CurrentUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CurrentUser &&
        fullName == other.fullName &&
        avatarUrl == other.avatarUrl &&
        userId == other.userId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc(0, fullName.hashCode), avatarUrl.hashCode), userId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CurrentUser')
          ..add('fullName', fullName)
          ..add('avatarUrl', avatarUrl)
          ..add('userId', userId))
        .toString();
  }
}

class CurrentUserBuilder implements Builder<CurrentUser, CurrentUserBuilder> {
  _$CurrentUser _$v;

  String _fullName;
  String get fullName => _$this._fullName;
  set fullName(String fullName) => _$this._fullName = fullName;

  String _avatarUrl;
  String get avatarUrl => _$this._avatarUrl;
  set avatarUrl(String avatarUrl) => _$this._avatarUrl = avatarUrl;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  CurrentUserBuilder();

  CurrentUserBuilder get _$this {
    if (_$v != null) {
      _fullName = _$v.fullName;
      _avatarUrl = _$v.avatarUrl;
      _userId = _$v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CurrentUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CurrentUser;
  }

  @override
  void update(void Function(CurrentUserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CurrentUser build() {
    final _$result = _$v ??
        new _$CurrentUser._(
            fullName: fullName, avatarUrl: avatarUrl, userId: userId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
