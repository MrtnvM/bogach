import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class _GlobalStateHook<T> extends Hook<T> {
  const _GlobalStateHook({
    @required this.converter,
    this.distinct = true,
  })  : assert(converter != null),
        assert(distinct != null);

  final T Function(AppState) converter;
  final bool distinct;

  @override
  HookState<T, Hook<T>> createState() {
    return _GlobalStateStateHook<T>();
  }
}

class _GlobalStateStateHook<T> extends HookState<T, _GlobalStateHook<T>> {
  StreamSubscription _storeSubscription;
  T _state;

  @override
  void initHook() {
    super.initHook();

    _updateState(ReduxConfig.storeProvider.store.state);

    final onStoreChanged = ReduxConfig.storeProvider.store.onChange;
    _storeSubscription = onStoreChanged.listen(_updateState);
  }

  @override
  T build(BuildContext context) {
    return _state;
  }

  @override
  void dispose() {
    super.dispose();

    _storeSubscription?.cancel();
    _state = null;
  }

  void _updateState(GlobalState globalState) {
    final state = hook.converter(globalState);

    if (hook.distinct && state == _state) {
      return;
    }

    setState(() => _state = state);
  }
}

T useGlobalState<T>(
  T Function(AppState) converter, {
  bool distinct = true,
}) {
  return use(_GlobalStateHook(converter: converter, distinct: distinct));
}
