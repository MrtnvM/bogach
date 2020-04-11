// GENERATED CODE - DO NOT MODIFY BY HAND

part of game_event_data;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GameEventData extends GameEventData {
  @override
  final int currentPrice;
  @override
  final int maxCount;
  @override
  final int nominal;
  @override
  final int profitabilityPercent;

  factory _$GameEventData([void Function(GameEventDataBuilder) updates]) =>
      (new GameEventDataBuilder()..update(updates)).build();

  _$GameEventData._(
      {this.currentPrice,
      this.maxCount,
      this.nominal,
      this.profitabilityPercent})
      : super._() {
    if (currentPrice == null) {
      throw new BuiltValueNullFieldError('GameEventData', 'currentPrice');
    }
    if (maxCount == null) {
      throw new BuiltValueNullFieldError('GameEventData', 'maxCount');
    }
    if (nominal == null) {
      throw new BuiltValueNullFieldError('GameEventData', 'nominal');
    }
    if (profitabilityPercent == null) {
      throw new BuiltValueNullFieldError(
          'GameEventData', 'profitabilityPercent');
    }
  }

  @override
  GameEventData rebuild(void Function(GameEventDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GameEventDataBuilder toBuilder() => new GameEventDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GameEventData &&
        currentPrice == other.currentPrice &&
        maxCount == other.maxCount &&
        nominal == other.nominal &&
        profitabilityPercent == other.profitabilityPercent;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, currentPrice.hashCode), maxCount.hashCode),
            nominal.hashCode),
        profitabilityPercent.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('GameEventData')
          ..add('currentPrice', currentPrice)
          ..add('maxCount', maxCount)
          ..add('nominal', nominal)
          ..add('profitabilityPercent', profitabilityPercent))
        .toString();
  }
}

class GameEventDataBuilder
    implements Builder<GameEventData, GameEventDataBuilder> {
  _$GameEventData _$v;

  int _currentPrice;
  int get currentPrice => _$this._currentPrice;
  set currentPrice(int currentPrice) => _$this._currentPrice = currentPrice;

  int _maxCount;
  int get maxCount => _$this._maxCount;
  set maxCount(int maxCount) => _$this._maxCount = maxCount;

  int _nominal;
  int get nominal => _$this._nominal;
  set nominal(int nominal) => _$this._nominal = nominal;

  int _profitabilityPercent;
  int get profitabilityPercent => _$this._profitabilityPercent;
  set profitabilityPercent(int profitabilityPercent) =>
      _$this._profitabilityPercent = profitabilityPercent;

  GameEventDataBuilder();

  GameEventDataBuilder get _$this {
    if (_$v != null) {
      _currentPrice = _$v.currentPrice;
      _maxCount = _$v.maxCount;
      _nominal = _$v.nominal;
      _profitabilityPercent = _$v.profitabilityPercent;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GameEventData other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$GameEventData;
  }

  @override
  void update(void Function(GameEventDataBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$GameEventData build() {
    final _$result = _$v ??
        new _$GameEventData._(
            currentPrice: currentPrice,
            maxCount: maxCount,
            nominal: nominal,
            profitabilityPercent: profitabilityPercent);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
