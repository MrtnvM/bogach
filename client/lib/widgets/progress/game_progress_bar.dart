import 'dart:math';

import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameProgressBar extends StatelessWidget {
  const GameProgressBar({
    @required this.name,
    @required this.currentValue,
    @required this.maxValue,
  })  : percent = (currentValue / maxValue) > 1 ? 1 : currentValue / maxValue,
        assert(name != null),
        assert(currentValue != null),
        assert(maxValue != null);

  final String name;
  final double currentValue;
  final double maxValue;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: ColorRes.gallery,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: <Widget>[
          Transform.rotate(
            angle: -pi / 4,
            child: Icon(Icons.videogame_asset, color: ColorRes.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(name),
                    const Spacer(),
                    Text(
                      currentValue.toPrice(),
                      style: DefaultTextStyle.of(context)
                          .style
                          .copyWith(color: ColorRes.green),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(value: percent),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${(percent * 100).floor()}%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
