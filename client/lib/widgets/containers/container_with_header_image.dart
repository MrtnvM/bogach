import 'package:cash_flow/core/hooks/global_state_hook.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ContainerWithHeaderImage extends HookWidget {
  const ContainerWithHeaderImage({
    Key key,
    @required this.children,
    @required this.navBarTitle,
  }) : super(key: key);

  final List<Widget> children;
  final String navBarTitle;

  @override
  Widget build(BuildContext context) {
    final scrollController = useMemoized(() => ScrollController());

    final isSendingTurnEvent = useGlobalState((state) {
      final activeGameState = state.game.activeGameState;

      final isSent = activeGameState.maybeWhen(
        gameEvent: (eventIndex, sendingEventIndex) =>
            eventIndex == sendingEventIndex,
        orElse: () => false,
      );

      return isSent;
    });

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    const imageAspectRatio = 2;
    final imageHeight = screenWidth / imageAspectRatio;
    final contentOffset = imageHeight * 0.76;

    return Stack(
      children: <Widget>[
        _buildHeaderImage(imageHeight),
        ListView(
          controller: scrollController,
          padding: EdgeInsets.only(top: contentOffset, bottom: 16),
          children: children,
        ),
        if (isSendingTurnEvent) _buildLoader(),
        NavigationBar(
          title: navBarTitle,
          scrollController: scrollController,
        ),
      ],
    );
  }

  Widget _buildHeaderImage(double imageHeight) {
    return Container(
      color: ColorRes.primaryBackgroundColor,
      height: imageHeight,
      alignment: Alignment.bottomCenter,
      child: const Image(image: AssetImage(Images.money)),
    );
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
}
