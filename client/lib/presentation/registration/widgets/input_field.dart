import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  const InputField({this.text, this.isPassword = false});
  final String text;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.yellow,
          hintColor: Colors.white,
          fontFamily: 'Montserrat',
        ),
        child: TextFormField(
          obscureText: isPassword,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            labelText: text,
            labelStyle: const TextStyle(fontWeight: FontWeight.w200),
          ),
          validator: (value) {
            if (value.isEmpty && text == 'Подтвердите пароль') {
              return text;
            }
            if (value.isEmpty) {
              final String lowerText = text.toLowerCase();
              return 'Введитe $lowerText';
            }
            return null;
          },
        ),
      ),
    );
  }
}
