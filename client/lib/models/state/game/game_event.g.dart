// GENERATED CODE - DO NOT MODIFY BY HAND

part of game_event;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GameEvent extends GameEvent {
  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final GameEventType type;
  @override
  final GameEventData data;

  factory _$GameEvent([void Function(GameEventBuilder) updates]) =>
      (new GameEventBuilder()..update(updates)).build();

  _$GameEvent._({this.id, this.name, this.description, this.type, this.data})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('GameEvent', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('GameEvent', 'name');
    }
    if (description == null) {
      throw new BuiltValueNullFieldError('GameEvent', 'description');
    }
    if (type == null) {
      throw new BuiltValueNullFieldError('GameEvent', 'type');
    }
    if (data == null) {
      throw new BuiltValueNullFieldError('GameEvent', 'data');
    }
  }

  @override
  GameEvent rebuild(void Function(GameEventBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameEventBuilder toBuilder() => new GameEventBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameEvent &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        type == other.type &&
        data == other.data;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), name.hashCode), description.hashCode),
            type.hashCode),
        data.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GameEvent')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('type', type)
          ..add('data', data))
        .toString();
  }
}

class GameEventBuilder implements Builder<GameEvent, GameEventBuilder> {
  _$GameEvent _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  GameEventType _type;
  GameEventType get type => _$this._type;
  set type(GameEventType type) => _$this._type = type;

  GameEventDataBuilder _data;
  GameEventDataBuilder get data => _$this._data ??= new GameEventDataBuilder();
  set data(GameEventDataBuilder data) => _$this._data = data;

  GameEventBuilder();

  GameEventBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _description = _$v.description;
      _type = _$v.type;
      _data = _$v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameEvent other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GameEvent;
  }

  @override
  void update(void Function(GameEventBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GameEvent build() {
    _$GameEvent _$result;
    try {
      _$result = _$v ??
          new _$GameEvent._(
              id: id,
              name: name,
              description: description,
              type: type,
              data: data.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'GameEvent', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
