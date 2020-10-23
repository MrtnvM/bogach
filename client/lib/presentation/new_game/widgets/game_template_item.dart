import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameTemplateItem extends HookWidget {
  const GameTemplateItem({
    @required this.gameTemplate,
    @required this.onStartNewGamePressed,
    this.onContinueGamePressed,
  });

  final GameTemplate gameTemplate;
  final void Function(GameTemplate) onStartNewGamePressed;
  final void Function(GameTemplate) onContinueGamePressed;

  @override
  Widget build(BuildContext context) {
    final gameTarget = gameTemplate.target;
    final targetTitle = mapTargetTypeToString(gameTarget.type).toLowerCase();
    final targetValue = gameTarget.value.round().toPrice();
    final isCollapsed = useState(true);

    return GestureDetector(
      onTap: () {
        if (onContinueGamePressed == null) {
          onStartNewGamePressed(gameTemplate);
        } else {
          isCollapsed.value = !isCollapsed.value;
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          top: 14,
          bottom: 22,
          left: 16,
          right: 16,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${gameTemplate.name}',
                    style: Styles.bodyBlackBold,
                  ),
                ),
                const SizedBox(width: 16),
                getTemplateIcon(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${Strings.reach} $targetTitle '
              '${Strings.wordIn} $targetValue',
              style: Styles.bodyBlack,
            ),
            AnimatedContainer(
              width: double.infinity,
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(top: isCollapsed.value ? 0 : 16),
              height: isCollapsed.value ? 0 : 40,
              duration: const Duration(milliseconds: 300),
              child: AnimatedOpacity(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                opacity: isCollapsed.value ? 0 : 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ActionButton(
                      text: Strings.startAgain,
                      textStyle: Styles.bodyBlack.copyWith(fontSize: 12.5),
                      color: ColorRes.grey2,
                      onPressed: () => onStartNewGamePressed(gameTemplate),
                    ),
                    ActionButton(
                      text: Strings.continueAction,
                      textStyle: Styles.bodyBlack.copyWith(fontSize: 12.5),
                      color: ColorRes.yellow,
                      onPressed: () => onContinueGamePressed(gameTemplate),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTemplateIcon() {
    return SvgPicture.network(
      gameTemplate.icon,
      height: 38,
      width: 38,
    );
  }
}
