import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameEvent extends StatefulWidget {
  const GameEvent({
    @required this.icon,
    @required this.name,
    @required this.child,
    @required this.buttonsState,
  });

  final IconData icon;
  final String name;
  final Widget child;
  final ButtonsState buttonsState;

  @override
  State<StatefulWidget> createState() {
    return GameEventState();
  }
}

class GameEventState extends State<GameEvent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: ColorRes.grey,
          child: Row(
            children: <Widget>[
              Icon(
                widget.icon,
                color: ColorRes.white,
              ),
              const SizedBox(width: 12),
              Text(
                widget.name.toUpperCase(),
                style: Styles.subhead.copyWith(color: ColorRes.white),
              ),
            ],
          ),
        ),
        widget.child,
        EventButtons(widget.buttonsState),
      ],
    );
  }
}
