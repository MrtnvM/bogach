import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/features/profile/actions/start_listening_profile_updates_action.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useStartListenToProfileUpdates(bool needAuthorization, String userId) {
  useEffect(() {
    if (!needAuthorization) {
      return null;
    }

    final dispatch = useDispatcher();
    dispatch(StartListeningProfileUpdatesAction(userId));

    return null;
  }, []);
}
