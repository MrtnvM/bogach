// GENERATED CODE - DO NOT MODIFY BY HAND

part of app_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final LoginState login;
  @override
  final GameState gameState;
  @override
  final NewGameState newGameState;
  @override
  final PurchaseState purchaseState;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._(
      {this.login, this.gameState, this.newGameState, this.purchaseState})
      : super._() {
    if (login == null) {
      throw new BuiltValueNullFieldError('AppState', 'login');
    }
    if (gameState == null) {
      throw new BuiltValueNullFieldError('AppState', 'gameState');
    }
    if (newGameState == null) {
      throw new BuiltValueNullFieldError('AppState', 'newGameState');
    }
    if (purchaseState == null) {
      throw new BuiltValueNullFieldError('AppState', 'purchaseState');
    }
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        login == other.login &&
        gameState == other.gameState &&
        newGameState == other.newGameState &&
        purchaseState == other.purchaseState;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, login.hashCode), gameState.hashCode),
            newGameState.hashCode),
        purchaseState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('login', login)
          ..add('gameState', gameState)
          ..add('newGameState', newGameState)
          ..add('purchaseState', purchaseState))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  LoginStateBuilder _login;
  LoginStateBuilder get login => _$this._login ??= new LoginStateBuilder();
  set login(LoginStateBuilder login) => _$this._login = login;

  GameStateBuilder _gameState;
  GameStateBuilder get gameState =>
      _$this._gameState ??= new GameStateBuilder();
  set gameState(GameStateBuilder gameState) => _$this._gameState = gameState;

  NewGameStateBuilder _newGameState;
  NewGameStateBuilder get newGameState =>
      _$this._newGameState ??= new NewGameStateBuilder();
  set newGameState(NewGameStateBuilder newGameState) =>
      _$this._newGameState = newGameState;

  PurchaseStateBuilder _purchaseState;
  PurchaseStateBuilder get purchaseState =>
      _$this._purchaseState ??= new PurchaseStateBuilder();
  set purchaseState(PurchaseStateBuilder purchaseState) =>
      _$this._purchaseState = purchaseState;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _login = _$v.login?.toBuilder();
      _gameState = _$v.gameState?.toBuilder();
      _newGameState = _$v.newGameState?.toBuilder();
      _purchaseState = _$v.purchaseState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              login: login.build(),
              gameState: gameState.build(),
              newGameState: newGameState.build(),
              purchaseState: purchaseState.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'login';
        login.build();
        _$failedField = 'gameState';
        gameState.build();
        _$failedField = 'newGameState';
        newGameState.build();
        _$failedField = 'purchaseState';
        purchaseState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
