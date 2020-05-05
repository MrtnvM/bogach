// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'current_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
CurrentGameState _$CurrentGameStateFromJson(Map<String, dynamic> json) {
  return _CurrentGameState.fromJson(json);
}

class _$CurrentGameStateTearOff {
  const _$CurrentGameStateTearOff();

  _CurrentGameState call(
      {@JsonKey(name: 'gameState') GameStatus gameStatus,
      int monthNumber,
      Map<String, int> participantProgress,
      Map<int, String> winners}) {
    return _CurrentGameState(
      gameStatus: gameStatus,
      monthNumber: monthNumber,
      participantProgress: participantProgress,
      winners: winners,
    );
  }
}

// ignore: unused_element
const $CurrentGameState = _$CurrentGameStateTearOff();

mixin _$CurrentGameState {
  @JsonKey(name: 'gameState')
  GameStatus get gameStatus;
  int get monthNumber;
  Map<String, int> get participantProgress;
  Map<int, String> get winners;

  Map<String, dynamic> toJson();
  $CurrentGameStateCopyWith<CurrentGameState> get copyWith;
}

abstract class $CurrentGameStateCopyWith<$Res> {
  factory $CurrentGameStateCopyWith(
          CurrentGameState value, $Res Function(CurrentGameState) then) =
      _$CurrentGameStateCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'gameState') GameStatus gameStatus,
      int monthNumber,
      Map<String, int> participantProgress,
      Map<int, String> winners});
}

class _$CurrentGameStateCopyWithImpl<$Res>
    implements $CurrentGameStateCopyWith<$Res> {
  _$CurrentGameStateCopyWithImpl(this._value, this._then);

  final CurrentGameState _value;
  // ignore: unused_field
  final $Res Function(CurrentGameState) _then;

  @override
  $Res call({
    Object gameStatus = freezed,
    Object monthNumber = freezed,
    Object participantProgress = freezed,
    Object winners = freezed,
  }) {
    return _then(_value.copyWith(
      gameStatus:
          gameStatus == freezed ? _value.gameStatus : gameStatus as GameStatus,
      monthNumber:
          monthNumber == freezed ? _value.monthNumber : monthNumber as int,
      participantProgress: participantProgress == freezed
          ? _value.participantProgress
          : participantProgress as Map<String, int>,
      winners:
          winners == freezed ? _value.winners : winners as Map<int, String>,
    ));
  }
}

abstract class _$CurrentGameStateCopyWith<$Res>
    implements $CurrentGameStateCopyWith<$Res> {
  factory _$CurrentGameStateCopyWith(
          _CurrentGameState value, $Res Function(_CurrentGameState) then) =
      __$CurrentGameStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'gameState') GameStatus gameStatus,
      int monthNumber,
      Map<String, int> participantProgress,
      Map<int, String> winners});
}

class __$CurrentGameStateCopyWithImpl<$Res>
    extends _$CurrentGameStateCopyWithImpl<$Res>
    implements _$CurrentGameStateCopyWith<$Res> {
  __$CurrentGameStateCopyWithImpl(
      _CurrentGameState _value, $Res Function(_CurrentGameState) _then)
      : super(_value, (v) => _then(v as _CurrentGameState));

  @override
  _CurrentGameState get _value => super._value as _CurrentGameState;

  @override
  $Res call({
    Object gameStatus = freezed,
    Object monthNumber = freezed,
    Object participantProgress = freezed,
    Object winners = freezed,
  }) {
    return _then(_CurrentGameState(
      gameStatus:
          gameStatus == freezed ? _value.gameStatus : gameStatus as GameStatus,
      monthNumber:
          monthNumber == freezed ? _value.monthNumber : monthNumber as int,
      participantProgress: participantProgress == freezed
          ? _value.participantProgress
          : participantProgress as Map<String, int>,
      winners:
          winners == freezed ? _value.winners : winners as Map<int, String>,
    ));
  }
}

@JsonSerializable()
class _$_CurrentGameState implements _CurrentGameState {
  _$_CurrentGameState(
      {@JsonKey(name: 'gameState') this.gameStatus,
      this.monthNumber,
      this.participantProgress,
      this.winners});

  factory _$_CurrentGameState.fromJson(Map<String, dynamic> json) =>
      _$_$_CurrentGameStateFromJson(json);

  @override
  @JsonKey(name: 'gameState')
  final GameStatus gameStatus;
  @override
  final int monthNumber;
  @override
  final Map<String, int> participantProgress;
  @override
  final Map<int, String> winners;

  @override
  String toString() {
    return 'CurrentGameState(gameStatus: $gameStatus, monthNumber: $monthNumber, participantProgress: $participantProgress, winners: $winners)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _CurrentGameState &&
            (identical(other.gameStatus, gameStatus) ||
                const DeepCollectionEquality()
                    .equals(other.gameStatus, gameStatus)) &&
            (identical(other.monthNumber, monthNumber) ||
                const DeepCollectionEquality()
                    .equals(other.monthNumber, monthNumber)) &&
            (identical(other.participantProgress, participantProgress) ||
                const DeepCollectionEquality()
                    .equals(other.participantProgress, participantProgress)) &&
            (identical(other.winners, winners) ||
                const DeepCollectionEquality().equals(other.winners, winners)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(gameStatus) ^
      const DeepCollectionEquality().hash(monthNumber) ^
      const DeepCollectionEquality().hash(participantProgress) ^
      const DeepCollectionEquality().hash(winners);

  @override
  _$CurrentGameStateCopyWith<_CurrentGameState> get copyWith =>
      __$CurrentGameStateCopyWithImpl<_CurrentGameState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_CurrentGameStateToJson(this);
  }
}

abstract class _CurrentGameState implements CurrentGameState {
  factory _CurrentGameState(
      {@JsonKey(name: 'gameState') GameStatus gameStatus,
      int monthNumber,
      Map<String, int> participantProgress,
      Map<int, String> winners}) = _$_CurrentGameState;

  factory _CurrentGameState.fromJson(Map<String, dynamic> json) =
      _$_CurrentGameState.fromJson;

  @override
  @JsonKey(name: 'gameState')
  GameStatus get gameStatus;
  @override
  int get monthNumber;
  @override
  Map<String, int> get participantProgress;
  @override
  Map<int, String> get winners;
  @override
  _$CurrentGameStateCopyWith<_CurrentGameState> get copyWith;
}
