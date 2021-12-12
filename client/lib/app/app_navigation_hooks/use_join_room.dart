import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/store_hooks.dart';
import 'package:cash_flow/features/multiplayer/actions/join_room_action.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/multiplayer/room_page.dart';
import 'package:cash_flow/presentation/purchases/multiplayer_purchase_page.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Function(String?) useJoinRoom() {
  final context = useContext();
  final dispatch = useDispatcher();
  final store = useStore();

  return (roomId) {
    VoidCallback? joinRoom;

    final user = store.state.profile.currentUser;

    if (user == null) {
      // TODO(Team): возникает если незалогиненный пользователь открыл линку
      // в будущем подумать, может добавить обработку действия после логина
      return;
    }

    final multiplayerGamesCount = getAvailableMultiplayerGamesCount(user);

    joinRoom = () async {
      if (multiplayerGamesCount <= 0) {
        final response = await appRouter.goTo(const MultiplayerPurchasePage());
        if (response == null) {
          return;
        }
      }

      dispatch(JoinRoomAction(roomId!)).then((_) async {
        appRouter.goToRoot();
        appRouter.goTo(RoomPage(roomId: roomId));
      }).onError((error, st) {
        handleError(
          context: context,
          exception: error,
          onRetry: joinRoom,
          errorMessage: Strings.joinRoomError,
        );

        Fimber.e('ERROR ON JOINING TO ROOM ($roomId):\n$error');
      });
    };

    joinRoom();
  };
}
