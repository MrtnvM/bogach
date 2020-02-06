import 'package:cash_flow/app/app_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:redux_epics/redux_epics.dart';

final Epic<AppState> Function(
  Stream<dynamic> Function(Observable<dynamic>, EpicStore<AppState>),
) epic = (epicAction) {
  return (action$, store) {
    return epicAction(Observable(action$), store);
  };
};
