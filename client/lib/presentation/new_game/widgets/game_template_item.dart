import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameTemplateItem extends StatelessWidget {
  const GameTemplateItem({
    @required this.gameTemplate,
    @required this.onTemplateSelected,
  });

  final GameTemplate gameTemplate;
  final void Function(GameTemplate) onTemplateSelected;

  @override
  Widget build(BuildContext context) {
    final gameTarget = gameTemplate.target;
    final targetTitle = mapTargetTypeToString(gameTarget.type).toLowerCase();
    final targetValue = gameTarget.value.round().toPrice();

    return GestureDetector(
      onTap: () => onTemplateSelected(gameTemplate),
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
                    '${gameTemplate.name} — '
                    '${gameTemplate.accountState.cash.round().toPrice()}',
                    style: Styles.bodyBlackBold,
                  ),
                ),
                const SizedBox(width: 16),
                SvgPicture.asset(
                  Images.icCourier,
                  height: 38,
                  width: 38,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${Strings.reach} $targetTitle '
              '${Strings.wordIn} $targetValue',
              style: Styles.bodyBlack,
            ),
          ],
        ),
      ),
    );
  }
}
