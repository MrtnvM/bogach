import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/models/domain/game/game_template/game_template.dart';
import 'package:cash_flow/navigation/app_router.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/shimmer/default_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RoomHeader extends HookWidget {
  const RoomHeader({Key? key, required this.templateId}) : super(key: key);

  final String? templateId;

  @override
  Widget build(BuildContext context) {
    final screenSize = useScreenSize();
    final headerDesiredHeight = screenSize.height * 0.3;
    final headerHeight =
        min(headerDesiredHeight, screenSize.height > 700 ? 300.0 : 200.0);

    final template = useGlobalState(
      (s) => s.newGame.gameTemplates.itemsMap[templateId],
    );

    return SizedBox(
      width: double.infinity,
      height: headerHeight,
      child: Stack(
        children: [
          if (template == null)
            const DefaultShimmer()
          else
            _buildHeaderImage(template),
          _buildRoomContent(template, screenSize),
          _buildBackButton(context),
        ],
      ),
    );
  }

  Positioned _buildBackButton(BuildContext context) {
    return Positioned(
      child: GestureDetector(
        onTap: appRouter.goBack,
        behavior: HitTestBehavior.translucent,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16 + MediaQuery.of(context).padding.top,
          ),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white.withAlpha(200),
          ),
        ),
      ),
    );
  }

  Positioned _buildRoomContent(GameTemplate? template, Size screenSize) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (template == null)
            _buildPlaceholder(screenSize.width * 0.4)
          else
            Text(
              template.name,
              style: Styles.bodyWhiteBold.copyWith(fontSize: 16),
            ),
          const SizedBox(height: 4),
          if (template == null)
            _buildPlaceholder(screenSize.width * 0.7)
          else
            Text(
              template.getDescription(),
              style: Styles.body1.copyWith(fontSize: 16),
            ),
        ],
      ),
    );
  }

  Container _buildPlaceholder(double width) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(140),
        borderRadius: BorderRadius.circular(6),
      ),
      height: 20,
      width: width,
    );
  }

  Stack _buildHeaderImage(GameTemplate template) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image(
            image: CachedNetworkImageProvider(template.image!),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.black.withAlpha(100)),
        ),
      ],
    );
  }
}
