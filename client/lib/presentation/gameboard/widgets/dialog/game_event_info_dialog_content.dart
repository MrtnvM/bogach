import 'dart:ui';

import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GameEventInfoDialogContent extends StatelessWidget {
  const GameEventInfoDialogContent(this.gameEventInfoDialogModel);

  final GameEventInfoDialogModel gameEventInfoDialogModel;

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                  text: '${keyPoint.key}: ',
                  style: Styles.tableHeaderValueBlack,
                ),
                TextSpan(
                  text: '${keyPoint.value}',
                  style: Styles.bodyBlack,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        buildParameterContainer(
          Strings.riskLevel,
          gameEventInfoDialogModel.riskLevel,
          Images.riskLightingIcon,
          Images.riskLightingEmptyIcon,
        ),
        const SizedBox(height: 16),
        buildParameterContainer(
          Strings.profitabilityLevel,
          gameEventInfoDialogModel.profitabilityLevel,
          Images.profitabilityLightingIcon,
          Images.profitabilityLightingEmptyIcon,
        ),
        const SizedBox(height: 16),
        buildParameterContainer(
          Strings.complexityLevel,
          gameEventInfoDialogModel.complexityLevel,
          Images.complexityLightingIcon,
          Images.complexityLightingEmptyIcon,
        ),
      ],
    );
  }

  Container buildParameterContainer(
    String name,
    Rating level,
    String activeIcon,
    String deactiveIcon,
  ) {
    return Container(
      padding: const EdgeInsets.only(
        top: 4,
        right: 8,
        bottom: 4,
        left: 8,
      ),
      decoration: BoxDecoration(
        color: ColorRes.grey2,
        borderRadius: const BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      child: buildParameterContent(
        name,
        level,
        activeIcon,
        deactiveIcon,
      ),
    );
  }

  Row buildParameterContent(
    String name,
    Rating level,
    String activeIcon,
    String deactiveIcon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          name,
          style: Styles.tableHeaderValueBlack,
        ),
        ...drawIcons(
          level,
          activeIcon,
          deactiveIcon,
        ),
      ],
    );
  }

  List<Widget> drawIcons(Rating level, String activeIcon, String deactiveIcon) {
    final ratingValue = RatingMapper.getRatingLevel(level);

    List<Widget> widgets = [];
    for (var i = 0; i < 3; i++) {
      Widget image;
      if (ratingValue >= i + 1) {
        image = SvgPicture.asset(
          activeIcon,
          width: 20,
          height: 20,
        );
      } else {
        image = SvgPicture.asset(
          deactiveIcon,
          width: 20,
          height: 20,
        );
      }
      widgets.add(const SizedBox(width: 8));
      widgets.add(image);
    }
    return widgets;
  }
}
