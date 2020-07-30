import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
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
        ]
      ],
    );
  }
}
