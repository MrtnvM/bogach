// GENERATED CODE - DO NOT MODIFY BY HAND

part of purchase_state;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$PurchaseState extends PurchaseState {
  @override
  final RequestState listenPurchasesRequestState;
  @override
  final RequestState getPastPurchasesRequestState;
  @override
  final BuiltList<PurchaseDetails> updatedPurchases;
  @override
  final BuiltList<PurchaseDetails> pastPurchases;

  factory _$PurchaseState([void Function(PurchaseStateBuilder) updates]) =>
      (new PurchaseStateBuilder()..update(updates)).build();

  _$PurchaseState._(
      {this.listenPurchasesRequestState,
      this.getPastPurchasesRequestState,
      this.updatedPurchases,
      this.pastPurchases})
      : super._() {
    if (listenPurchasesRequestState == null) {
      throw new BuiltValueNullFieldError(
          'PurchaseState', 'listenPurchasesRequestState');
    }
    if (getPastPurchasesRequestState == null) {
      throw new BuiltValueNullFieldError(
          'PurchaseState', 'getPastPurchasesRequestState');
    }
    if (updatedPurchases == null) {
      throw new BuiltValueNullFieldError('PurchaseState', 'updatedPurchases');
    }
    if (pastPurchases == null) {
      throw new BuiltValueNullFieldError('PurchaseState', 'pastPurchases');
    }
  }

  @override
  PurchaseState rebuild(void Function(PurchaseStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PurchaseStateBuilder toBuilder() => new PurchaseStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PurchaseState &&
        listenPurchasesRequestState == other.listenPurchasesRequestState &&
        getPastPurchasesRequestState == other.getPastPurchasesRequestState &&
        updatedPurchases == other.updatedPurchases &&
        pastPurchases == other.pastPurchases;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc(0, listenPurchasesRequestState.hashCode),
                getPastPurchasesRequestState.hashCode),
            updatedPurchases.hashCode),
        pastPurchases.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('PurchaseState')
          ..add('listenPurchasesRequestState', listenPurchasesRequestState)
          ..add('getPastPurchasesRequestState', getPastPurchasesRequestState)
          ..add('updatedPurchases', updatedPurchases)
          ..add('pastPurchases', pastPurchases))
        .toString();
  }
}

class PurchaseStateBuilder
    implements Builder<PurchaseState, PurchaseStateBuilder> {
  _$PurchaseState _$v;

  RequestState _listenPurchasesRequestState;
  RequestState get listenPurchasesRequestState =>
      _$this._listenPurchasesRequestState;
  set listenPurchasesRequestState(RequestState listenPurchasesRequestState) =>
      _$this._listenPurchasesRequestState = listenPurchasesRequestState;

  RequestState _getPastPurchasesRequestState;
  RequestState get getPastPurchasesRequestState =>
      _$this._getPastPurchasesRequestState;
  set getPastPurchasesRequestState(RequestState getPastPurchasesRequestState) =>
      _$this._getPastPurchasesRequestState = getPastPurchasesRequestState;

  ListBuilder<PurchaseDetails> _updatedPurchases;
  ListBuilder<PurchaseDetails> get updatedPurchases =>
      _$this._updatedPurchases ??= new ListBuilder<PurchaseDetails>();
  set updatedPurchases(ListBuilder<PurchaseDetails> updatedPurchases) =>
      _$this._updatedPurchases = updatedPurchases;

  ListBuilder<PurchaseDetails> _pastPurchases;
  ListBuilder<PurchaseDetails> get pastPurchases =>
      _$this._pastPurchases ??= new ListBuilder<PurchaseDetails>();
  set pastPurchases(ListBuilder<PurchaseDetails> pastPurchases) =>
      _$this._pastPurchases = pastPurchases;

  PurchaseStateBuilder();

  PurchaseStateBuilder get _$this {
    if (_$v != null) {
      _listenPurchasesRequestState = _$v.listenPurchasesRequestState;
      _getPastPurchasesRequestState = _$v.getPastPurchasesRequestState;
      _updatedPurchases = _$v.updatedPurchases?.toBuilder();
      _pastPurchases = _$v.pastPurchases?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PurchaseState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$PurchaseState;
  }

  @override
  void update(void Function(PurchaseStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$PurchaseState build() {
    _$PurchaseState _$result;
    try {
      _$result = _$v ??
          new _$PurchaseState._(
              listenPurchasesRequestState: listenPurchasesRequestState,
              getPastPurchasesRequestState: getPastPurchasesRequestState,
              updatedPurchases: updatedPurchases.build(),
              pastPurchases: pastPurchases.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'updatedPurchases';
        updatedPurchases.build();
        _$failedField = 'pastPurchases';
        pastPurchases.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'PurchaseState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
