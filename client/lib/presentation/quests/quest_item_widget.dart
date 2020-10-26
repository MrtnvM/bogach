import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/models/domain/game/quest/quest.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum QuestAction { startNewGame, continueGame }

class QuestItemWidget extends HookWidget {
  const QuestItemWidget({
    @required this.quest,
    @required this.currentGameId,
    @required this.onQuestSelected,
    @required this.isLocked,
  });

  final Quest quest;
  final String currentGameId;
  final bool isLocked;
  final void Function(Quest, QuestAction) onQuestSelected;

  @override
  Widget build(BuildContext context) {
    final isCollapsed = useState(true);

    return _buildContent(isCollapsed);
  }

  Widget _buildContent(ValueNotifier<bool> isCollapsed) {
    return GestureDetector(
      onTap: () {
        if (isLocked) {
          onQuestSelected?.call(null, QuestAction.startNewGame);
          return;
        }

        if (currentGameId == null) {
          onQuestSelected?.call(quest, QuestAction.startNewGame);
          return;
        }

        isCollapsed.value = !isCollapsed.value;
      },
      child: Opacity(
        opacity: isLocked ? 0.7 : 1,
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
                          if (isLocked) ...const [
                            Icon(Icons.lock, size: 11),
                            SizedBox(width: 4),
                          ],
                          Text(
                            '${quest.name}',
                            style: Styles.bodyBlackBold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${quest.description}',
                        style: Styles.bodyBlack,
                        maxLines: 2,
                      ),
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
                      _QuestActionButton(
                        title: Strings.startAgain,
                        color: ColorRes.grey2,
                        action: () {
                          onQuestSelected(quest, QuestAction.startNewGame);
                        },
                      ),
                      _QuestActionButton(
                        title: Strings.continueAction,
                        color: ColorRes.yellow,
                        action: () {
                          onQuestSelected(quest, QuestAction.continueGame);
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

  Widget getTemplateIcon() {
    return Image(
      image: CachedNetworkImageProvider(quest.icon),
      height: 38,
      width: 38,
    );
  }
}

class _QuestActionButton extends StatelessWidget {
  const _QuestActionButton({
    Key key,
    this.action,
    this.color,
    this.title,
  }) : super(key: key);

  final VoidCallback action;
  final Color color;
  final String title;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: action,
      child: Container(
        height: 34,
        width: screenWidth < 350 ? 100 : 130,
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
}
