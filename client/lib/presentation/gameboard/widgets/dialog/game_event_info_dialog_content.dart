import 'dart:ui';

import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class GameEventInfoDialogContent extends StatelessWidget {
  const GameEventInfoDialogContent(this.gameEventInfoDialogModel);

  final GameEventInfoDialogModel gameEventInfoDialogModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Text(
          gameEventInfoDialogModel.title,
          style: Styles.tableHeaderTitleBlack,
        ),
        const SizedBox(height: 32),
         Text(
          gameEventInfoDialogModel.description,
          style: Styles.tableHeaderTitleBlack,
        ),
        const SizedBox(height: 16),
        for (var keyPoint in gameEventInfoDialogModel.keyPoints.entries) ...[
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$keyPoint.key: ',
                  style: Styles.tableHeaderTitleBlack,
                ),
                TextSpan(
                  text: '$keyPoint.key: ',
                  style: Styles.tableHeaderValueBlack,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 4,
                  right: 8,
                  bottom: 4,
                  left: 4,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.grey,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Риск",
                      style: Styles.tableHeaderValueBlack,
                    ),
                    ...drawIcons(),
                  ],
                ),
              ),
              flex: 1,
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> drawIcons() {
    var ratingValue = RatingMapper.getRatingLevel(
      gameEventInfoDialogModel.riskLevel,
    );

    final widgets = [];
    for (var i = 0; i < 3; i++) {
      var image;
      if (ratingValue >= i + 1) {
        image = Image.asset(
          Images.lightingIcon,
          width: 16,
          height: 16,
        );
      } else {
        image = Image.asset(
          Images.lightingEmptyIcon,
          width: 16,
          height: 16,
        );
      }
      widgets.add(image);
    }
    return widgets;
  }
}
