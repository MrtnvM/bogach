// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Game _$GameFromJson(Map<String, dynamic> json) {
  return _Game.fromJson(json);
}

class _$GameTearOff {
  const _$GameTearOff();

  _Game call(
      {@required String id,
      @required String name,
      @required String type,
      @required CurrentGameState state,
      @required List<String> participants,
      @required Map<String, PossessionState> possessionState,
      @required Map<String, Account> accounts,
      @required Target target}) {
    return _Game(
      id: id,
      name: name,
      type: type,
      state: state,
      participants: participants,
      possessionState: possessionState,
      accounts: accounts,
      target: target,
    );
  }
}

// ignore: unused_element
const $Game = _$GameTearOff();

mixin _$Game {
  String get id;
  String get name;
  String get type;
  CurrentGameState get state;
  List<String> get participants;
  Map<String, PossessionState> get possessionState;
  Map<String, Account> get accounts;
  Target get target;

  Map<String, dynamic> toJson();
  $GameCopyWith<Game> get copyWith;
}

abstract class $GameCopyWith<$Res> {
  factory $GameCopyWith(Game value, $Res Function(Game) then) =
      _$GameCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String type,
      CurrentGameState state,
      List<String> participants,
      Map<String, PossessionState> possessionState,
      Map<String, Account> accounts,
      Target target});

  $CurrentGameStateCopyWith<$Res> get state;
  $TargetCopyWith<$Res> get target;
}

class _$GameCopyWithImpl<$Res> implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._value, this._then);

  final Game _value;
  // ignore: unused_field
  final $Res Function(Game) _then;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object type = freezed,
    Object state = freezed,
    Object participants = freezed,
    Object possessionState = freezed,
    Object accounts = freezed,
    Object target = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as String,
      state: state == freezed ? _value.state : state as CurrentGameState,
      participants: participants == freezed
          ? _value.participants
          : participants as List<String>,
      possessionState: possessionState == freezed
          ? _value.possessionState
          : possessionState as Map<String, PossessionState>,
      accounts: accounts == freezed
          ? _value.accounts
          : accounts as Map<String, Account>,
      target: target == freezed ? _value.target : target as Target,
    ));
  }

  @override
  $CurrentGameStateCopyWith<$Res> get state {
    if (_value.state == null) {
      return null;
    }
    return $CurrentGameStateCopyWith<$Res>(_value.state, (value) {
      return _then(_value.copyWith(state: value));
    });
  }

  @override
  $TargetCopyWith<$Res> get target {
    if (_value.target == null) {
      return null;
    }
    return $TargetCopyWith<$Res>(_value.target, (value) {
      return _then(_value.copyWith(target: value));
    });
  }
}

abstract class _$GameCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$GameCopyWith(_Game value, $Res Function(_Game) then) =
      __$GameCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String type,
      CurrentGameState state,
      List<String> participants,
      Map<String, PossessionState> possessionState,
      Map<String, Account> accounts,
      Target target});

  @override
  $CurrentGameStateCopyWith<$Res> get state;
  @override
  $TargetCopyWith<$Res> get target;
}

class __$GameCopyWithImpl<$Res> extends _$GameCopyWithImpl<$Res>
    implements _$GameCopyWith<$Res> {
  __$GameCopyWithImpl(_Game _value, $Res Function(_Game) _then)
      : super(_value, (v) => _then(v as _Game));

  @override
  _Game get _value => super._value as _Game;

  @override
  $Res call({
    Object id = freezed,
    Object name = freezed,
    Object type = freezed,
    Object state = freezed,
    Object participants = freezed,
    Object possessionState = freezed,
    Object accounts = freezed,
    Object target = freezed,
  }) {
    return _then(_Game(
      id: id == freezed ? _value.id : id as String,
      name: name == freezed ? _value.name : name as String,
      type: type == freezed ? _value.type : type as String,
      state: state == freezed ? _value.state : state as CurrentGameState,
      participants: participants == freezed
          ? _value.participants
          : participants as List<String>,
      possessionState: possessionState == freezed
          ? _value.possessionState
          : possessionState as Map<String, PossessionState>,
      accounts: accounts == freezed
          ? _value.accounts
          : accounts as Map<String, Account>,
      target: target == freezed ? _value.target : target as Target,
    ));
  }
}

@JsonSerializable()
class _$_Game implements _Game {
  _$_Game(
      {@required this.id,
      @required this.name,
      @required this.type,
      @required this.state,
      @required this.participants,
      @required this.possessionState,
      @required this.accounts,
      @required this.target})
      : assert(id != null),
        assert(name != null),
        assert(type != null),
        assert(state != null),
        assert(participants != null),
        assert(possessionState != null),
        assert(accounts != null),
        assert(target != null);

  factory _$_Game.fromJson(Map<String, dynamic> json) =>
      _$_$_GameFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
  @override
  final CurrentGameState state;
  @override
  final List<String> participants;
  @override
  final Map<String, PossessionState> possessionState;
  @override
  final Map<String, Account> accounts;
  @override
  final Target target;

  @override
  String toString() {
    return 'Game(id: $id, name: $name, type: $type, state: $state, participants: $participants, possessionState: $possessionState, accounts: $accounts, target: $target)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Game &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)) &&
            (identical(other.participants, participants) ||
                const DeepCollectionEquality()
                    .equals(other.participants, participants)) &&
            (identical(other.possessionState, possessionState) ||
                const DeepCollectionEquality()
                    .equals(other.possessionState, possessionState)) &&
            (identical(other.accounts, accounts) ||
                const DeepCollectionEquality()
                    .equals(other.accounts, accounts)) &&
            (identical(other.target, target) ||
                const DeepCollectionEquality().equals(other.target, target)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(state) ^
      const DeepCollectionEquality().hash(participants) ^
      const DeepCollectionEquality().hash(possessionState) ^
      const DeepCollectionEquality().hash(accounts) ^
      const DeepCollectionEquality().hash(target);

  @override
  _$GameCopyWith<_Game> get copyWith =>
      __$GameCopyWithImpl<_Game>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_GameToJson(this);
  }
}

abstract class _Game implements Game {
  factory _Game(
      {@required String id,
      @required String name,
      @required String type,
      @required CurrentGameState state,
      @required List<String> participants,
      @required Map<String, PossessionState> possessionState,
      @required Map<String, Account> accounts,
      @required Target target}) = _$_Game;

  factory _Game.fromJson(Map<String, dynamic> json) = _$_Game.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override
  CurrentGameState get state;
  @override
  List<String> get participants;
  @override
  Map<String, PossessionState> get possessionState;
  @override
  Map<String, Account> get accounts;
  @override
  Target get target;
  @override
  _$GameCopyWith<_Game> get copyWith;
}
