import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/dispatcher.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/purchase/actions/buy_quests_access_action.dart';
import 'package:cash_flow/features/purchase/actions/restore_purchases_action.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/models/errors/purchase_errors.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/dialogs/dialogs.dart';
import 'package:cash_flow/presentation/main/main_page.dart';
import 'package:cash_flow/presentation/quests/quest_item_widget.dart';
import 'package:cash_flow/presentation/quests/quests_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/fullscreen_popup_container.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:dash_kit_loadable/dash_kit_loadable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestsPurchasePage extends HookWidget {
  const QuestsPurchasePage({this.quest});

  final Quest? quest;

  @override
  Widget build(BuildContext context) {
    final isOperationInProgress = useGlobalState(
      (s) =>
          s.getOperationState(Operation.buyQuestsAcceess).isInProgress ||
          s.getOperationState(Operation.restorePurchases).isInProgress ||
          s.getOperationState(Operation.createQuestGame).isInProgress,
    )!;

    final hasQuestsAccess = useGlobalState(
      (s) => s.profile.currentUser?.purchaseProfile?.isQuestsAvailable ?? false,
    )!;

    useEffect(() {
      AnalyticsSender.questsPurchasePageOpen();
      SessionTracker.questPurchasePage.start();
      return SessionTracker.questPurchasePage.stop;
    }, []);

    final mediaQueryData = useAdaptiveMediaQueryData();
    final offsetScaleFactor = mediaQueryData.textScaleFactor;

    return LoadableView(
      isLoading: isOperationInProgress,
      backgroundColor: Colors.black.withAlpha(100),
      child: MediaQuery(
        data: mediaQueryData,
        child: FullscreenPopupContainer(
          backgroundColor: ColorRes.questAccessPageBackground,
          topRightActionWidget: const _RestorePurchasesButton(),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const _HeadlineImage(),
              SizedBox(height: 16 * offsetScaleFactor),
              const _QuestsAccessDescription(),
              SizedBox(height: 32 * offsetScaleFactor),
              const _AdvantagesWidget(),
              SizedBox(height: 48 * offsetScaleFactor),
              if (hasQuestsAccess)
                _StartQuestButton(quest: quest)
              else
                _BuyButton(quest: quest),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestorePurchasesButton extends HookWidget {
  const _RestorePurchasesButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();

    final restorePurchases = () async {
      AnalyticsSender.restorePurchasesStart();

      try {
        await dispatch(RestorePurchasesAction());
      } catch (error) {
        AnalyticsSender.restorePurchasesFailed();
        handleError(context: context, exception: error);
      }
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
  const _HeadlineImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final imageSize = screenWidth * (screenWidth >= 350 ? 0.75 : 0.65);

    return SizedBox(
      height: imageSize,
      width: imageSize,
      child: Image.asset(Images.questsAccess),
    );
  }
}

class _QuestsAccessDescription extends StatelessWidget {
  const _QuestsAccessDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: RichText(
        textScaleFactor: mediaQuery.textScaleFactor,
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
  const _AdvantagesWidget({Key? key}) : super(key: key);

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
  const _BuyButton({required this.quest, Key? key}) : super(key: key);

  final Quest? quest;

  @override
  Widget build(BuildContext context) {
    final dispatch = useDispatcher();
    final startQuest = useQuestStarter();

    VoidCallback? buyQuestsAccess;
    buyQuestsAccess = () async {
      try {
        AnalyticsSender.questsPurchaseStarted();
        await dispatch(BuyQuestsAccessAction());
        AnalyticsSender.questsPurchased();

        if (quest == null) {
          SchedulerBinding.instance!.addPostFrameCallback((_) {
            appRouter.startWith(const MainPage());
          });
          return;
        }

        await startQuest(quest!.id, QuestAction.startNewGame);
      } on PurchaseCanceledException catch (error) {
        AnalyticsSender.questsPurchaseCanceled();
        Fimber.i('Purchase canceled: ${error.productId}');
      } catch (error) {
        AnalyticsSender.questsPurchaseFailed();

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
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: ColorRes.green),
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
      ],
    );
  }
}

class _StartQuestButton extends HookWidget {
  const _StartQuestButton({Key? key, this.quest}) : super(key: key);

  final Quest? quest;

  @override
  Widget build(Object context) {
    final startQuest = useQuestStarter();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: ColorRes.green),
      onPressed: () {
        if (quest == null) {
          appRouter.goBack();
          return;
        }

        startQuest(quest!.id, QuestAction.startNewGame);
      },
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
