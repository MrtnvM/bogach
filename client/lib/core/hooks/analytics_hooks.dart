import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/app/state_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useUserIdSender() {
  final user = useCurrentUser();

  useEffect(() {
    AnalyticsSender.setUserId(user!.userId);
    return null;
  }, [user]);
}
