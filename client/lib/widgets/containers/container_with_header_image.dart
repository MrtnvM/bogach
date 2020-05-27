import 'package:cash_flow/presentation/gameboard/widgets/bars/navigation_bar.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:flutter/material.dart';

class ContainerWithHeaderImage extends StatelessWidget {
  ContainerWithHeaderImage({
    Key key,
    @required this.children,
    @required this.navBarTitle,
  }) : super(key: key);

  final List<Widget> children;
  final String navBarTitle;

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
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
}
