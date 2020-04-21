import 'package:cash_flow/models/domain/player_action.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class SendGameEventPlayerActionAsyncAction extends AsyncAction<void> {
  SendGameEventPlayerActionAsyncAction(this.action, this.eventId);

  final PlayerAction action;
  final String eventId;
}
