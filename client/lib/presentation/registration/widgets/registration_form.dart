import 'package:cash_flow/presentation/registration/widgets/registration_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'input_field.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => RegistrationFormState();
}

class RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: <Widget>[
            const InputField(text: 'Логин'),
            const InputField(
              text: 'Пароль',
              isPassword: true,
            ),
            const InputField(
              text: 'Подтвердите пароль',
              isPassword: true,
            ),
            const SizedBox(height: 20),
            RegistrationButton(onPressed: register),
          ],
        ),
      ),
    );
  }

  void register() {
    if (_formKey.currentState.validate()) {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: const Text('Success'), backgroundColor: Colors.green));
    }
  }
}
