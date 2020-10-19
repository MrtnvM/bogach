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
        content: Column(
          children: <Widget>[
            const _HeadlineImage(),
            const SizedBox(height: 16),
            const _QuestsAccessDescription(),
            const Spacer(),
            _PurchaseGameList(
              isStoreAvailable: isStoreAvailable.data,
            ),
            const SizedBox(height: 24),
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
        'У вас кончились игры,\nхотите купить ещё?',
        textAlign: TextAlign.center,
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

    Function(MultiplayerGamePurchases) buyMultiplayerGame;
    buyMultiplayerGame = (multiplayerGamePurchase) async {
      try {
        await dispatch(BuyMultiplayerGames(multiplayerGamePurchase));
        appRouter.goBack(true);
      } catch (error) {
        handleError(
          context: context,
          exception: error,
          errorMessage: Strings.purchaseError,
          onRetry: () => buyMultiplayerGame(multiplayerGamePurchase),
        );
      }
    };

    if (!isStoreAvailable) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPurchase(
            purchase: MultiplayerGamePurchases.oneGame,
            title: '1 игра',
            price: '15 ₽',
            buy: buyMultiplayerGame,
          ),
          _buildPurchase(
            purchase: MultiplayerGamePurchases.fiveGames,
            title: '5 игр',
            price: '75 ₽',
            gift: '+1',
            buy: buyMultiplayerGame,
          ),
          _buildPurchase(
            purchase: MultiplayerGamePurchases.tenGames,
            title: '10 игр',
            price: '149 ₽',
            gift: '+2',
            buy: buyMultiplayerGame,
          ),
        ],
      ),
    );
  }

  Widget _buildPurchase({
    MultiplayerGamePurchases purchase,
    String title,
    String price,
    String gift,
    void Function(MultiplayerGamePurchases) buy,
  }) {
    return Container(
      height: 200,
      width: 110,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: ColorRes.white.withAlpha(50),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Text(
            title,
            style: Styles.bodyWhiteBold.copyWith(
              fontSize: 15,
              color: Colors.white.withAlpha(240),
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),
          Text(
            price ?? '',
            style: Styles.bodyWhiteBold.copyWith(
              fontSize: 17,
            ),
          ),
          if (gift != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(Images.gift, height: 26, width: 26),

                // Text(gift ?? '', style: Styles.body1.copyWith(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '$gift в подарок',
              style: Styles.body1.copyWith(fontSize: 12.5),
            ),
          ],
          const Spacer(),
          RaisedButton(
            onPressed: () => buy(purchase),
            color: ColorRes.mainGreen,
            child: const Text('Выбрать', style: Styles.bodyWhiteBold),
          ),
        ],
      ),
    );
  }
}
