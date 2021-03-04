import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/images.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonErrorWidget extends StatelessWidget {
  const CommonErrorWidget(this.onPressed);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(Images.noInternet, height: 72, width: 72),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(),
                const SizedBox(height: 4),
                _buildDescription(),
                const SizedBox(height: 12),
                _buildRetryButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Text(
      Strings.unknownError,
      textAlign: TextAlign.left,
      style: Styles.bodyBlack.copyWith(
        fontSize: 14,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      Strings.unknownErrorTitle,
      textAlign: TextAlign.center,
      style: Styles.body1.copyWith(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRetryButton() {
    return SizedBox(
      height: 32,
      width: 120,
      child: RaisedButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: ColorRes.mainGreen,
        padding: const EdgeInsets.all(4),
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(
            Strings.retry,
            style: Styles.body1,
          ),
        ),
      ),
    );
  }
}
