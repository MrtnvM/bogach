import 'package:async_redux/async_redux.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:rxdart/subjects.dart';

class ReduxActionObserver extends ActionObserver {
  ReduxActionObserver._();

  static final instance = ReduxActionObserver._();

  final _onAction = PublishSubject<Action>();

  Stream<Action> get onAction => _onAction.stream;

  @override
  void observe(ReduxAction action, int dispatchCount, {bool ini}) {
    _onAction.add(action);
  }
}
