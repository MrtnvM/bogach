import 'dart:collection';

import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/widgets/tutorial/gameboard_tutorial_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InfoTable extends StatelessWidget {
  const InfoTable(this.map);

  final LinkedHashMap<String, String> map;

  @override
  Widget build(BuildContext context) {
    final gameTutorial = GameboardTutorialWidget.of(context);

    return Column(
      key: gameTutorial?.gameEventKey,
      children: [
        for (final key in map.keys)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[Text(key), const Spacer(), Text(map[key]!)],
              ),
              const SizedBox(height: 2),
              const Divider(
                height: 0,
                color: ColorRes.black,
              ),
            ],
          ),
      ],
    );
  }
}
