import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class BottomBarItem {
  const BottomBarItem({
    @required this.title,
    @required this.image,
    this.onPressed,
  });

  final String title;
  final String image;
  final VoidCallback onPressed;
}

class BottomBar extends StatelessWidget {
  const BottomBar({Key key, this.items = const []}) : super(key: key);
  final List<BottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          for (var item in items) Expanded(child: _buildBarButton(item)),
        ],
      ),
    );
  }

  Widget _buildBarButton(BottomBarItem item) {
    return GestureDetector(
      onTap: item.onPressed,
      child: Container(
        color: ColorRes.primaryBackgroundColor,
        height: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage(item.image)),
            Text(
              item.title,
              style: Styles.body1.copyWith(
                color: ColorRes.primaryWhiteColor,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
