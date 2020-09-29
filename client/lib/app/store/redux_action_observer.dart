import 'dart:async';

import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class ReduxActionObserver extends ActionObserver {
  final _onAction = StreamController<ReduxAction>();

  Stream<ReduxAction> get onAction => _onAction.stream;

  @override
  void observe(ReduxAction action, int dispatchCount, {bool ini}) {
    _onAction.add(action);
  }
}
