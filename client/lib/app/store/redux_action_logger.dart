import 'package:async_redux/async_redux.dart';

class ReduxActionLogger extends ActionObserver {
  @override
  void observe(ReduxAction action, int dispatchCount, {bool ini}) {
    if (ini) {
      print('$action');
    }
  }
}
