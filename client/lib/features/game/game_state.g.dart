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
  final UserPossessionState possessions;
  @override
  final TargetState target;
  @override
  final Account account;
  @override
  final BuiltList<GameEvent> events;
  @override
  final GameContext currentGameContext;

  factory _$GameState([void Function(GameStateBuilder) updates]) =>
      (new GameStateBuilder()..update(updates)).build();

  _$GameState._(
      {this.getRequestState,
      this.activeGameState,
      this.possessions,
      this.target,
      this.account,
      this.events,
      this.currentGameContext})
      : super._() {
    if (getRequestState == null) {
      throw new BuiltValueNullFieldError('GameState', 'getRequestState');
    }
    if (activeGameState == null) {
      throw new BuiltValueNullFieldError('GameState', 'activeGameState');
    }
    if (events == null) {
      throw new BuiltValueNullFieldError('GameState', 'events');
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
        possessions == other.possessions &&
        target == other.target &&
        account == other.account &&
        events == other.events &&
        currentGameContext == other.currentGameContext;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc(0, getRequestState.hashCode),
                            activeGameState.hashCode),
                        possessions.hashCode),
                    target.hashCode),
                account.hashCode),
            events.hashCode),
        currentGameContext.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GameState')
          ..add('getRequestState', getRequestState)
          ..add('activeGameState', activeGameState)
          ..add('possessions', possessions)
          ..add('target', target)
          ..add('account', account)
          ..add('events', events)
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

  UserPossessionStateBuilder _possessions;
  UserPossessionStateBuilder get possessions =>
      _$this._possessions ??= new UserPossessionStateBuilder();
  set possessions(UserPossessionStateBuilder possessions) =>
      _$this._possessions = possessions;

  TargetStateBuilder _target;
  TargetStateBuilder get target => _$this._target ??= new TargetStateBuilder();
  set target(TargetStateBuilder target) => _$this._target = target;

  Account _account;
  Account get account => _$this._account;
  set account(Account account) => _$this._account = account;

  ListBuilder<GameEvent> _events;
  ListBuilder<GameEvent> get events =>
      _$this._events ??= new ListBuilder<GameEvent>();
  set events(ListBuilder<GameEvent> events) => _$this._events = events;

  GameContext _currentGameContext;
  GameContext get currentGameContext => _$this._currentGameContext;
  set currentGameContext(GameContext currentGameContext) =>
      _$this._currentGameContext = currentGameContext;

  GameStateBuilder();

  GameStateBuilder get _$this {
    if (_$v != null) {
      _getRequestState = _$v.getRequestState;
      _activeGameState = _$v.activeGameState;
      _possessions = _$v.possessions?.toBuilder();
      _target = _$v.target?.toBuilder();
      _account = _$v.account;
      _events = _$v.events?.toBuilder();
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
    _$GameState _$result;
    try {
      _$result = _$v ??
          new _$GameState._(
              getRequestState: getRequestState,
              activeGameState: activeGameState,
              possessions: _possessions?.build(),
              target: _target?.build(),
              account: account,
              events: events.build(),
              currentGameContext: currentGameContext);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'possessions';
        _possessions?.build();
        _$failedField = 'target';
        _target?.build();

        _$failedField = 'events';
        events.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'GameState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
