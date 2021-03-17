import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class GameCard extends HookWidget {
  const GameCard({
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.startGame,
    @required this.isCollapsed,
    @required this.onTap,
    this.continueGame,
  });

  final String title;
  final String description;
  final String imageUrl;
  final bool isCollapsed;
  final VoidCallback onTap;
  final VoidCallback startGame;
  final VoidCallback continueGame;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = useAdaptiveMediaQueryData();
    final size = useAdaptiveSize();

    return MediaQuery(
      data: mediaQuery,
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: max(size(116), 104),
              maxWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            padding: EdgeInsets.only(
              top: size(16),
              bottom: size(isCollapsed ? 16 : 20),
              left: size(16),
              right: size(16),
            ),
            decoration: BoxDecoration(
              color: ColorRes.imagePlaceholder,
              borderRadius: BorderRadius.all(Radius.circular(size(20))),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.grey.withAlpha(150),
                )
              ],
              image: imageUrl != null //
                  ? _getGameItemDecorationImage(imageUrl)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        firstChild: _buildGameContent(),
                        secondChild: _buildActionButtons(
                          isCollapsed: isCollapsed,
                        ),
                        crossFadeState: !isCollapsed
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Styles.bodyBlackBold.copyWith(
            color: ColorRes.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$description',
          style: Styles.bodyBlack.copyWith(color: ColorRes.white),
        ),
      ],
    );
  }

  Widget _buildActionButtons({bool isCollapsed}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _GameTemplateActionButton(
            title: Strings.startAgain,
            color: ColorRes.grey2,
            action: startGame,
          ),
          const SizedBox(height: 8),
          _GameTemplateActionButton(
            title: Strings.continueAction,
            color: ColorRes.yellow,
            action: continueGame,
          ),
        ],
      ),
    );
  }
}

DecorationImage _getGameItemDecorationImage(String url) {
  return DecorationImage(
    image: CachedNetworkImageProvider(url),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
      Colors.black.withAlpha(125),
      BlendMode.darken,
    ),
  );
}

class _GameTemplateActionButton extends HookWidget {
  const _GameTemplateActionButton({
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
    final size = useAdaptiveSize();

    return GestureDetector(
      onTap: action,
      child: Container(
        height: size(34),
        width: size(130),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: ColorRes.grey.withAlpha(70)),
        ),
        child: Text(
          title,
          style: Styles.bodyBlack.copyWith(fontSize: 12.5),
        ),
      ),
    );
  }
}
