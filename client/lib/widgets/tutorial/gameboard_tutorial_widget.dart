import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/features/config/actions/mark_gameboard_tutorial_as_passed_action.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/presentation/gameboard/gameboard.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

GameboardTutorialWidget useGameboardTutorial() {
  final context = useContext();
  final widget = GameboardTutorialWidget.of(context);
  return widget;
}

class GameboardTutorialWidget extends InheritedWidget {
  GameboardTutorialWidget({Key key, Widget child})
      : super(key: key, child: child);

  final cashFlowKey = GlobalKey();
  final cashKey = GlobalKey();
  final creditKey = GlobalKey();

  final monthKey = GlobalKey();

  final currentProgressKey = GlobalKey();
  final progressBarKey = GlobalKey();

  final gameEventKey = GlobalKey();
  final gameEventActionsKey = GlobalKey();

  final financesTabKey = GlobalKey();

  static GameboardTutorialWidget of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<GameboardTutorialWidget>();
  }

  @override
  bool updateShouldNotify(GameboardTutorialWidget oldWidget) {
    return false;
  }

  void showTutorial(BuildContext context) {
    TutorialCoachMark(
      context,
      targets: getTargets(),
      textSkip: Strings.skip,
      onClickTarget: (target) async {
        if (target.keyTarget == gameEventKey) {
          await Future.delayed(const Duration(milliseconds: 50));
          Scrollable.ensureVisible(gameEventKey.currentContext);
        }

        if (target.keyTarget == gameEventActionsKey) {
          await Future.delayed(const Duration(milliseconds: 150));
          Scrollable.ensureVisible(gameEventActionsKey.currentContext);
        }
      },
      onClickSkip: () => _onTutorialPassed(context),
      onFinish: () => _onTutorialPassed(context),
    )..show();
  }

  void _onTutorialPassed(BuildContext context) {
    StoreProvider.dispatch<AppState>(
      context,
      MarkGameboardTutorialAsPassedAction(),
    );

    appRouter.goBack();
    appRouter.goTo(const GameBoard());
  }

  List<TargetFocus> getTargets() {
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
        ),
      ),
      TargetFocus(
        identify: 'CashFlow',
        keyTarget: cashFlowKey,
        contents: createTargetContent(
          title: Strings.cashFlow,
          description: Strings.cashFlowDescription,
        ),
      ),
      TargetFocus(
        identify: 'Cash',
        keyTarget: cashKey,
        contents: createTargetContent(
          title: Strings.cash,
          description: Strings.cashDescription,
        ),
      ),
      TargetFocus(
        identify: 'Credit',
        keyTarget: creditKey,
        contents: createTargetContent(
          title: Strings.credit,
          description: Strings.creditDescription,
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
          align: AlignContent.top,
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
          align: AlignContent.top,
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
          align: AlignContent.top,
        ),
      ),
    ];
  }

  List<ContentTarget> createTargetContent({
    String title,
    String description,
    AlignContent align = AlignContent.bottom,
  }) {
    return [
      ContentTarget(
        align: align,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (align == AlignContent.bottom) const SizedBox(height: 32),
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
            if (align == AlignContent.top) const SizedBox(height: 8),
          ],
        ),
      )
    ];
  }
}
