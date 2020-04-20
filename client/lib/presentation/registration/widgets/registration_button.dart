import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class RegistrationButton extends StatelessWidget {
  const RegistrationButton({Key key, this.onPressed}) : super(key: key);
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 207,
      height: 50,
      child: RaisedButton(
        onPressed: onPressed,
        color: ColorRes.primaryYellowColor,
        child: const Text(
          'Зарегистрироваться',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w200,
            fontFamily: 'Montserrat',
          ),
        ),
        textColor: Colors.black,
      ),
    );
  }
}
