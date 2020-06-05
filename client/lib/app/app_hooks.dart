import 'package:cash_flow/features/purchase/purchase_actions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

void useSubscriptionToPurchases() {
  final actionRunner = useActionRunner();

  useEffect(() {
    actionRunner.runAction(StartListeningPurchasesAction());
    return () => actionRunner.runAction(StopListeningPurchasesAction());
  }, []);
}
