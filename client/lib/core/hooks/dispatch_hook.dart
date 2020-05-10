import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:rxdart/rxdart.dart';

_ActionRunner useActionRunner() {
  final reduxComponent = useReduxComponent();
  final actionRunner = useMemoized(() => _ActionRunner(reduxComponent));
  return actionRunner;
}

class _ActionRunner {
  _ActionRunner(this._reduxComponent);
  final _ReduxComponent _reduxComponent;

  void runAction(Action action) {
    _reduxComponent.dispatch(action);
  }

  Future<R> runAsyncAction<R>(AsyncAction<R> action) {
    return _reduxComponent.dispatchAsyncActionAsFuture(action);
  }
}

_ReduxComponent useReduxComponent() {
  return Hook.use(_ReduxComponentHook());
}

class _ReduxComponent {
  final _onDisposed = PublishSubject();

  void dispatch(Action action) {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before action dispatching',
    );

    ReduxConfig.storeProvider.store.dispatch(action);
  }

  Stream<T> dispatchAsyncAction<R, T extends AsyncAction<R>>(T action) {
    dispatch(action);

    return onAction<T>()
        .where((a) => identical(a, action))
        .take(1)
        .takeUntil(_onDisposed);
  }

  Future<R> dispatchAsyncActionAsFuture<R>(AsyncAction<R> action) {
    return dispatchAsyncAction(action).map((a) {
      if (a.isSucceed) {
        return a.successModel;
      }

      throw a.errorModel;
    }).first;
  }

  Stream<T> onAction<T extends Action>() {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before subscribing on actions',
    );

    return ReduxConfig.storeProvider.onAction
        .whereType<T>()
        .takeUntil(_onDisposed);
  }

  void disposeSubscriptions() {
    _onDisposed.add(true);
  }
}

class _ReduxComponentHook extends Hook<_ReduxComponent> {
  @override
  HookState<_ReduxComponent, Hook<_ReduxComponent>> createState() {
    return _ReduxComponentStateHook();
  }
}

class _ReduxComponentStateHook
    extends HookState<_ReduxComponent, _ReduxComponentHook> {
  var _reduxComponent = _ReduxComponent();

  @override
  _ReduxComponent build(BuildContext context) {
    return _reduxComponent;
  }

  @override
  void dispose() {
    assert(
      _reduxComponent != null,
      'disposeSubscriptions() should be called before super.dispose()',
    );

    _reduxComponent.disposeSubscriptions();
    _reduxComponent = null;

    super.dispose();
  }
}
