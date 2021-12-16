import 'dart:math';

import 'package:cash_flow/app/state_hooks.dart';
import 'package:cash_flow/core/hooks/feedback_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'gameboard_menu_controller.dart';

class GameboardMenu extends HookWidget {
  const GameboardMenu({Key? key, required this.controller}) : super(key: key);

  final GameboardMenuController controller;

  @override
  Widget build(BuildContext context) {
    final isMenuShown = useState(false);
    final userId = useUserId()!;
    final game = useCurrentGame((g) => g)!;
    final feedbackSender = useFeedbackSender();

    useEffect(() {
      controller.addListener(() {
        isMenuShown.value = controller.isShown;
      });
      return controller.dispose;
    }, []);

    return IgnorePointer(
      ignoring: !isMenuShown.value,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: controller.close,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          opacity: isMenuShown.value ? 1 : 0,
          child: Container(
            color: Colors.black.withAlpha(50),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: min(300, MediaQuery.of(context).size.width * 0.7),
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 12,
                  right: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ColorRes.lightGrey),
                  boxShadow: const [
                    BoxShadow(blurRadius: 6, color: Colors.black45),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _MenuItem(
                      title: Strings.close,
                      icon: Icons.close,
                      onTap: controller.close,
                    ),
                    const _Divider(),
                    _MenuItem(
                      title: Strings.goToMainMenu,
                      icon: Icons.arrow_back_sharp,
                      onTap: appRouter.goBack,
                    ),
                    const _Divider(),
                    _MenuItem(
                      title: Strings.feedback,
                      icon: Icons.message,
                      onTap: () {
                        controller.close();
                        feedbackSender.showFeedbackPage(game, userId);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: Styles.bodyBlack)),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: ColorRes.greyCog.withAlpha(100),
      height: 0.5,
    );
  }
}