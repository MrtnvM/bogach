import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/room/room.dart';
import 'package:cash_flow/models/domain/user/user_profile.dart';
import 'package:cash_flow/models/network/core/search_query_result.dart';
import 'package:cash_flow/utils/core/tuple.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';

class QueryUserProfilesAsyncAction
    extends AsyncAction<SearchQueryResult<UserProfile>> {
  QueryUserProfilesAsyncAction([this.query]);

  final String query;
}

class SelectMultiplayerGameTemplateAction extends Action {
  SelectMultiplayerGameTemplateAction(this.gameTemplate);

  final GameTemplate gameTemplate;
}

class CreateRoomAsyncAction extends AsyncAction<Room> {
  CreateRoomAsyncAction(this.participantIds);

  final List<String> participantIds;
}

class SetRoomParticipantReadyAsyncAction extends AsyncAction {
  SetRoomParticipantReadyAsyncAction(this.participantId)
      : assert(participantId != null);

  final String participantId;
}

class CreateRoomGameAsyncAction extends AsyncAction {}

class StopListeningRoomUpdatesAction extends Action {
  StopListeningRoomUpdatesAction(this.roomId);

  final String roomId;
}

class JoinRoomAsyncAction extends AsyncAction<Tuple<Room, List<UserProfile>>> {
  JoinRoomAsyncAction(this.roomId);

  final String roomId;
}

class OnCurrentRoomUpdatedAction extends Action {
  OnCurrentRoomUpdatedAction(this.room);

  final Room room;
}
