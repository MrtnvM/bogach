import 'package:cash_flow/models/domain/game_template.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/utils/mappers/game_mapper.dart';
import 'package:flutter/material.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';

class TemplateGameItem extends StatelessWidget {
  const TemplateGameItem({
    @required this.game,
    @required this.onGamePressed,
  });

  final GameTemplate game;
  final void Function(GameTemplate game) onGamePressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onGamePressed(game),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${game.name} — ${game.accountState.cash.round().toPrice()}',
              style: _textStyle().merge(TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            Text(
              '${Strings.reach} '
              '${mapTargetTypeToString(game.target.type).toLowerCase()}'
              ' ${Strings.wordIn} ${game.target.value.round().toPrice()}',
              style: _textStyle(),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _textStyle() {
    return TextStyle(
      fontFamily: 'Montserrat',
      fontSize: 14,
      color: ColorRes.mainBlack,
    );
  }
}
