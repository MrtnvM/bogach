import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EventButtons extends StatelessWidget {
  const EventButtons() : _state = _ButtonsState.normal;

  const EventButtons.skip() : _state = _ButtonsState.skip;

  final _ButtonsState _state;

  @override
  Widget build(BuildContext context) {
    switch (_state) {
      case _ButtonsState.normal:
        return _buildNormalState();
      case _ButtonsState.skip:
        return _buildSkipState();
      default:
        return Container();
    }
  }

  Widget _buildNormalState() {
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
          text: Strings.confirm,
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

enum _ButtonsState {
  normal,
  skip,
}
