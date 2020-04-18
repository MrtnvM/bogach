import 'package:cash_flow/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFieldProps {
  const InputFieldProps({
    this.hint,
    this.label,
    this.onSubmitted,
    this.validatorRules,
    this.controller,
    this.textAlign = TextAlign.start,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType = TextInputType.text,
    this.autoValidate = false,
    this.maxLines = 1,
    this.lines = 1,
    this.maxLength = 64,
    this.inputFormatters,
    this.onChanged,
    this.initialValue,
  });

  final String hint;
  final String label;
  final ValueChanged<String> onSubmitted;
  final List<FormatResult> validatorRules;
  final TextEditingController controller;
  final TextAlign textAlign;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction textInputAction;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final TextInputType keyboardType;
  final bool autoValidate;
  final int maxLines;
  final int lines;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onChanged;
  final String initialValue;
}
