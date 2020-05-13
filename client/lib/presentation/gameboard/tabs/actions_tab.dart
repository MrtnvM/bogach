import 'package:cash_flow/features/game/game_hooks.dart';
import 'package:cash_flow/models/domain/game/target/target.dart';
import 'package:cash_flow/presentation/gameboard/game_event_page.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/presentation/gameboard/widgets/bars/progress_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/widgets/containers/card_container.dart';
import 'package:cash_flow/widgets/progress/account_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ActionsTab extends HookWidget {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final target = useCurrentGame((g) => g.target);
    final targetTitle = mapTargetTypeToString(target.type);

    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    const imageAspectRatio = 2.03;
    final imageHeight = screenWidth / imageAspectRatio;
    final contentOffset = imageHeight * 0.76;

    return Stack(
      children: <Widget>[
        _buildHeaderImage(imageHeight),
        ListView(
          controller: scrollController,
          padding: EdgeInsets.only(top: contentOffset, left: 16, right: 16),
          children: <Widget>[
            CardContainer(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: const <Widget>[
                  ProgressBar(),
                  SizedBox(height: 16),
                  AccountBar(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const GameEventPage(),
            const SizedBox(height: 16),
          ],
        ),
        NavigationBar(title: targetTitle, scrollController: scrollController),
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
}
