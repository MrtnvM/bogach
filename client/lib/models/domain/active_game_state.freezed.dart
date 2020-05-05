// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'active_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

class _$ActiveGameStateTearOff {
  const _$ActiveGameStateTearOff();

  ActiveGameWaitingForStartState waitingForStart() {
    return ActiveGameWaitingForStartState();
  }

  ActiveGameGameEventState gameEvent(
      {@required int eventIndex, @required bool isSent}) {
    return ActiveGameGameEventState(
      eventIndex: eventIndex,
      isSent: isSent,
    );
  }

  ActiveGameWaitingPlayersState waitingPlayers(List<String> playersIds) {
    return ActiveGameWaitingPlayersState(
      playersIds,
    );
  }

  ActiveGameMonthResultState monthResult() {
    return ActiveGameMonthResultState();
  }

  ActiveGameGameOverState gameOver(
      {@required Map<int, String> winners, @required int monthNumber}) {
    return ActiveGameGameOverState(
      winners: winners,
      monthNumber: monthNumber,
    );
  }
}

// ignore: unused_element
const $ActiveGameState = _$ActiveGameStateTearOff();

mixin _$ActiveGameState {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result waitingForStart(),
    @required Result gameEvent(int eventIndex, bool isSent),
    @required Result waitingPlayers(List<String> playersIds),
    @required Result monthResult(),
    @required Result gameOver(Map<int, String> winners, int monthNumber),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result waitingForStart(),
    Result gameEvent(int eventIndex, bool isSent),
    Result waitingPlayers(List<String> playersIds),
    Result monthResult(),
    Result gameOver(Map<int, String> winners, int monthNumber),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result waitingForStart(ActiveGameWaitingForStartState value),
    @required Result gameEvent(ActiveGameGameEventState value),
    @required Result waitingPlayers(ActiveGameWaitingPlayersState value),
    @required Result monthResult(ActiveGameMonthResultState value),
    @required Result gameOver(ActiveGameGameOverState value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result waitingForStart(ActiveGameWaitingForStartState value),
    Result gameEvent(ActiveGameGameEventState value),
    Result waitingPlayers(ActiveGameWaitingPlayersState value),
    Result monthResult(ActiveGameMonthResultState value),
    Result gameOver(ActiveGameGameOverState value),
    @required Result orElse(),
  });
}

abstract class $ActiveGameStateCopyWith<$Res> {
  factory $ActiveGameStateCopyWith(
          ActiveGameState value, $Res Function(ActiveGameState) then) =
      _$ActiveGameStateCopyWithImpl<$Res>;
}

class _$ActiveGameStateCopyWithImpl<$Res>
    implements $ActiveGameStateCopyWith<$Res> {
  _$ActiveGameStateCopyWithImpl(this._value, this._then);

  final ActiveGameState _value;
  // ignore: unused_field
  final $Res Function(ActiveGameState) _then;
}

abstract class $ActiveGameWaitingForStartStateCopyWith<$Res> {
  factory $ActiveGameWaitingForStartStateCopyWith(
          ActiveGameWaitingForStartState value,
          $Res Function(ActiveGameWaitingForStartState) then) =
      _$ActiveGameWaitingForStartStateCopyWithImpl<$Res>;
}

class _$ActiveGameWaitingForStartStateCopyWithImpl<$Res>
    extends _$ActiveGameStateCopyWithImpl<$Res>
    implements $ActiveGameWaitingForStartStateCopyWith<$Res> {
  _$ActiveGameWaitingForStartStateCopyWithImpl(
      ActiveGameWaitingForStartState _value,
      $Res Function(ActiveGameWaitingForStartState) _then)
      : super(_value, (v) => _then(v as ActiveGameWaitingForStartState));

  @override
  ActiveGameWaitingForStartState get _value =>
      super._value as ActiveGameWaitingForStartState;
}

class _$ActiveGameWaitingForStartState extends ActiveGameWaitingForStartState {
  _$ActiveGameWaitingForStartState() : super._();

  @override
  String toString() {
    return 'ActiveGameState.waitingForStart()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is ActiveGameWaitingForStartState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result waitingForStart(),
    @required Result gameEvent(int eventIndex, bool isSent),
    @required Result waitingPlayers(List<String> playersIds),
    @required Result monthResult(),
    @required Result gameOver(Map<int, String> winners, int monthNumber),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return waitingForStart();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result waitingForStart(),
    Result gameEvent(int eventIndex, bool isSent),
    Result waitingPlayers(List<String> playersIds),
    Result monthResult(),
    Result gameOver(Map<int, String> winners, int monthNumber),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (waitingForStart != null) {
      return waitingForStart();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result waitingForStart(ActiveGameWaitingForStartState value),
    @required Result gameEvent(ActiveGameGameEventState value),
    @required Result waitingPlayers(ActiveGameWaitingPlayersState value),
    @required Result monthResult(ActiveGameMonthResultState value),
    @required Result gameOver(ActiveGameGameOverState value),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return waitingForStart(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result waitingForStart(ActiveGameWaitingForStartState value),
    Result gameEvent(ActiveGameGameEventState value),
    Result waitingPlayers(ActiveGameWaitingPlayersState value),
    Result monthResult(ActiveGameMonthResultState value),
    Result gameOver(ActiveGameGameOverState value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (waitingForStart != null) {
      return waitingForStart(this);
    }
    return orElse();
  }
}

abstract class ActiveGameWaitingForStartState extends ActiveGameState {
  ActiveGameWaitingForStartState._() : super._();
  factory ActiveGameWaitingForStartState() = _$ActiveGameWaitingForStartState;
}

abstract class $ActiveGameGameEventStateCopyWith<$Res> {
  factory $ActiveGameGameEventStateCopyWith(ActiveGameGameEventState value,
          $Res Function(ActiveGameGameEventState) then) =
      _$ActiveGameGameEventStateCopyWithImpl<$Res>;
  $Res call({int eventIndex, bool isSent});
}

class _$ActiveGameGameEventStateCopyWithImpl<$Res>
    extends _$ActiveGameStateCopyWithImpl<$Res>
    implements $ActiveGameGameEventStateCopyWith<$Res> {
  _$ActiveGameGameEventStateCopyWithImpl(ActiveGameGameEventState _value,
      $Res Function(ActiveGameGameEventState) _then)
      : super(_value, (v) => _then(v as ActiveGameGameEventState));

  @override
  ActiveGameGameEventState get _value =>
      super._value as ActiveGameGameEventState;

  @override
  $Res call({
    Object eventIndex = freezed,
    Object isSent = freezed,
  }) {
    return _then(ActiveGameGameEventState(
      eventIndex: eventIndex == freezed ? _value.eventIndex : eventIndex as int,
      isSent: isSent == freezed ? _value.isSent : isSent as bool,
    ));
  }
}

class _$ActiveGameGameEventState extends ActiveGameGameEventState {
  _$ActiveGameGameEventState({@required this.eventIndex, @required this.isSent})
      : assert(eventIndex != null),
        assert(isSent != null),
        super._();

  @override
  final int eventIndex;
  @override
  final bool isSent;

  @override
  String toString() {
    return 'ActiveGameState.gameEvent(eventIndex: $eventIndex, isSent: $isSent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ActiveGameGameEventState &&
            (identical(other.eventIndex, eventIndex) ||
                const DeepCollectionEquality()
                    .equals(other.eventIndex, eventIndex)) &&
            (identical(other.isSent, isSent) ||
                const DeepCollectionEquality().equals(other.isSent, isSent)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(eventIndex) ^
      const DeepCollectionEquality().hash(isSent);

  @override
  $ActiveGameGameEventStateCopyWith<ActiveGameGameEventState> get copyWith =>
      _$ActiveGameGameEventStateCopyWithImpl<ActiveGameGameEventState>(
          this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result waitingForStart(),
    @required Result gameEvent(int eventIndex, bool isSent),
    @required Result waitingPlayers(List<String> playersIds),
    @required Result monthResult(),
    @required Result gameOver(Map<int, String> winners, int monthNumber),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return gameEvent(eventIndex, isSent);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result waitingForStart(),
    Result gameEvent(int eventIndex, bool isSent),
    Result waitingPlayers(List<String> playersIds),
    Result monthResult(),
    Result gameOver(Map<int, String> winners, int monthNumber),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (gameEvent != null) {
      return gameEvent(eventIndex, isSent);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result waitingForStart(ActiveGameWaitingForStartState value),
    @required Result gameEvent(ActiveGameGameEventState value),
    @required Result waitingPlayers(ActiveGameWaitingPlayersState value),
    @required Result monthResult(ActiveGameMonthResultState value),
    @required Result gameOver(ActiveGameGameOverState value),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return gameEvent(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result waitingForStart(ActiveGameWaitingForStartState value),
    Result gameEvent(ActiveGameGameEventState value),
    Result waitingPlayers(ActiveGameWaitingPlayersState value),
    Result monthResult(ActiveGameMonthResultState value),
    Result gameOver(ActiveGameGameOverState value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (gameEvent != null) {
      return gameEvent(this);
    }
    return orElse();
  }
}

abstract class ActiveGameGameEventState extends ActiveGameState {
  ActiveGameGameEventState._() : super._();
  factory ActiveGameGameEventState(
      {@required int eventIndex,
      @required bool isSent}) = _$ActiveGameGameEventState;

  int get eventIndex;
  bool get isSent;
  $ActiveGameGameEventStateCopyWith<ActiveGameGameEventState> get copyWith;
}

abstract class $ActiveGameWaitingPlayersStateCopyWith<$Res> {
  factory $ActiveGameWaitingPlayersStateCopyWith(
          ActiveGameWaitingPlayersState value,
          $Res Function(ActiveGameWaitingPlayersState) then) =
      _$ActiveGameWaitingPlayersStateCopyWithImpl<$Res>;
  $Res call({List<String> playersIds});
}

class _$ActiveGameWaitingPlayersStateCopyWithImpl<$Res>
    extends _$ActiveGameStateCopyWithImpl<$Res>
    implements $ActiveGameWaitingPlayersStateCopyWith<$Res> {
  _$ActiveGameWaitingPlayersStateCopyWithImpl(
      ActiveGameWaitingPlayersState _value,
      $Res Function(ActiveGameWaitingPlayersState) _then)
      : super(_value, (v) => _then(v as ActiveGameWaitingPlayersState));

  @override
  ActiveGameWaitingPlayersState get _value =>
      super._value as ActiveGameWaitingPlayersState;

  @override
  $Res call({
    Object playersIds = freezed,
  }) {
    return _then(ActiveGameWaitingPlayersState(
      playersIds == freezed ? _value.playersIds : playersIds as List<String>,
    ));
  }
}

class _$ActiveGameWaitingPlayersState extends ActiveGameWaitingPlayersState {
  _$ActiveGameWaitingPlayersState(this.playersIds)
      : assert(playersIds != null),
        super._();

  @override
  final List<String> playersIds;

  @override
  String toString() {
    return 'ActiveGameState.waitingPlayers(playersIds: $playersIds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ActiveGameWaitingPlayersState &&
            (identical(other.playersIds, playersIds) ||
                const DeepCollectionEquality()
                    .equals(other.playersIds, playersIds)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(playersIds);

  @override
  $ActiveGameWaitingPlayersStateCopyWith<ActiveGameWaitingPlayersState>
      get copyWith => _$ActiveGameWaitingPlayersStateCopyWithImpl<
          ActiveGameWaitingPlayersState>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result waitingForStart(),
    @required Result gameEvent(int eventIndex, bool isSent),
    @required Result waitingPlayers(List<String> playersIds),
    @required Result monthResult(),
    @required Result gameOver(Map<int, String> winners, int monthNumber),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return waitingPlayers(playersIds);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result waitingForStart(),
    Result gameEvent(int eventIndex, bool isSent),
    Result waitingPlayers(List<String> playersIds),
    Result monthResult(),
    Result gameOver(Map<int, String> winners, int monthNumber),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (waitingPlayers != null) {
      return waitingPlayers(playersIds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result waitingForStart(ActiveGameWaitingForStartState value),
    @required Result gameEvent(ActiveGameGameEventState value),
    @required Result waitingPlayers(ActiveGameWaitingPlayersState value),
    @required Result monthResult(ActiveGameMonthResultState value),
    @required Result gameOver(ActiveGameGameOverState value),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return waitingPlayers(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result waitingForStart(ActiveGameWaitingForStartState value),
    Result gameEvent(ActiveGameGameEventState value),
    Result waitingPlayers(ActiveGameWaitingPlayersState value),
    Result monthResult(ActiveGameMonthResultState value),
    Result gameOver(ActiveGameGameOverState value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (waitingPlayers != null) {
      return waitingPlayers(this);
    }
    return orElse();
  }
}

abstract class ActiveGameWaitingPlayersState extends ActiveGameState {
  ActiveGameWaitingPlayersState._() : super._();
  factory ActiveGameWaitingPlayersState(List<String> playersIds) =
      _$ActiveGameWaitingPlayersState;

  List<String> get playersIds;
  $ActiveGameWaitingPlayersStateCopyWith<ActiveGameWaitingPlayersState>
      get copyWith;
}

abstract class $ActiveGameMonthResultStateCopyWith<$Res> {
  factory $ActiveGameMonthResultStateCopyWith(ActiveGameMonthResultState value,
          $Res Function(ActiveGameMonthResultState) then) =
      _$ActiveGameMonthResultStateCopyWithImpl<$Res>;
}

class _$ActiveGameMonthResultStateCopyWithImpl<$Res>
    extends _$ActiveGameStateCopyWithImpl<$Res>
    implements $ActiveGameMonthResultStateCopyWith<$Res> {
  _$ActiveGameMonthResultStateCopyWithImpl(ActiveGameMonthResultState _value,
      $Res Function(ActiveGameMonthResultState) _then)
      : super(_value, (v) => _then(v as ActiveGameMonthResultState));

  @override
  ActiveGameMonthResultState get _value =>
      super._value as ActiveGameMonthResultState;
}

class _$ActiveGameMonthResultState extends ActiveGameMonthResultState {
  _$ActiveGameMonthResultState() : super._();

  @override
  String toString() {
    return 'ActiveGameState.monthResult()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is ActiveGameMonthResultState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result waitingForStart(),
    @required Result gameEvent(int eventIndex, bool isSent),
    @required Result waitingPlayers(List<String> playersIds),
    @required Result monthResult(),
    @required Result gameOver(Map<int, String> winners, int monthNumber),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return monthResult();
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result waitingForStart(),
    Result gameEvent(int eventIndex, bool isSent),
    Result waitingPlayers(List<String> playersIds),
    Result monthResult(),
    Result gameOver(Map<int, String> winners, int monthNumber),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (monthResult != null) {
      return monthResult();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result waitingForStart(ActiveGameWaitingForStartState value),
    @required Result gameEvent(ActiveGameGameEventState value),
    @required Result waitingPlayers(ActiveGameWaitingPlayersState value),
    @required Result monthResult(ActiveGameMonthResultState value),
    @required Result gameOver(ActiveGameGameOverState value),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return monthResult(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result waitingForStart(ActiveGameWaitingForStartState value),
    Result gameEvent(ActiveGameGameEventState value),
    Result waitingPlayers(ActiveGameWaitingPlayersState value),
    Result monthResult(ActiveGameMonthResultState value),
    Result gameOver(ActiveGameGameOverState value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (monthResult != null) {
      return monthResult(this);
    }
    return orElse();
  }
}

abstract class ActiveGameMonthResultState extends ActiveGameState {
  ActiveGameMonthResultState._() : super._();
  factory ActiveGameMonthResultState() = _$ActiveGameMonthResultState;
}

abstract class $ActiveGameGameOverStateCopyWith<$Res> {
  factory $ActiveGameGameOverStateCopyWith(ActiveGameGameOverState value,
          $Res Function(ActiveGameGameOverState) then) =
      _$ActiveGameGameOverStateCopyWithImpl<$Res>;
  $Res call({Map<int, String> winners, int monthNumber});
}

class _$ActiveGameGameOverStateCopyWithImpl<$Res>
    extends _$ActiveGameStateCopyWithImpl<$Res>
    implements $ActiveGameGameOverStateCopyWith<$Res> {
  _$ActiveGameGameOverStateCopyWithImpl(ActiveGameGameOverState _value,
      $Res Function(ActiveGameGameOverState) _then)
      : super(_value, (v) => _then(v as ActiveGameGameOverState));

  @override
  ActiveGameGameOverState get _value => super._value as ActiveGameGameOverState;

  @override
  $Res call({
    Object winners = freezed,
    Object monthNumber = freezed,
  }) {
    return _then(ActiveGameGameOverState(
      winners:
          winners == freezed ? _value.winners : winners as Map<int, String>,
      monthNumber:
          monthNumber == freezed ? _value.monthNumber : monthNumber as int,
    ));
  }
}

class _$ActiveGameGameOverState extends ActiveGameGameOverState {
  _$ActiveGameGameOverState(
      {@required this.winners, @required this.monthNumber})
      : assert(winners != null),
        assert(monthNumber != null),
        super._();

  @override
  final Map<int, String> winners;
  @override
  final int monthNumber;

  @override
  String toString() {
    return 'ActiveGameState.gameOver(winners: $winners, monthNumber: $monthNumber)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is ActiveGameGameOverState &&
            (identical(other.winners, winners) ||
                const DeepCollectionEquality()
                    .equals(other.winners, winners)) &&
            (identical(other.monthNumber, monthNumber) ||
                const DeepCollectionEquality()
                    .equals(other.monthNumber, monthNumber)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(winners) ^
      const DeepCollectionEquality().hash(monthNumber);

  @override
  $ActiveGameGameOverStateCopyWith<ActiveGameGameOverState> get copyWith =>
      _$ActiveGameGameOverStateCopyWithImpl<ActiveGameGameOverState>(
          this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required Result waitingForStart(),
    @required Result gameEvent(int eventIndex, bool isSent),
    @required Result waitingPlayers(List<String> playersIds),
    @required Result monthResult(),
    @required Result gameOver(Map<int, String> winners, int monthNumber),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return gameOver(winners, monthNumber);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result waitingForStart(),
    Result gameEvent(int eventIndex, bool isSent),
    Result waitingPlayers(List<String> playersIds),
    Result monthResult(),
    Result gameOver(Map<int, String> winners, int monthNumber),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (gameOver != null) {
      return gameOver(winners, monthNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result waitingForStart(ActiveGameWaitingForStartState value),
    @required Result gameEvent(ActiveGameGameEventState value),
    @required Result waitingPlayers(ActiveGameWaitingPlayersState value),
    @required Result monthResult(ActiveGameMonthResultState value),
    @required Result gameOver(ActiveGameGameOverState value),
  }) {
    assert(waitingForStart != null);
    assert(gameEvent != null);
    assert(waitingPlayers != null);
    assert(monthResult != null);
    assert(gameOver != null);
    return gameOver(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result waitingForStart(ActiveGameWaitingForStartState value),
    Result gameEvent(ActiveGameGameEventState value),
    Result waitingPlayers(ActiveGameWaitingPlayersState value),
    Result monthResult(ActiveGameMonthResultState value),
    Result gameOver(ActiveGameGameOverState value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (gameOver != null) {
      return gameOver(this);
    }
    return orElse();
  }
}

abstract class ActiveGameGameOverState extends ActiveGameState {
  ActiveGameGameOverState._() : super._();
  factory ActiveGameGameOverState(
      {@required Map<int, String> winners,
      @required int monthNumber}) = _$ActiveGameGameOverState;

  Map<int, String> get winners;
  int get monthNumber;
  $ActiveGameGameOverStateCopyWith<ActiveGameGameOverState> get copyWith;
}
