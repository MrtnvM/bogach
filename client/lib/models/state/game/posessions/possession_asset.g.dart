// GENERATED CODE - DO NOT MODIFY BY HAND

part of possession_asset;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PossessionAsset extends PossessionAsset {
  @override
  final int sum;
  @override
  final int cash;
  @override
  final List<InsuranceAssetItem> insurances;
  @override
  final List<DebentureAssetItem> debentures;
  @override
  final List<StockAssetItem> stocks;
  @override
  final List<RealtyAssetItem> realty;
  @override
  final List<BusinessAssetItem> businesses;
  @override
  final List<OtherAssetItem> other;

  factory _$PossessionAsset([void Function(PossessionAssetBuilder) updates]) =>
      (new PossessionAssetBuilder()..update(updates)).build();

  _$PossessionAsset._(
      {this.sum,
      this.cash,
      this.insurances,
      this.debentures,
      this.stocks,
      this.realty,
      this.businesses,
      this.other})
      : super._() {
    if (sum == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'sum');
    }
    if (cash == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'cash');
    }
    if (insurances == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'insurances');
    }
    if (debentures == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'debentures');
    }
    if (stocks == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'stocks');
    }
    if (realty == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'realty');
    }
    if (businesses == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'businesses');
    }
    if (other == null) {
      throw new BuiltValueNullFieldError('PossessionAsset', 'other');
    }
  }

  @override
  PossessionAsset rebuild(void Function(PossessionAssetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PossessionAssetBuilder toBuilder() =>
      new PossessionAssetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PossessionAsset &&
        sum == other.sum &&
        cash == other.cash &&
        insurances == other.insurances &&
        debentures == other.debentures &&
        stocks == other.stocks &&
        realty == other.realty &&
        businesses == other.businesses &&
        this.other == other.other;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, sum.hashCode), cash.hashCode),
                            insurances.hashCode),
                        debentures.hashCode),
                    stocks.hashCode),
                realty.hashCode),
            businesses.hashCode),
        other.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PossessionAsset')
          ..add('sum', sum)
          ..add('cash', cash)
          ..add('insurances', insurances)
          ..add('debentures', debentures)
          ..add('stocks', stocks)
          ..add('realty', realty)
          ..add('businesses', businesses)
          ..add('other', other))
        .toString();
  }
}

class PossessionAssetBuilder
    implements Builder<PossessionAsset, PossessionAssetBuilder> {
  _$PossessionAsset _$v;

  int _sum;
  int get sum => _$this._sum;
  set sum(int sum) => _$this._sum = sum;

  int _cash;
  int get cash => _$this._cash;
  set cash(int cash) => _$this._cash = cash;

  List<InsuranceAssetItem> _insurances;
  List<InsuranceAssetItem> get insurances => _$this._insurances;
  set insurances(List<InsuranceAssetItem> insurances) =>
      _$this._insurances = insurances;

  List<DebentureAssetItem> _debentures;
  List<DebentureAssetItem> get debentures => _$this._debentures;
  set debentures(List<DebentureAssetItem> debentures) =>
      _$this._debentures = debentures;

  List<StockAssetItem> _stocks;
  List<StockAssetItem> get stocks => _$this._stocks;
  set stocks(List<StockAssetItem> stocks) => _$this._stocks = stocks;

  List<RealtyAssetItem> _realty;
  List<RealtyAssetItem> get realty => _$this._realty;
  set realty(List<RealtyAssetItem> realty) => _$this._realty = realty;

  List<BusinessAssetItem> _businesses;
  List<BusinessAssetItem> get businesses => _$this._businesses;
  set businesses(List<BusinessAssetItem> businesses) =>
      _$this._businesses = businesses;

  List<OtherAssetItem> _other;
  List<OtherAssetItem> get other => _$this._other;
  set other(List<OtherAssetItem> other) => _$this._other = other;

  PossessionAssetBuilder();

  PossessionAssetBuilder get _$this {
    if (_$v != null) {
      _sum = _$v.sum;
      _cash = _$v.cash;
      _insurances = _$v.insurances;
      _debentures = _$v.debentures;
      _stocks = _$v.stocks;
      _realty = _$v.realty;
      _businesses = _$v.businesses;
      _other = _$v.other;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PossessionAsset other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PossessionAsset;
  }

  @override
  void update(void Function(PossessionAssetBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PossessionAsset build() {
    final _$result = _$v ??
        new _$PossessionAsset._(
            sum: sum,
            cash: cash,
            insurances: insurances,
            debentures: debentures,
            stocks: stocks,
            realty: realty,
            businesses: businesses,
            other: other);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
