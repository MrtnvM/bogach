import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/presentation/purchases/games_access_page.dart';
import 'package:dash_kit_control_panel/dash_kit_control_panel.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/foundation.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/features/multiplayer/actions/join_room_action.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Function(String) useJoinRoom() {
  final context = useContext();
  final dispatch = useDispatcher();

  return (roomId) {
    VoidCallback joinRoom;

    final user = StoreProvider.state<AppState>(context).profile.currentUser;
    if (user == null) {
      // TODO возникает если незалогиненный пользователь открыл линку
      // в будущем подумать, может добавить обработку действия после логина
      return;
    }

    final multiplayerGamesCount = getAvailableMultiplayerGamesCount(user);

    joinRoom = () async {
      if (multiplayerGamesCount <= 0) {
        final response = await appRouter.goTo(const GamesAccessPage());
        if (response == null) {
          return;
        }
      }

      dispatch(JoinRoomAction(roomId)).then((_) async {
        await Future.delayed(const Duration(milliseconds: 50));

        appRouter.goToRoot();
        appRouter.goTo(RoomPage());
      }).catchError((error) {
        handleError(
          context: context,
          exception: error,
          onRetry: joinRoom,
          errorMessage: Strings.joinRoomError,
        );

        Logger.e('ERROR ON JOINING TO ROOM ($roomId):\n$error');
      });
    };

    joinRoom();
  };
}
