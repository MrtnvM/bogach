// GENERATED CODE - DO NOT MODIFY BY HAND

part of new_game_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$NewGameState extends NewGameState {
  @override
  final RefreshableRequestState getGameTemplatesRequestState;
  @override
  final StoreList<GameTemplate> gameTemplates;
  @override
  final RequestState createNewGameRequestState;
  @override
  final String newGameId;

  factory _$NewGameState([void Function(NewGameStateBuilder) updates]) =>
      (new NewGameStateBuilder()..update(updates)).build();

  _$NewGameState._(
      {this.getGameTemplatesRequestState,
      this.gameTemplates,
      this.createNewGameRequestState,
      this.newGameId})
      : super._() {
    if (getGameTemplatesRequestState == null) {
      throw new BuiltValueNullFieldError(
          'NewGameState', 'getGameTemplatesRequestState');
    }
    if (gameTemplates == null) {
      throw new BuiltValueNullFieldError('NewGameState', 'gameTemplates');
    }
    if (createNewGameRequestState == null) {
      throw new BuiltValueNullFieldError(
          'NewGameState', 'createNewGameRequestState');
    }
  }

  @override
  NewGameState rebuild(void Function(NewGameStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NewGameStateBuilder toBuilder() => new NewGameStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NewGameState &&
        getGameTemplatesRequestState == other.getGameTemplatesRequestState &&
        gameTemplates == other.gameTemplates &&
        createNewGameRequestState == other.createNewGameRequestState &&
        newGameId == other.newGameId;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc(0, getGameTemplatesRequestState.hashCode),
                gameTemplates.hashCode),
            createNewGameRequestState.hashCode),
        newGameId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('NewGameState')
          ..add('getGameTemplatesRequestState', getGameTemplatesRequestState)
          ..add('gameTemplates', gameTemplates)
          ..add('createNewGameRequestState', createNewGameRequestState)
          ..add('newGameId', newGameId))
        .toString();
  }
}

class NewGameStateBuilder
    implements Builder<NewGameState, NewGameStateBuilder> {
  _$NewGameState _$v;

  RefreshableRequestState _getGameTemplatesRequestState;
  RefreshableRequestState get getGameTemplatesRequestState =>
      _$this._getGameTemplatesRequestState;
  set getGameTemplatesRequestState(
          RefreshableRequestState getGameTemplatesRequestState) =>
      _$this._getGameTemplatesRequestState = getGameTemplatesRequestState;

  StoreList<GameTemplate> _gameTemplates;
  StoreList<GameTemplate> get gameTemplates => _$this._gameTemplates;
  set gameTemplates(StoreList<GameTemplate> gameTemplates) =>
      _$this._gameTemplates = gameTemplates;

  RequestState _createNewGameRequestState;
  RequestState get createNewGameRequestState =>
      _$this._createNewGameRequestState;
  set createNewGameRequestState(RequestState createNewGameRequestState) =>
      _$this._createNewGameRequestState = createNewGameRequestState;

  String _newGameId;
  String get newGameId => _$this._newGameId;
  set newGameId(String newGameId) => _$this._newGameId = newGameId;

  NewGameStateBuilder();

  NewGameStateBuilder get _$this {
    if (_$v != null) {
      _getGameTemplatesRequestState = _$v.getGameTemplatesRequestState;
      _gameTemplates = _$v.gameTemplates;
      _createNewGameRequestState = _$v.createNewGameRequestState;
      _newGameId = _$v.newGameId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NewGameState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$NewGameState;
  }

  @override
  void update(void Function(NewGameStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$NewGameState build() {
    final _$result = _$v ??
        new _$NewGameState._(
            getGameTemplatesRequestState: getGameTemplatesRequestState,
            gameTemplates: gameTemplates,
            createNewGameRequestState: createNewGameRequestState,
            newGameId: newGameId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
