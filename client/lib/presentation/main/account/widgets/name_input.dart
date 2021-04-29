import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/strings.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class NameInput extends StatelessWidget {
  const NameInput({
    Key? key,
    required this.initialValue,
    required this.onChange,
  }) : super(key: key);

  final String? initialValue;
  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      style: Styles.bodyBlack,
      onChanged: (value) => onChange(value.trim()),
      cursorColor: ColorRes.mainGreen,
      decoration: InputDecoration(
        isDense: true,
        labelText: Strings.yourName,
        labelStyle: const TextStyle(
          color: ColorRes.mainGreen,
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorRes.mainGreen),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorRes.mainGreen.withAlpha(100)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorRes.mainGreen),
        ),
      ),
    );
  }
}
