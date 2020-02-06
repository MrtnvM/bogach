import 'package:cash_flow/utils/core/epic.dart';
import 'package:redux_epics/redux_epics.dart';

import 'app_state.dart';

Epic<AppState> rootEpic() {
  final emptyEpic = epic((action$, store) => const Stream.empty());

  return combineEpics([
    emptyEpic,
  ]);
}
