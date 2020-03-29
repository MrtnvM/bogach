// GENERATED CODE - DO NOT MODIFY BY HAND

part of possession_income;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PossessionIncome extends PossessionIncome {
  @override
  final int salary;
  @override
  final int investments;
  @override
  final int business;
  @override
  final int realty;
  @override
  final int other;

  factory _$PossessionIncome(
          [void Function(PossessionIncomeBuilder) updates]) =>
      (new PossessionIncomeBuilder()..update(updates)).build();

  _$PossessionIncome._(
      {this.salary, this.investments, this.business, this.realty, this.other})
      : super._() {
    if (salary == null) {
      throw new BuiltValueNullFieldError('PossessionIncome', 'salary');
    }
    if (investments == null) {
      throw new BuiltValueNullFieldError('PossessionIncome', 'investments');
    }
    if (business == null) {
      throw new BuiltValueNullFieldError('PossessionIncome', 'business');
    }
    if (realty == null) {
      throw new BuiltValueNullFieldError('PossessionIncome', 'realty');
    }
    if (other == null) {
      throw new BuiltValueNullFieldError('PossessionIncome', 'other');
    }
  }

  @override
  PossessionIncome rebuild(void Function(PossessionIncomeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PossessionIncomeBuilder toBuilder() =>
      new PossessionIncomeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PossessionIncome &&
        salary == other.salary &&
        investments == other.investments &&
        business == other.business &&
        realty == other.realty &&
        this.other == other.other;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, salary.hashCode), investments.hashCode),
                business.hashCode),
            realty.hashCode),
        other.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PossessionIncome')
          ..add('salary', salary)
          ..add('investments', investments)
          ..add('business', business)
          ..add('realty', realty)
          ..add('other', other))
        .toString();
  }
}

class PossessionIncomeBuilder
    implements Builder<PossessionIncome, PossessionIncomeBuilder> {
  _$PossessionIncome _$v;

  int _salary;
  int get salary => _$this._salary;
  set salary(int salary) => _$this._salary = salary;

  int _investments;
  int get investments => _$this._investments;
  set investments(int investments) => _$this._investments = investments;

  int _business;
  int get business => _$this._business;
  set business(int business) => _$this._business = business;

  int _realty;
  int get realty => _$this._realty;
  set realty(int realty) => _$this._realty = realty;

  int _other;
  int get other => _$this._other;
  set other(int other) => _$this._other = other;

  PossessionIncomeBuilder();

  PossessionIncomeBuilder get _$this {
    if (_$v != null) {
      _salary = _$v.salary;
      _investments = _$v.investments;
      _business = _$v.business;
      _realty = _$v.realty;
      _other = _$v.other;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PossessionIncome other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PossessionIncome;
  }

  @override
  void update(void Function(PossessionIncomeBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PossessionIncome build() {
    final _$result = _$v ??
        new _$PossessionIncome._(
            salary: salary,
            investments: investments,
            business: business,
            realty: realty,
            other: other);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
