import 'package:cash_flow/analytics/sender/common/analytics_sender.dart';
import 'package:cash_flow/analytics/sender/common/session_tracker.dart';
import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/config/actions/mark_gameboard_tutorial_as_passed_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

GameboardTutorialWidget? useGameboardTutorial() {
  final context = useContext();
  final widget = GameboardTutorialWidget.of(context);
  return widget;
}

class GameboardTutorialWidget extends InheritedWidget {
  GameboardTutorialWidget({
    Key? key,
    required this.gameId,
    required Widget child,
  }) : super(key: key, child: child);

  static TutorialCoachMark? _currentTutorial;

  final String gameId;

  final cashFlowKey = GlobalKey();
  final cashKey = GlobalKey();
  final creditKey = GlobalKey();

  final monthKey = GlobalKey();

  final currentProgressKey = GlobalKey();
  final progressBarKey = GlobalKey();

  final gameEventKey = GlobalKey();
  final gameEventActionsKey = GlobalKey();

  final financesTabKey = GlobalKey();

  static GameboardTutorialWidget? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GameboardTutorialWidget>();
  }

  @override
  bool updateShouldNotify(GameboardTutorialWidget oldWidget) {
    return false;
  }

  void showTutorial(BuildContext context) {
    AnalyticsSender.tutorialStarted();
    SessionTracker.tutorial.start();

    _currentTutorial = TutorialCoachMark(
      context,
      targets: getTargets(context),
      textSkip: Strings.skip,
      onClickTarget: (target) async {
        AnalyticsSender.tutorialEvent(target.identify);

        if (target.keyTarget == gameEventKey) {
          await Future.delayed(const Duration(milliseconds: 50));
          Scrollable.ensureVisible(gameEventKey.currentContext!);
        }

        if (target.keyTarget == gameEventActionsKey) {
          await Future.delayed(const Duration(milliseconds: 150));
          Scrollable.ensureVisible(gameEventActionsKey.currentContext!);
        }
      },
      onSkip: () {
        AnalyticsSender.tutorialSkip();
        SessionTracker.tutorial.stop();

        _onTutorialPassed(context);
      },
      onFinish: () {
        AnalyticsSender.tutorialCompleted();
        SessionTracker.tutorial.stop();

        _onTutorialPassed(context);
      },
    );

    _currentTutorial!.show();
  }

  void _onTutorialPassed(BuildContext context) {
    StoreProvider.dispatch<AppState>(
      context,
      MarkGameboardTutorialAsPassedAction(),
    );

    appRouter.goBack();
    appRouter.goTo(GameBoard(gameId: gameId));
  }

  List<TargetFocus> getTargets(BuildContext context) {
    const rectShapeBorderRadius = 12.0;

    return [
      TargetFocus(
        identify: 'Month',
        keyTarget: monthKey,
        shape: ShapeLightFocus.RRect,
        radius: rectShapeBorderRadius,
        contents: createTargetContent(
          title: Strings.month,
          description: Strings.monthDescription,
          context: context,
          buttonTitle: Strings.tutorialGoNext1,
        ),
      ),
      TargetFocus(
        identify: 'CurrentProgress',
        keyTarget: currentProgressKey,
        shape: ShapeLightFocus.RRect,
        radius: 12,
        contents: createTargetContent(
          title: Strings.currentProgress,
          description: Strings.currentProgressDescription,
          context: context,
          buttonTitle: Strings.tutorialGoNext2,
        ),
      ),
      TargetFocus(
        identify: 'CashFlow',
        keyTarget: cashFlowKey,
        contents: createTargetContent(
          title: Strings.cashFlow,
          description: Strings.cashFlowDescription,
          context: context,
          buttonTitle: Strings.tutorialGoNext3,
        ),
      ),
      TargetFocus(
        identify: 'Cash',
        keyTarget: cashKey,
        contents: createTargetContent(
          title: Strings.cash,
          description: Strings.cashDescription,
          context: context,
          buttonTitle: Strings.tutorialGoNext4,
        ),
      ),
      TargetFocus(
        identify: 'Credit',
        keyTarget: creditKey,
        contents: createTargetContent(
          title: Strings.credit,
          description: Strings.creditDescription,
          context: context,
          buttonTitle: Strings.tutorialGoNext5,
        ),
      ),
      TargetFocus(
        identify: 'GameEvent',
        keyTarget: gameEventKey,
        shape: ShapeLightFocus.RRect,
        radius: rectShapeBorderRadius,
        contents: createTargetContent(
          title: Strings.gameEvent,
          description: Strings.gameEventDescription,
          align: ContentAlign.top,
          context: context,
          buttonTitle: Strings.tutorialGoNext6,
        ),
      ),
      TargetFocus(
        identify: 'GameEventActions',
        keyTarget: gameEventActionsKey,
        shape: ShapeLightFocus.RRect,
        radius: rectShapeBorderRadius,
        contents: createTargetContent(
          title: Strings.gameEventActions,
          description: Strings.gameEventActionsDescription,
          align: ContentAlign.top,
          context: context,
          buttonTitle: Strings.tutorialGoNext7,
        ),
      ),
      TargetFocus(
        identify: 'FinancesTab',
        keyTarget: financesTabKey,
        shape: ShapeLightFocus.RRect,
        radius: rectShapeBorderRadius,
        contents: createTargetContent(
          title: Strings.financesTabTitle,
          description: Strings.financesTabTitleDescription,
          align: ContentAlign.top,
          context: context,
          buttonTitle: Strings.tutorialFinish,
        ),
      ),
    ];
  }

  List<TargetContent> createTargetContent({
    required BuildContext context,
    required String title,
    required String description,
    required String buttonTitle,
    ContentAlign align = ContentAlign.bottom,
  }) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final isSmallScreen = screenHeight < 600;

    return [
      TargetContent(
        align: align,
        child: MediaQuery(
          data: mediaQuery.copyWith(
            textScaleFactor: isSmallScreen ? 0.9 : 1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (align == ContentAlign.bottom) const SizedBox(height: 32),
              Text(
                title,
                style: Styles.caption.copyWith(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                style: Styles.body1,
              ),
              InkWell(
                onTap: () => _currentTutorial?.next(),
                child: Container(
                  height: 26,
                  width: 88,
                  margin: const EdgeInsets.only(top: 24),
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: ColorRes.mainGreen,
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(150),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: Text(
                    buttonTitle,
                    style: Styles.body1.copyWith(
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
              if (align == ContentAlign.top) const SizedBox(height: 8),
            ],
          ),
        ),
      )
    ];
  }
}
