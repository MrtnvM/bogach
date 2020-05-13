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
  const BottomBar({
    Key key,
    this.items = const [],
    this.selectedItemIndex = 0,
  })  : assert(selectedItemIndex >= 0 && selectedItemIndex < items.length),
        super(key: key);

  final List<BottomBarItem> items;
  final int selectedItemIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.primaryBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 2.0,
            spreadRadius: 3.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: _buildBarButton(
                item: items[i],
                isSelected: i == selectedItemIndex,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBarButton({BottomBarItem item, bool isSelected}) {
    return Container(
      child: GestureDetector(
        onTap: item.onPressed,
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Container(
            height: 55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(item.image),
                  color: isSelected
                      ? ColorRes.primaryWhiteColor
                      : ColorRes.primaryWhiteColor.withAlpha(180),
                ),
                Text(
                  item.title,
                  style: Styles.body1.copyWith(
                    color: isSelected
                        ? ColorRes.primaryWhiteColor
                        : ColorRes.primaryWhiteColor.withAlpha(120),
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
