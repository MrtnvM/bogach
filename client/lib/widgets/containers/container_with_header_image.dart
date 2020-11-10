import 'dart:async';

import 'package:cash_flow/app/app_state.dart';
import 'package:cash_flow/app/operation.dart';
import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/core/hooks/media_query_hooks.dart';
import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/game/type/game_type.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/avatar/avatar_widget.dart';
import 'package:cash_flow/widgets/backgrounds/status_bar_background.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:dash_kit_core/dash_kit_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ContainerWithHeaderImage extends HookWidget {
  const ContainerWithHeaderImage({
    @required this.children,
    @required this.navBarTitle,
    Key key,
    this.subTitle,
    this.imageUrl,
    this.imageSvg,
    this.isLoading,
  }) : super(key: key);

  final List<Widget> children;
  final String navBarTitle;
  final String subTitle;
  final String imageUrl;
  final String imageSvg;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final topAlign = useState(-1.0);
    final opacity = useState(1.0);

    final notchHeight = useNotchSize().top;
    final imageHeight = notchHeight + (subTitle != null ? 110 : 96);
    final contentOffset = imageHeight - 24;

    final onScroll = useMemoized(
      () => () {
        final scrollOffset = imageHeight * 1.55;
        final newTopAlign = -1 - scrollController.offset / scrollOffset;

        if (newTopAlign != topAlign.value) {
          topAlign.value = newTopAlign;
        }

        final opacityValue = 1 - scrollController.offset / 50;
        if (opacityValue != opacity.value) {
          opacity.value = opacityValue;
        }
      },
    );

    useEffect(() {
      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, []);

    final startNewMonthOperationState = useGlobalState(
      (s) => s.getOperationState(Operation.startNewMonth),
    );
    final activeGameState = useGlobalState((s) => s.game.activeGameState);
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) => onScroll());
      return null;
    }, [startNewMonthOperationState, activeGameState]);

    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment(0, topAlign.value),
          child: _Header(
            imageHeight: imageHeight,
            topPadding: notchHeight,
            navBarTitle: navBarTitle,
            subTitle: subTitle,
            imageUrl: imageUrl,
            imageSvg: imageSvg,
          ),
        ),
        ListView(
          physics: const ClampingScrollPhysics(),
          controller: scrollController,
          padding: EdgeInsets.only(top: contentOffset, bottom: 16),
          cacheExtent: 50,
          children: children,
        ),
        if (isLoading == true) _buildActivityIndicator(contentOffset),
        NavigationBar(opacity: opacity.value),
        StatusBarBackground(
          scrollOffset:
              scrollController.hasClients ? scrollController.offset : 0,
        ),
      ],
    );
  }

  Widget _buildActivityIndicator(double padding) {
    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: ColorRes.mainGreen,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key key,
    this.imageHeight,
    this.topPadding,
    this.navBarTitle,
    this.subTitle,
    this.imageUrl,
    this.imageSvg,
  }) : super(key: key);

  final String navBarTitle;
  final String subTitle;
  final String imageUrl;
  final String imageSvg;

  final double imageHeight;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final game = StoreProvider.state<AppState>(context).game.currentGame;
    final isMultiplayerGame = game.type == GameType.multiplayer();

    return Stack(
      children: <Widget>[
        Container(
          height: imageHeight,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: Styles.linearGradient,
          ),
          child: const _HeaderBackground(),
        ),
        Container(
          height: imageHeight,
          padding: EdgeInsets.only(top: topPadding),
          child: Center(
            child: _HeaderContent(
              navBarTitle: navBarTitle,
              subTitle: subTitle,
              imageUrl: imageUrl,
              imageSvg: imageSvg,
            ),
          ),
        ),
        if (isMultiplayerGame)
          Positioned(
            top: 0,
            right: 0,
            child: _Timer(),
          ),
      ],
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class _HeaderContent extends StatelessWidget {
  const _HeaderContent({
    Key key,
    this.navBarTitle,
    this.subTitle,
    this.imageUrl,
    this.imageSvg,
  }) : super(key: key);

  final String navBarTitle;
  final String subTitle;
  final String imageUrl;
  final String imageSvg;

  @override
  Widget build(BuildContext context) {
    final gameTutorial = GameboardTutorialWidget.of(context);
    final appState = StoreProvider.state<AppState>(context);
    final isQuestGame = appState.game.currentGame.config.level != null;

    return Column(
      children: <Widget>[
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderContentImage(
              imageUrl: imageUrl,
              imageSvg: imageSvg,
            ),
            const SizedBox(width: 8),
            Text(
              navBarTitle,
              style: Styles.bodyBlackBold.copyWith(color: ColorRes.white),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (subTitle != null)
          Text(
            subTitle,
            key: isQuestGame ? gameTutorial?.monthKey : null,
            style: Styles.bodyBlack.copyWith(
              color: ColorRes.white,
              fontSize: 15,
            ),
          ),
      ],
    );
  }
}

class _HeaderContentImage extends StatelessWidget {
  const _HeaderContentImage({
    Key key,
    this.imageUrl,
    this.imageSvg,
  }) : super(key: key);

  final String imageUrl;
  final String imageSvg;

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return UserAvatar(url: imageUrl, size: 28);
    }

    if (imageSvg != null) {
      return Container(
        width: 32,
        height: 32,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(27)),
          color: ColorRes.white,
        ),
        child: SvgPicture.asset(imageSvg, color: ColorRes.mainGreen),
      );
    }

    return const SizedBox();
  }
}

class _Timer extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final remainingSeconds = _useTimerRemainingSeconds();
    final minutes = (remainingSeconds ~/ 60).toString();
    final seconds = '${remainingSeconds % 60}'.padLeft(2, '0');
    const timerSize = 32.0;

    return Container(
      width: 68,
      height: timerSize,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 37),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
            fontSize: 16.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

int _useTimerRemainingSeconds() {
  final moveStartDate = useCurrentGame((s) => s.state.moveStartDateInUTC);
  final remainingSeconds = useState(_getRemainingSeconds(moveStartDate));

  useEffect(() {
    if (moveStartDate == null) {
      return null;
    }

    final subscription = Stream.periodic(const Duration(seconds: 1))
        .map((_) => _getRemainingSeconds(moveStartDate))
        .takeWhile((seconds) => seconds >= 0)
        .listen((seconds) => remainingSeconds.value = seconds);

    return subscription.cancel;
  }, [moveStartDate]);

  final remainingSecondsValue =
      remainingSeconds.value < 0 || remainingSeconds.value > 60
          ? 0
          : remainingSeconds.value;

  return remainingSecondsValue;
}

int _getRemainingSeconds(DateTime moveStartDate) {
  if (moveStartDate == null) {
    return 0;
  }

  final now = DateTime.now().toUtc();

  final moveEndTime = moveStartDate.add(const Duration(seconds: 60));
  final remainingTimeInMs =
      moveEndTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch;
  final remainingSeconds = remainingTimeInMs / 1000;

  return remainingSeconds.toInt();
}
