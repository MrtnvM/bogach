import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/containers/event_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameEventWidget extends StatelessWidget {
  const GameEventWidget({
    @required this.icon,
    @required this.name,
    @required this.child,
    @required this.buttonsState,
    @required this.buttonsProperties,
  });

  final IconData icon;
  final String name;
  final Widget child;
  final ButtonsState buttonsState;
  final ButtonsProperties buttonsProperties;

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
                icon,
                color: ColorRes.white,
              ),
              const SizedBox(width: 12),
              Text(
                name.toUpperCase(),
                style: Styles.subhead.copyWith(color: ColorRes.white),
              ),
            ],
          ),
        ),
        child,
        EventButtons(buttonsState, buttonsProperties),
      ],
    );
  }
}
