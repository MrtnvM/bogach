import 'package:flutter/material.dart';

import 'footer_button.dart';

class BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const <Widget>[
        Expanded(
          child: FooterButton(
            image: 'assets/images/png/footer_financal.png',
            text: 'Финансы',
          ),
        ),
        Expanded(
          child: FooterButton(
            image: 'assets/images/png/footer_action.png',
            text: 'Действия',
          ),
        ),
        Expanded(
          child: FooterButton(
            image: 'assets/images/png/footer_history.png',
            text: 'История',
          ),
        ),
      ],
    );
  }
}
