import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventButtons extends StatelessWidget {
  const EventButtons(this._state);

  final ButtonsState _state;

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case ButtonsState.normal:
        return _buildNormalState(isNormal: true);
      case ButtonsState.buy:
        return _buildNormalState(isNormal: false);
      case ButtonsState.skip:
        return _buildSkipState();
      default:
        return Container();
    }
  }

  Widget _buildNormalState({bool isNormal = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ActionButton(
          onPressed: () {},
          color: ColorRes.orange,
          text: Strings.takeLoan,
        ),
        const SizedBox(width: 6),
        ActionButton(
          onPressed: () {},
          color: ColorRes.green,
          text: isNormal ? Strings.confirm : Strings.buy,
        ),
        const SizedBox(width: 6),
        ActionButton(
          onPressed: () {},
          color: Colors.grey,
          text: Strings.skip,
        ),
      ],
    );
  }

  Widget _buildSkipState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ActionButton(
          onPressed: () {},
          color: ColorRes.grey,
          text: Strings.continueAction,
        ),
      ],
    );
  }
}

enum ButtonsState {
  normal,
  skip,
  buy,
}
