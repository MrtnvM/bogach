import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/purchases/purchases.dart';
import 'package:cash_flow/features/multiplayer/multiplayer_hooks.dart';
import 'package:cash_flow/features/purchase/actions/buy_multiplayer_games.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/fullscreen_popup_container.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class MultiplayerPurchasePage extends HookWidget {
  const MultiplayerPurchasePage();

  @override
  Widget build(BuildContext context) {
    final isOperationInProgress = useGlobalState(
      (s) => s.getOperationState(Operation.buyMultiplayerGames).isInProgress,
    )!;

    useEffect(() {
      AnalyticsSender.multiplayerPurchasePageOpen();
      SessionTracker.multiplayerPurchasePage.start();
      return SessionTracker.multiplayerPurchasePage.stop;
    }, []);

    return LoadableView(
      isLoading: isOperationInProgress,
      backgroundColor: Colors.black.withAlpha(100),
      child: FullscreenPopupContainer(
        backgroundColor: ColorRes.buyMultiplayerGamesPageBackground,
        content: Column(
          children: const [
            _HeadlineImage(),
            Spacer(flex: 1),
            _MultiplayerAccessDescription(),
            Spacer(flex: 3),
            _PurchaseGameList(),
            Spacer(flex: 1),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HeadlineImage extends HookWidget {
  const _HeadlineImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final imageSize = screenWidth * 0.75;
    final cupSize = imageSize * 0.2;
    final defaultCupTopOffset = imageSize * 0.15;

    final cupAnimationController = useAnimationController(
      duration: const Duration(seconds: 2),
      initialValue: defaultCupTopOffset,
      lowerBound: defaultCupTopOffset - 6,
      upperBound: defaultCupTopOffset + 4,
    );

    useEffect(() {
      cupAnimationController.repeat(reverse: true);
      return null;
    }, []);

    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.padding.top),
      child: SizedBox(
        height: imageSize,
        width: imageSize,
        child: Stack(
          children: [
            Center(child: Image.asset(Images.multiplayerHeaderImage)),
            AnimatedBuilder(
              animation: cupAnimationController,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(top: cupAnimationController.value),
                  child: child,
                );
              },
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: cupSize,
                  width: cupSize,
                  child: Image.asset(Images.cup),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MultiplayerAccessDescription extends HookWidget {
  const _MultiplayerAccessDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 350;
    final availableGamesCount = useAvailableMultiplayerGamesCount();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Text(
        availableGamesCount == 0
            ? Strings.multiplayerAdvertisingMessage
            : Strings.multiplayerAdvertisingMessageWhenHaveGames,
        textAlign: TextAlign.center,
        style: Styles.body2.copyWith(
          letterSpacing: 0.4,
          fontSize: isSmallScreen ? 13.5 : 15,
        ),
      ),
    );
  }
}

class _PurchaseGameList extends HookWidget {
  const _PurchaseGameList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();

    late Function(MultiplayerGamePurchases) buyMultiplayerGame;
    buyMultiplayerGame = (multiplayerGamePurchase) async {
      final purchaseName = describeEnum(multiplayerGamePurchase);

      try {
        AnalyticsSender.multiplayerPurchaseStarted(purchaseName);

        switch (multiplayerGamePurchase) {
          case MultiplayerGamePurchases.oneGame:
            AnalyticsSender.multiplayer1GameBought();
            break;

          case MultiplayerGamePurchases.tenGames:
            AnalyticsSender.multiplayer10GamesBought();
            break;

          case MultiplayerGamePurchases.twentyFiveGames:
            AnalyticsSender.multiplayer25GamesBought();
            break;
        }

        await dispatch(BuyMultiplayerGames(multiplayerGamePurchase));
        AnalyticsSender.multiplayerGamesPurchased(purchaseName);

        appRouter.goBack(true);
      } on PurchaseCanceledException catch (error) {
        AnalyticsSender.multiplayerPurchaseCanceled(purchaseName);
        Fimber.i('Purchase canceled: ${error.productId}');
      } catch (error) {
        AnalyticsSender.multiplayerPurchaseFailed(
          error: error.toString(),
          purchase: purchaseName,
        );

        handleError(
          context: context,
          exception: error,
          errorMessage: Strings.purchaseError,
          onRetry: () => buyMultiplayerGame(multiplayerGamePurchase),
        );
      }
    };

    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _PurchaseWidget(
            purchase: MultiplayerGamePurchases.oneGame,
            title: '1 ${Strings.games(1)}',
            price: '15 ₽',
            buy: buyMultiplayerGame,
          ),
          _PurchaseWidget(
            purchase: MultiplayerGamePurchases.tenGames,
            title: '10 ${Strings.games(10)}',
            price: '99 ₽',
            oldPrice: '150 ₽',
            discont: 34,
            buy: buyMultiplayerGame,
            isDefaultOption: true,
          ),
          _PurchaseWidget(
            purchase: MultiplayerGamePurchases.twentyFiveGames,
            title: '25 ${Strings.games(25)}',
            price: '179 ₽',
            oldPrice: '375 ₽',
            discont: 52,
            buy: buyMultiplayerGame,
          ),
        ],
      ),
    );
  }
}

class _PurchaseWidget extends StatelessWidget {
  const _PurchaseWidget({
    Key? key,
    required this.purchase,
    required this.title,
    required this.price,
    required this.buy,
    this.oldPrice,
    this.discont,
    this.isDefaultOption = false,
  }) : super(key: key);

  final MultiplayerGamePurchases purchase;
  final String title;
  final String price;
  final String? oldPrice;
  final int? discont;
  final void Function(MultiplayerGamePurchases) buy;
  final bool isDefaultOption;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final isSmallScreen = screenWidth < 350;

    final textScaleFactor = isSmallScreen ? 0.8 : 1.0;
    final scale = isDefaultOption ? 1.0 : 0.9;

    return MediaQuery(
      data: mediaQuery.copyWith(textScaleFactor: textScaleFactor),
      child: Transform.scale(
        scale: scale,
        child: Container(
          height: isSmallScreen ? 196 : 210,
          width: isSmallScreen ? 100 : 110,
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
                price,
                style: Styles.bodyWhiteBold.copyWith(
                  fontSize: 17,
                ),
              ),
              if (oldPrice != null) ...[
                const SizedBox(height: 14),
                Text(
                  '$oldPrice',
                  style: Styles.body1.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ColorRes.red,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                if (discont != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.fromLTRB(6, 2, 6, 4),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${Strings.discount} ',
                            style: Styles.body1.copyWith(
                              fontSize: 11 * textScaleFactor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '$discont%',
                            style: Styles.body1.copyWith(
                              fontSize: 11 * textScaleFactor,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: () => buy(purchase),
                style: ElevatedButton.styleFrom(primary: ColorRes.mainGreen),
                child: Text(Strings.select, style: Styles.bodyWhiteBold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
