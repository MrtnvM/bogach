import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/base_action.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/services/game_service.dart';
import 'package:get_it/get_it.dart';

class ShareRoomInviteLinkAction extends BaseAction {
  ShareRoomInviteLinkAction(this.roomId) : assert(roomId != null);

  final String roomId;

  @override
  NetworkRequest get operationKey => NetworkRequest.shareRoomInviteLink;

  @override
  FutureOr<AppState> reduce() async {
    final gameService = GetIt.I.get<GameService>();

    await gameService.shareRoomInviteLink(
      roomId: roomId,
      currentUser: state.profile.currentUser,
    );

    return null;
  }
}
