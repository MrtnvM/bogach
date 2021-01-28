import 'dart:ui';

import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/dialog/game_event_info_dialog_model.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

class GameEventInfoDialogContent extends HookWidget {
  const GameEventInfoDialogContent(this.gameEventInfoDialogModel);

  final GameEventInfoDialogModel gameEventInfoDialogModel;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = useAdaptiveMediaQueryData();
    final keyPoints = gameEventInfoDialogModel.keyPoints.entries;

    return MediaQuery(
      data: mediaQueryData,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              gameEventInfoDialogModel.description,
              style: Styles.tableDialogSubtitleBlack,
            ),
            const SizedBox(height: 16),
            for (var keyPoint in keyPoints) ...[
              RichText(
                textScaleFactor: mediaQueryData.textScaleFactor,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${keyPoint.key}: ',
                      style: Styles.tableDialogSubtitleBlack,
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
            const SizedBox(height: 16),
            buildParameterContainer(
              name: Strings.riskLevel,
              level: gameEventInfoDialogModel.riskLevel,
              activeIcon: Images.riskLightingIcon,
              deactiveIcon: Images.riskLightingEmptyIcon,
            ),
            const SizedBox(height: 16),
            buildParameterContainer(
              name: Strings.profitabilityLevel,
              level: gameEventInfoDialogModel.profitabilityLevel,
              activeIcon: Images.profitabilityLightingIcon,
              deactiveIcon: Images.profitabilityLightingEmptyIcon,
            ),
            const SizedBox(height: 16),
            buildParameterContainer(
              name: Strings.complexityLevel,
              level: gameEventInfoDialogModel.complexityLevel,
              activeIcon: Images.complexityLightingIcon,
              deactiveIcon: Images.complexityLightingEmptyIcon,
            ),
          ],
        ),
      ),
    );
  }

  Container buildParameterContainer({
    String name,
    Rating level,
    String activeIcon,
    String deactiveIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      decoration: const BoxDecoration(
        color: ColorRes.grey2,
        borderRadius: BorderRadius.all(
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
          style: Styles.tableDialogSubtitleBlack,
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
    final ratingValue = RatingExtension.getRatingLevel(level);
    return [
      for (var i = 0; i < 3; i++) ...[
        const SizedBox(width: 8),
        SvgPicture.asset(
          ratingValue >= i + 1 ? activeIcon : deactiveIcon,
          width: 20,
          height: 20,
        ),
      ]
    ];
  }
}
