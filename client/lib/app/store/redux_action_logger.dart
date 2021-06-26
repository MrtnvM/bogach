import 'package:async_redux/async_redux.dart';

class ReduxActionLogger extends ActionObserver {
  @override
  void observe(ReduxAction action, int dispatchCount, {required bool ini}) {
    if (ini) {
      print('$action');
    }
  }
}
