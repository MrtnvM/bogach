import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomBarItem {
  const BottomBarItem({
    @required this.title,
    @required this.image,
    this.key,
    this.onPressed,
  });

  final String title;
  final String image;
  final GlobalKey key;
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
        color: ColorRes.bottomBarGray,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 1.0,
            spreadRadius: 1.5,
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
    return GestureDetector(
      onTap: item.onPressed,
      behavior: HitTestBehavior.translucent,
      child: SafeArea(
        child: SizedBox(
          key: item.key,
          height: 56,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(
                item.image,
                width: 24,
                height: 24,
                color:
                    isSelected ? ColorRes.mainGreen : ColorRes.primaryGreyColor,
              ),
              Text(
                item.title,
                style: Styles.bottomNavBarButtonTitle(isSelected: isSelected),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
