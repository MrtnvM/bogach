import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/features/purchase/actions/buy_multiplayer_games.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/fullscreen_popup_container.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class GamesAccessPage extends HookWidget {
  const GamesAccessPage();

  @override
  Widget build(BuildContext context) {
    final isStoreAvailable = useFuture(
      InAppPurchaseConnection.instance.isAvailable(),
      initialData: true,
    );

    final isOperationInProgress = useGlobalState(
      (s) => s.getOperationState(Operation.buyMultiplayerGames).isInProgress,
    );

    return LoadableView(
      isLoading: isOperationInProgress,
      backgroundColor: Colors.black.withAlpha(100),
      child: FullscreenPopupContainer(
        backgroundColor: ColorRes.questAccessPageBackgound,
        content: ListView(
          children: <Widget>[
            const _HeadlineImage(),
            const SizedBox(height: 16),
            const _QuestsAccessDescription(),
            const SizedBox(height: 32),
            _PurchaseGameList(
              isStoreAvailable: isStoreAvailable.data,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeadlineImage extends StatelessWidget {
  const _HeadlineImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final imageSize = screenWidth * 0.75;

    return SizedBox(
      height: imageSize,
      width: imageSize,
      child: Image.asset(Images.questsAccess),
    );
  }
}

class _QuestsAccessDescription extends StatelessWidget {
  const _QuestsAccessDescription({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Text(
        'У вас кончились игры, хотите купить ещё?',
        style: Styles.body2.copyWith(
          letterSpacing: 0.4,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _PurchaseGameList extends HookWidget {
  const _PurchaseGameList({
    @required this.isStoreAvailable,
    Key key,
  }) : super(key: key);

  final bool isStoreAvailable;

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();

    Function(MultiplayerGamePurchases) buyQuestsAccess;
    buyQuestsAccess = (multiplayerGamePurchase) async {
      try {
        await dispatch(BuyMultiplayerGames(multiplayerGamePurchase));
        appRouter.goBack(true);
      } catch (error) {
        handleError(
          context: context,
          exception: error,
          errorMessage: Strings.purchaseError,
          onRetry: () => buyQuestsAccess(multiplayerGamePurchase),
        );
      }
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: isStoreAvailable
          ? MultiplayerGamePurchases.values
              .map(
                (item) => ListTile(
                  title: Text(
                    item.title,
                    style: Styles.body2.copyWith(
                      letterSpacing: 0.4,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () => buyQuestsAccess(item),
                ),
              )
              .toList()
          : [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  Strings.storeConnectionError,
                  style: Styles.body1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
    );
  }
}
