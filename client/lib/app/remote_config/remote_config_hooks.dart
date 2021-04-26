import 'package:cash_flow/services/updates_service.dart';
import 'package:dash_kit_network/dash_kit_network.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_it/get_it.dart';

void useAppUpdatesChecker(VoidCallback updateApp) {
  final updatesService = GetIt.I.get<UpdatesService>();
  useEffect(() {
    updatesService.checkUpdates(updateApp);
    return null;
  }, []);
}
