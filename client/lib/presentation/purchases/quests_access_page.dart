import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/features/network/network_request.dart';
import 'package:cash_flow/features/new_game/actions/start_quest_game_action.dart';
import 'package:cash_flow/features/purchase/actions/buy_quests_access_action.dart';
import 'package:cash_flow/features/purchase/actions/query_past_purchases_action.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/fullscreen_popup_container.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:dash_kit_core/dash_kit_core.dart';

class QuestsAccessPage extends HookWidget {
  const QuestsAccessPage({@required this.quest});

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    final isOperationInProgress = useGlobalState((s) {
      final getRequestState = s.network.getRequestState;

      return getRequestState(NetworkRequest.buyQuestsAcceess).isInProgress ||
          getRequestState(NetworkRequest.queryPastPurchases).isInProgress ||
          getRequestState(NetworkRequest.createQuestGame).isInProgress;
    });

    final isStoreAvailable = useFuture(
      InAppPurchaseConnection.instance.isAvailable(),
      initialData: true,
    );

    final hasQuestsAccess = useGlobalState((s) => s.purchase.hasQuestsAccess);
    final dispatch = useDispatcher();

    final startGame = () {
      return dispatch(StartQuestGameAction(
        quest.id,
        QuestAction.startNewGame,
      ));
    };

    useEffect(() {
      if (hasQuestsAccess) {
        startGame();
      }

      return null;
    }, [hasQuestsAccess]);

    return LoadableView(
      isLoading: isOperationInProgress,
      backgroundColor: Colors.black.withAlpha(100),
      child: FullscreenPopupContainer(
        backgroundColor: ColorRes.questAccessPageBackgound,
        topRightActionWidget: const _RestorePurchasesButton(),
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
            if (hasQuestsAccess)
              _StartQuestButton(onPressed: startGame)
            else
              _BuyButton(
                quest: quest,
                isStoreAvailable: isStoreAvailable.data,
              ),
          ],
        ),
      ),
    );
  }
}

class _RestorePurchasesButton extends HookWidget {
  const _RestorePurchasesButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();

    final restorePurchases = () {
      dispatch(QueryPastPurchasesAction()).catchError(
        (error) => handleError(context: context, exception: error),
      );
    };

    return GestureDetector(
      onTap: restorePurchases,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          Strings.questsAccessRestorePurchases,
          style: Styles.body1.copyWith(color: Colors.white.withAlpha(230)),
          textAlign: TextAlign.end,
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
          const Icon(
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
    @required this.quest,
    @required this.isStoreAvailable,
    Key key,
  }) : super(key: key);

  final Quest quest;
  final bool isStoreAvailable;

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();

    VoidCallback buyQuestsAccess;
    buyQuestsAccess = () async {
      try {
        await dispatch(BuyQuestsAccessAction());
        await dispatch(
          StartQuestGameAction(quest.id, QuestAction.startNewGame),
        );

        // ignore: avoid_catches_without_on_clauses
      } catch (error) {
        handleError(
          context: context,
          exception: error,
          onRetry: buyQuestsAccess,
        );
      }
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
              const Icon(Icons.check, color: Colors.white),
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

class _StartQuestButton extends StatelessWidget {
  const _StartQuestButton({Key key, this.onPressed}) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(Object context) {
    return RaisedButton(
      color: ColorRes.green,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            Strings.startQuest,
            style: Styles.body1.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
