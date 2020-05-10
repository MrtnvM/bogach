// GENERATED CODE - DO NOT MODIFY BY HAND

part of game_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GameState extends GameState {
  @override
  final RequestState getRequestState;
  @override
  final ActiveGameState activeGameState;
  @override
  final Game currentGame;
  @override
  final GameContext currentGameContext;

  factory _$GameState([void Function(GameStateBuilder) updates]) =>
      (new GameStateBuilder()..update(updates)).build();

  _$GameState._(
      {this.getRequestState,
      this.activeGameState,
      this.currentGame,
      this.currentGameContext})
      : super._() {
    if (getRequestState == null) {
      throw new BuiltValueNullFieldError('GameState', 'getRequestState');
    }
    if (activeGameState == null) {
      throw new BuiltValueNullFieldError('GameState', 'activeGameState');
    }
  }

  @override
  GameState rebuild(void Function(GameStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameStateBuilder toBuilder() => new GameStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameState &&
        getRequestState == other.getRequestState &&
        activeGameState == other.activeGameState &&
        currentGame == other.currentGame &&
        currentGameContext == other.currentGameContext;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, getRequestState.hashCode), activeGameState.hashCode),
            currentGame.hashCode),
        currentGameContext.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GameState')
          ..add('getRequestState', getRequestState)
          ..add('activeGameState', activeGameState)
          ..add('currentGame', currentGame)
          ..add('currentGameContext', currentGameContext))
        .toString();
  }
}

class GameStateBuilder implements Builder<GameState, GameStateBuilder> {
  _$GameState _$v;

  RequestState _getRequestState;
  RequestState get getRequestState => _$this._getRequestState;
  set getRequestState(RequestState getRequestState) =>
      _$this._getRequestState = getRequestState;

  ActiveGameState _activeGameState;
  ActiveGameState get activeGameState => _$this._activeGameState;
  set activeGameState(ActiveGameState activeGameState) =>
      _$this._activeGameState = activeGameState;

  Game _currentGame;
  Game get currentGame => _$this._currentGame;
  set currentGame(Game currentGame) => _$this._currentGame = currentGame;

  GameContext _currentGameContext;
  GameContext get currentGameContext => _$this._currentGameContext;
  set currentGameContext(GameContext currentGameContext) =>
      _$this._currentGameContext = currentGameContext;

  GameStateBuilder();

  GameStateBuilder get _$this {
    if (_$v != null) {
      _getRequestState = _$v.getRequestState;
      _activeGameState = _$v.activeGameState;
      _currentGame = _$v.currentGame;
      _currentGameContext = _$v.currentGameContext;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GameState;
  }

  @override
  void update(void Function(GameStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GameState build() {
    final _$result = _$v ??
        new _$GameState._(
            getRequestState: getRequestState,
            activeGameState: activeGameState,
            currentGame: currentGame,
            currentGameContext: currentGameContext);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
