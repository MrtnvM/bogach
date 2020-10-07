import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/utils/app_store_connector.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContainerWithHeaderImage extends StatefulWidget {
  const ContainerWithHeaderImage({
    @required this.children,
    @required this.navBarTitle,
    Key key,
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
  _ContainerWithHeaderImageState createState() =>
      _ContainerWithHeaderImageState();
}

class _ContainerWithHeaderImageState extends State<ContainerWithHeaderImage> {
  final scrollController = ScrollController();

  double topAlign = -1.0;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(onScroll);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final nocthHeight = mediaQuery.padding.top;
    final imageHeight = _getBackgroundImageSize(nocthHeight);
    final contentOffset = imageHeight - 24;

    return Stack(
      children: <Widget>[
        _buildHeader(
          imageHeight: imageHeight,
          topAlign: topAlign,
          topPadding: nocthHeight,
        ),
        ListView(
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          padding: EdgeInsets.only(top: contentOffset, bottom: 16),
          children: widget.children,
        ),
        AppStateConnector(
          converter: shouldDisplayLoader,
          builder: (context, shouldDisplayLoader) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              onScroll();
            });

            return shouldDisplayLoader ? _buildLoader() : Container();
          },
        ),
        NavigationBar(
          scrollController: scrollController,
        ),
      ],
    );
  }

  bool shouldDisplayLoader(AppState s) {
    final isStartingNewMonth =
        s.getOperationState(Operation.startNewMonth).isInProgress;

    final activeGameState = s.game.activeGameState;
    final isSendingTurnEvent = activeGameState.maybeWhen(
      gameEvent: (eventIndex, sendingEventIndex) =>
          eventIndex == sendingEventIndex,
      orElse: () => false,
    );

    return isSendingTurnEvent || isStartingNewMonth;
  }

  void onScroll() {
    final mediaQuery = MediaQuery.of(context);
    final nocthHeight = mediaQuery.padding.top;
    final imageHeight = _getBackgroundImageSize(nocthHeight);
    final scrollOffset = imageHeight * 1.55;
    final newTopAlign = -1 - scrollController.offset / scrollOffset;

    if (newTopAlign != topAlign) {
      setState(() => topAlign = newTopAlign);
    }
  }

  Widget _buildHeader({
    double imageHeight,
    double topPadding,
    double topAlign,
  }) {
    final game = StoreProvider.state<AppState>(context).game.currentGame;
    final isMultiplayerGame = game.type == 'multiplayer';

    return Align(
      alignment: Alignment(0, topAlign),
      child: Stack(
        children: <Widget>[
          Container(
            height: imageHeight,
            width: double.infinity,
            decoration: const BoxDecoration(
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
          ),
          if (isMultiplayerGame)
            Positioned(
              top: 0,
              right: 0,
              child: _Timer(),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderBackground() {
    return Stack(
      children: const <Widget>[
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
          widget.navBarTitle,
          style: Styles.bodyBlackBold.copyWith(color: ColorRes.white),
        ),
        const SizedBox(height: 8),
        if (widget.subTitle != null)
          Text(
            widget.subTitle,
            style: Styles.bodyBlack.copyWith(
              color: ColorRes.white,
              fontSize: 15,
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderContentImage() {
    if (widget.imageUrl != null) {
      return UserAvatar(
        url: widget.imageUrl,
        size: 54,
      );
    }
    if (widget.imageSvg != null) {
      return Container(
        width: 54,
        height: 54,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(27)),
          color: ColorRes.white,
        ),
        child: SvgPicture.asset(
          widget.imageSvg,
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
    if (widget.subTitle != null) {
      return topPadding + 160;
    }
    return topPadding + 140;
  }
}

class _Timer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final moveStartDate = useCurrentGame((s) => s.state.moveStartDateInUTC);
    final remainingSeconds = useState(getRemainingSeconds(moveStartDate));

    useEffect(() {
      final subscription = Stream.periodic(const Duration(seconds: 1))
          .map((_) => getRemainingSeconds(moveStartDate))
          .takeWhile((seconds) => seconds >= 0)
          .listen((seconds) => remainingSeconds.value = seconds);

      return subscription.cancel;
    }, [moveStartDate]);

    final remainingSecondsValue =
        remainingSeconds.value < 0 || remainingSeconds.value > 60
            ? 0
            : remainingSeconds.value;

    final minutes = (remainingSecondsValue ~/ 60).toString();
    final secondsValue = '0${remainingSecondsValue % 60}';
    final seconds = secondsValue.substring(
      secondsValue.length - 2,
      secondsValue.length,
    );
    const timerSize = 40.0;

    return Container(
      width: 80,
      height: timerSize,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorRes.mainGreen,
        border: Border.all(color: ColorRes.white64, width: 1),
        borderRadius: BorderRadius.circular(timerSize / 2),
        boxShadow: [
          BoxShadow(blurRadius: 5, color: Colors.black.withAlpha(100)),
        ],
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          '$minutes:$seconds',
          style: Styles.body1.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  int getRemainingSeconds(DateTime moveStartDate) {
    final now = DateTime.now().toUtc();

    final moveEndTime = moveStartDate.add(const Duration(seconds: 60));
    final remainingTimeInMs =
        moveEndTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
    final remainingSeconds = remainingTimeInMs / 1000;

    return remainingSeconds.toInt();
  }
}
