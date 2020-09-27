import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/core/search_query_result.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class ShareRoomInviteLinkAsyncAction extends AsyncAction {
  ShareRoomInviteLinkAsyncAction(this.roomId) : assert(roomId != null);

  final String roomId;
}
