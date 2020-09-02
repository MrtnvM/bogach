import 'package:cash_flow/models/domain/game/game_level/game_level.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum GameLevelAction { startNewGame, continueGame }

class GameLevelItemWidget extends HookWidget {
  const GameLevelItemWidget({
    @required this.gameLevel,
    @required this.currentGameId,
    @required @required this.onLevelSelected,
  });

  final GameLevel gameLevel;
  final String currentGameId;
  final void Function(GameLevel, GameLevelAction) onLevelSelected;

  @override
  Widget build(BuildContext context) {
    final isCollapsed = useState(true);

    return GestureDetector(
      onTap: () {
        if (onLevelSelected == null) {
          return;
        }

        if (currentGameId == null) {
          onLevelSelected?.call(gameLevel, GameLevelAction.startNewGame);
        } else {
          isCollapsed.value = !isCollapsed.value;
        }
      },
      child: Opacity(
        opacity: onLevelSelected == null ? 0.7 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 16,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          if (onLevelSelected == null) ...[
                            Icon(Icons.lock, size: 11),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            '${gameLevel.name}',
                            style: Styles.bodyBlackBold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${gameLevel.description}', style: Styles.bodyBlack),
                    ],
                  ),
                  const Spacer(),
                  getTemplateIcon(),
                ],
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
                      _buildButton(
                        title: Strings.startAgain,
                        color: ColorRes.grey2,
                        action: () {
                          onLevelSelected(
                            gameLevel,
                            GameLevelAction.startNewGame,
                          );
                        },
                      ),
                      _buildButton(
                        title: Strings.continueAction,
                        color: ColorRes.yellow,
                        action: () {
                          onLevelSelected(
                            gameLevel,
                            GameLevelAction.continueGame,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({String title, VoidCallback action, Color color}) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 34,
        width: 130,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: ColorRes.grey.withAlpha(70)),
        ),
        child: Text(title, style: Styles.bodyBlack.copyWith(fontSize: 12.5)),
      ),
    );
  }

  Widget getTemplateIcon() {
    return Image.network(
      gameLevel.icon,
      height: 38,
      width: 38,
    );
  }
}
