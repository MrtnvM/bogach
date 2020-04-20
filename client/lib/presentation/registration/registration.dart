import 'package:cash_flow/presentation/registration/widgets/registration_form.dart';
import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class RegistrationBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.primaryBackgroundColor,
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 95, bottom: 24),
            child: const Text(
              'Регистрация',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
                color: ColorRes.primaryWhiteColor,
              ),
            ),
          ),
          const RegistrationForm(),
          const Expanded(
            child: Image(image: AssetImage('assets/images/png/1.png')),
          ),
        ],
      ),
    );
  }
}
