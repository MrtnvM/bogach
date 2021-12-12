import 'package:async_redux/async_redux.dart' as async_redux;
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:fimber/fimber.dart';

class CashErrorObserver<St> implements ErrorObserver<St> {
  @override
  bool observe(
    Object error,
    StackTrace stackTrace,
    ReduxAction<St> action,
    async_redux.Store<St> store,
  ) {
    Fimber.e(error.toString(), ex: error, stacktrace: stackTrace);
    return true;
  }
}
