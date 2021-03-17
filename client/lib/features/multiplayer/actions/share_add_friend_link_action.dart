import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/services/dynamic_link/get_add_friend_link.dart';
import 'package:cash_flow/services/dynamic_link/sender/dymaic_link_sender.dart';

class ShareAddFriendLinkAction extends BaseAction {
  @override
  Operation get operationKey => Operation.shareRoomInviteLink;

  @override
  Future<AppState> reduce() async {
    final link = await getAddFriendLink(
      currentUser: state.profile.currentUser,
    );

    await shareDynamicLink(link);
    return null;
  }
}
