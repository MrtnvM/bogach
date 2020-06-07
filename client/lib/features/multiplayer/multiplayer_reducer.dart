import 'package:cash_flow/features/multiplayer/multiplayer_actions.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_state.dart';
import 'package:flutter_platform_core/flutter_platform_core.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

final multiplayerReducer = Reducer<MultiplayerState>()
  ..on<QueryUserProfilesAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.userProfilesQueryRequestState = action.requestState;

      action.onSuccess((result) {
        s.userProfiles.updateList(result.items);
        s.userProfilesQuery = result;
      });
    }),
  )
  ..on<SelectMultiplayerGameTemplateAction>(
    (state, action) => state.rebuild((s) {
      s.selectedGameTemplate = action.gameTemplate;
    }),
  )
  ..on<CreateRoomAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.createRoomRequestState = action.requestState;

      action.onSuccess((room) => s.currentRoom = room);
    }),
  )
  ..on<CreateRoomGameAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.createRoomGameRequestState = action.requestState;
    }),
  )
  ..on<JoinRoomAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.joinRoomRequestState = action.requestState;

      action.onSuccess((result) {
        s.currentRoom = result.item1;
        s.userProfiles.addAll(result.item2);
      });
    }),
  )
  ..on<OnCurrentRoomUpdatedAction>(
    (state, action) => state.rebuild((s) {
      s.currentRoom = action.room;
    }),
  )
  ..on<SetRoomParticipantReadyAsyncAction>(
    (state, action) => state.rebuild((s) {
      s.setPlayerReadyRequestState = action.requestState;
    }),
  );
