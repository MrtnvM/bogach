import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/dynamic_link/get_room_invite_link.dart';
import 'package:cash_flow/services/dynamic_link/sender/dymaic_link_sender.dart';

class ShareRoomInviteLinkAction extends BaseAction {
  ShareRoomInviteLinkAction(this.roomId);

  final String roomId;

  @override
  Operation get operationKey => Operation.shareRoomInviteLink;

  @override
  Future<AppState?> reduce() async {
    final link = await getRoomInviteLink(
      roomId: roomId,
      currentUser: state.profile.currentUser!,
    );

    await shareDynamicLink(link);
    return null;
  }
}
