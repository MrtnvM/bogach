import 'package:flutter/material.dart' hide Action;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:rxdart/rxdart.dart';

typedef ActionDispatcher = void Function(Action);
typedef AsyncActionDispatcher = Stream<T> Function<T extends AsyncAction>(
  T action,
);

ActionDispatcher useActionDispatcher() {
  return useMemoized(() => ReduxConfig.storeProvider.store.dispatch);
}

AsyncActionDispatcher useAsyncActionDispatcher() {
  return Hook.use(_ReduxComponentHook()).dispatchAsyncAction;
}

ReduxComponent useReduxComponent() {
  return Hook.use(_ReduxComponentHook());
}

void Function(T) useAsyncAction<T, Result>({
  @required AsyncAction<Result> Function(T) action,
  void Function(Result) onSuccess,
  void Function(dynamic error, VoidCallback retry) onError,
}) {
  final dispatchAsyncAction = useAsyncActionDispatcher();

  void Function(T) dispatch;

  dispatch = (arg1) {
    dispatchAsyncAction(action(arg1)).listen(
      (action) => action
        ..onSuccess((result) => onSuccess?.call(result))
        ..onError((error) => onError?.call(error, () => dispatch(arg1))),
    );
  };

  return dispatch;
}

abstract class ReduxComponent {
  void dispatch(Action action) {}

  Stream<T> dispatchAsyncAction<T extends AsyncAction>(T action);

  Stream<T> onAction<T extends Action>();
}

class _ReduxComponentImpl implements ReduxComponent {
  final _onDisposed = PublishSubject();

  @override
  void dispatch(Action action) {
    assert(
      ReduxConfig.storeProvider != null,
      'ERROR: ReduxConfig.storeProvider is null. '
      'Initialize it before action dispatching',
    );

    ReduxConfig.storeProvider.store.dispatch(action);
  }

  @override
  Stream<T> dispatchAsyncAction<T extends AsyncAction>(T action) {
    dispatch(action);

    return onAction<T>()
        .where((a) => identical(a, action))
        .take(1)
        .takeUntil(_onDisposed);
  }

  @override
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

class _ReduxComponentHook extends Hook<ReduxComponent> {
  @override
  HookState<ReduxComponent, Hook<ReduxComponent>> createState() {
    return _ReduxComponentStateHook();
  }
}

class _ReduxComponentStateHook
    extends HookState<ReduxComponent, _ReduxComponentHook> {
  var _reduxComponent = _ReduxComponentImpl();

  @override
  ReduxComponent build(BuildContext context) {
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
