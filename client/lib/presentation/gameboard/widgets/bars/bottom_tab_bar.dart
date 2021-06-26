import 'dart:ui' show lerpDouble;
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomTabBarItem {
  BottomTabBarItem({
    required this.title,
    required this.svgAsset,
    this.key,
    this.icon,
    this.backgroundColor = Colors.white,
  });

  final Key? key;
  final String? svgAsset;
  final IconData? icon;
  final String title;
  final Color backgroundColor;
}

class BottomTabBar extends StatefulWidget {
  const BottomTabBar({
    Key? key,
    required this.tabController,
    required this.onTap,
    required this.items,
    this.indicatorColor,
    this.activeColor,
    this.inactiveColor = Colors.grey,
    this.shadow = true,
  }) : super(key: key);

  final TabController tabController;
  final Color? indicatorColor;
  final Color? activeColor;
  final Color inactiveColor;
  final bool shadow;
  final ValueChanged<int> onTap;
  final List<BottomTabBarItem> items;

  @override
  State createState() => BottomTabBarState();
}

class BottomTabBarState extends State<BottomTabBar> {
  static const barHeight = 60.0;
  static const indicatorHeight = 2.0;

  List<BottomTabBarItem> get items => widget.items;

  double width = 0;
  Color? activeColor;
  Duration duration = const Duration(milliseconds: 170);
  late int currentIndex;
  bool _isAnimationListenerEnabled = true;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.tabController.index;
    widget.tabController.animation?.addListener(_onChangingSelectedTab);
  }

  @override
  void dispose() {
    widget.tabController.animation?.removeListener(_onChangingSelectedTab);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    activeColor = widget.activeColor ?? Theme.of(context).indicatorColor;

    return Container(
      height: barHeight + MediaQuery.of(context).viewPadding.bottom,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: widget.shadow
            ? [const BoxShadow(color: Colors.black12, blurRadius: 10)]
            : null,
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: indicatorHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items.map((item) {
                final index = items.indexOf(item);

                return GestureDetector(
                  onTap: () {
                    _isAnimationListenerEnabled = false;
                    _select(index);
                  },
                  child: _buildItemWidget(item, index == currentIndex),
                );
              }).toList(),
            ),
          ),
          Positioned(
            top: 0,
            width: width,
            child: AnimatedAlign(
              alignment: Alignment(_getIndicatorPosition(currentIndex), 0),
              curve: Curves.linear,
              duration: duration,
              child: Container(
                color: widget.indicatorColor ?? activeColor,
                width: width / items.length,
                height: indicatorHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _select(int index) {
    setState(() => currentIndex = index);
    widget.onTap(index);
  }

  void _onChangingSelectedTab() {
    final offset = widget.tabController.offset;

    if (!_isAnimationListenerEnabled) {
      if (offset == 0) {
        _isAnimationListenerEnabled = true;
      }

      return;
    }

    final newIndex = (widget.tabController.index + offset).round();
    _select(newIndex);
  }

  double _getIndicatorPosition(int index) {
    final isLtr = Directionality.of(context) == TextDirection.ltr;

    if (isLtr) {
      return lerpDouble(-1.0, 1.0, index / (items.length - 1)) ?? 0.0;
    }

    return lerpDouble(1.0, -1.0, index / (items.length - 1)) ?? 0.0;
  }

  Widget _buildItemWidget(
    BottomTabBarItem item,
    bool isSelected,
  ) {
    final color = isSelected ? activeColor : widget.inactiveColor;
    final titleStyle = (isSelected ? Styles.selectedTab : Styles.unselectedTab)
        .copyWith(color: color);

    return Container(
      key: item.key,
      color: item.backgroundColor,
      height: barHeight,
      width: width / items.length,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (item.svgAsset != null)
            SvgPicture.asset(item.svgAsset!, color: color)
          else
            Icon(item.icon, color: color, size: 24.0),
          const SizedBox(height: 3),
          Text(item.title, style: titleStyle),
        ],
      ),
    );
  }
}
