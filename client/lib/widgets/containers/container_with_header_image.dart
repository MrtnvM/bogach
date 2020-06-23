import 'dart:math';

import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContainerWithHeaderImage extends HookWidget {
  const ContainerWithHeaderImage({
    Key key,
    @required this.children,
    @required this.navBarTitle,
    this.subTitle,
    this.imageUrl,
    this.imageSvg,
  }) : super(key: key);

  final List<Widget> children;
  final String navBarTitle;
  final String subTitle;
  final String imageUrl;
  final String imageSvg;

  @override
  Widget build(BuildContext context) {
    final scrollController = useMemoized(() => ScrollController());
    final isStartingNewMonth = useGlobalState(
      (s) => s.game.startNewMonthRequestState.isInProgress,
    );

    final isSendingTurnEvent = useGlobalState((state) {
      final activeGameState = state.game.activeGameState;

      final isSent = activeGameState.maybeWhen(
        gameEvent: (eventIndex, sendingEventIndex) =>
            eventIndex == sendingEventIndex,
        orElse: () => false,
      );

      return isSent;
    });

    final notchSize = useNotchSize();
    final imageHeight = _getBackgroundImageSize(notchSize.top);
    final contentOffset = imageHeight - 24;

    final shouldDisplayLoader = isSendingTurnEvent || isStartingNewMonth;

    return Stack(
      children: <Widget>[
        _buildHeader(
          imageHeight: imageHeight,
          scrollController: scrollController,
          topPadding: notchSize.top,
        ),
        ListView(
          controller: scrollController,
          padding: EdgeInsets.only(top: contentOffset, bottom: 16),
          children: children,
        ),
        if (shouldDisplayLoader) _buildLoader(),
        NavigationBar(
          scrollController: scrollController,
        ),
      ],
    );
  }

  Widget _buildHeader({
    double imageHeight,
    ScrollController scrollController,
    double topPadding,
  }) {
    final opacity = useState(1.0);

    useEffect(() {
      final listener = () {
        return opacity.value = 1 - scrollController.offset / 50;
      };

      scrollController?.addListener(listener);
      return () => scrollController?.removeListener(listener);
    }, []);

    return Opacity(
      opacity: max(min(opacity.value, 1), 0),
      child: Stack(
        children: <Widget>[
          Container(
            height: imageHeight,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: Styles.linearGradient,
            ),
            child: _buildHeaderBackground(),
          ),
          Container(
            height: imageHeight,
            padding: EdgeInsets.only(top: topPadding),
            child: Center(
              child: _buildHeaderContent(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: Image(
            image: AssetImage(Images.bgCircleRight),
            fit: BoxFit.contain,
            width: 93,
            height: 87,
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Image(
            image: AssetImage(Images.bgCircleLeft),
            fit: BoxFit.contain,
            width: 119,
            height: 81,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        _buildHeaderContentImage(),
        const SizedBox(height: 8),
        Text(
          navBarTitle,
          style: Styles.bodyBlackBold.copyWith(color: ColorRes.white),
        ),
        const SizedBox(height: 8),
        if (subTitle != null)
          Text(
            subTitle,
            style: Styles.bodyBlack.copyWith(color: ColorRes.white),
          ),
      ],
    );
  }

  Widget _buildHeaderContentImage() {
    if (imageUrl != null) {
      return UserAvatar(
        url: imageUrl,
        size: 54,
      );
    }
    if (imageSvg != null) {
      return Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(27)),
          color: ColorRes.white,
        ),
        child: SvgPicture.asset(
          imageSvg,
          color: ColorRes.mainGreen,
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildLoader() {
    return Container(
      color: ColorRes.white64,
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: ColorRes.mainGreen,
        ),
      ),
    );
  }

  double _getBackgroundImageSize(double topPadding) {
    if (subTitle != null) {
      return topPadding + 160;
    }
    return topPadding + 140;
  }
}
