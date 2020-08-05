import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/widgets/buttons/action_button.dart';
import 'package:flutter/cupertino.dart';

class CommonErrorWidget extends StatelessWidget {
  const CommonErrorWidget(this.onPressed);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Center(
        child: ActionButton(
          text: Strings.retry,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
