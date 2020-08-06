import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/widgets/buttons/color_button.dart';
import 'package:flutter/cupertino.dart';

class CommonErrorWidget extends StatelessWidget {
  const CommonErrorWidget(this.onPressed);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              Strings.unknownErrorTitle,
              textAlign: TextAlign.center,
              style: Styles.body1.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              Strings.unknownError,
              textAlign: TextAlign.center,
              style: Styles.body1,
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 50,
              width: 150,
              child: ColorButton(
                color: ColorRes.yellow,
                text: Strings.retry,
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
