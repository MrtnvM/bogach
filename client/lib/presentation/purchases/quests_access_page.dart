import 'package:cash_flow/core/hooks/alert_hooks.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/features/purchase/purchase_hooks.dart';
import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/presentation/game_levels/game_level_item.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/fullscreen_popup_container.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class QuestsAccessPage extends HookWidget {
  const QuestsAccessPage({@required this.gameLevel});

  final GameLevel gameLevel;

  @override
  Widget build(BuildContext context) {
    final isOperationInProgress = useGlobalState((s) {
      return s.purchase.buyQuestsAccessRequestState.isInProgress ||
          s.purchase.getPastPurchasesRequestState.isInProgress;
    });

    final isStoreAvailable = useFuture(
      InAppPurchaseConnection.instance.isAvailable(),
      initialData: true,
    );

    return Loadable(
      isLoading: isOperationInProgress,
      backgroundColor: Colors.black.withAlpha(100),
      child: FullscreenPopupContainer(
        backgroundColor: ColorRes.questAccessPageBackgound,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const _HeadlineImage(),
            const SizedBox(height: 16),
            const _QuestsAccessDescription(),
            const SizedBox(height: 32),
            const _AdvantagesWidget(),
            const SizedBox(height: 48),
            _BuyButton(
              gameLevel: gameLevel,
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

    return Container(
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
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: Strings.quests,
            style: Styles.body2.copyWith(
              letterSpacing: 0.4,
              fontSize: 15,
            ),
          ),
          TextSpan(
            text: Strings.questsAccessDescription,
            style: Styles.body1.copyWith(
              letterSpacing: 0.4,
              fontSize: 15,
            ),
          ),
        ]),
      ),
    );
  }
}

class _AdvantagesWidget extends StatelessWidget {
  const _AdvantagesWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildAdvantage(Strings.questsAccessAdvantage1),
        _buildAdvantage(Strings.questsAccessAdvantage2),
        _buildAdvantage(Strings.questsAccessAdvantage3),
      ],
    );
  }

  Widget _buildAdvantage(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Styles.body1,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyButton extends HookWidget {
  const _BuyButton({
    Key key,
    @required this.gameLevel,
    @required this.isStoreAvailable,
  }) : super(key: key);

  final GameLevel gameLevel;
  final bool isStoreAvailable;

  @override
  Widget build(BuildContext context) {
    final gameActions = useGameActions();
    final purchaseActions = usePurchaseActions();

    final errorAlert = useWarningAlert(
      message: (_) => Strings.storeConnectionError,
    );

    VoidCallback buyQuestsAccess;
    buyQuestsAccess = () {
      purchaseActions
          .buyQuestsAccess()
          .then((_) => gameActions.startGameByLevel(
                gameLevel,
                GameLevelAction.startNewGame,
              ))
          .catchError((error) => errorAlert(error, buyQuestsAccess));
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        RaisedButton(
          color: ColorRes.green,
          onPressed: buyQuestsAccess,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.check, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                Strings.buyQuestsAccess,
                style: Styles.body1.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        if (!isStoreAvailable) ...[
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(Strings.storeConnectionError, style: Styles.body1),
          ),
        ]
      ],
    );
  }
}
