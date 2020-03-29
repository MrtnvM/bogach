// GENERATED CODE - DO NOT MODIFY BY HAND

part of user_possession_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$UserPossessionState extends UserPossessionState {
  @override
  final PossessionAsset assets;
  @override
  final List<PossessionExpense> expenses;
  @override
  final PossessionIncome incomes;
  @override
  final List<PossessionLiability> liabilities;

  factory _$UserPossessionState(
          [void Function(UserPossessionStateBuilder) updates]) =>
      (new UserPossessionStateBuilder()..update(updates)).build();

  _$UserPossessionState._(
      {this.assets, this.expenses, this.incomes, this.liabilities})
      : super._() {
    if (assets == null) {
      throw new BuiltValueNullFieldError('UserPossessionState', 'assets');
    }
    if (expenses == null) {
      throw new BuiltValueNullFieldError('UserPossessionState', 'expenses');
    }
    if (incomes == null) {
      throw new BuiltValueNullFieldError('UserPossessionState', 'incomes');
    }
    if (liabilities == null) {
      throw new BuiltValueNullFieldError('UserPossessionState', 'liabilities');
    }
  }

  @override
  UserPossessionState rebuild(
          void Function(UserPossessionStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserPossessionStateBuilder toBuilder() =>
      new UserPossessionStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserPossessionState &&
        assets == other.assets &&
        expenses == other.expenses &&
        incomes == other.incomes &&
        liabilities == other.liabilities;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, assets.hashCode), expenses.hashCode), incomes.hashCode),
        liabilities.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('UserPossessionState')
          ..add('assets', assets)
          ..add('expenses', expenses)
          ..add('incomes', incomes)
          ..add('liabilities', liabilities))
        .toString();
  }
}

class UserPossessionStateBuilder
    implements Builder<UserPossessionState, UserPossessionStateBuilder> {
  _$UserPossessionState _$v;

  PossessionAssetBuilder _assets;
  PossessionAssetBuilder get assets =>
      _$this._assets ??= new PossessionAssetBuilder();
  set assets(PossessionAssetBuilder assets) => _$this._assets = assets;

  List<PossessionExpense> _expenses;
  List<PossessionExpense> get expenses => _$this._expenses;
  set expenses(List<PossessionExpense> expenses) => _$this._expenses = expenses;

  PossessionIncomeBuilder _incomes;
  PossessionIncomeBuilder get incomes =>
      _$this._incomes ??= new PossessionIncomeBuilder();
  set incomes(PossessionIncomeBuilder incomes) => _$this._incomes = incomes;

  List<PossessionLiability> _liabilities;
  List<PossessionLiability> get liabilities => _$this._liabilities;
  set liabilities(List<PossessionLiability> liabilities) =>
      _$this._liabilities = liabilities;

  UserPossessionStateBuilder();

  UserPossessionStateBuilder get _$this {
    if (_$v != null) {
      _assets = _$v.assets?.toBuilder();
      _expenses = _$v.expenses;
      _incomes = _$v.incomes?.toBuilder();
      _liabilities = _$v.liabilities;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserPossessionState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$UserPossessionState;
  }

  @override
  void update(void Function(UserPossessionStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$UserPossessionState build() {
    _$UserPossessionState _$result;
    try {
      _$result = _$v ??
          new _$UserPossessionState._(
              assets: assets.build(),
              expenses: expenses,
              incomes: incomes.build(),
              liabilities: liabilities);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'assets';
        assets.build();

        _$failedField = 'incomes';
        incomes.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'UserPossessionState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
