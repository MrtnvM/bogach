import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/validators.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({
    required this.props,
  });

  final InputFieldProps props;

  @override
  State<StatefulWidget> createState() {
    return _InputFieldState();
  }
}

class _InputFieldState extends State<InputField> {
  final key = GlobalKey<FormFieldState>();
  String? value;
  String? validationResult;

  @override
  void initState() {
    super.initState();
    widget.props.focusNode?.addListener(() {
      key.currentState!.validate();
    });

    if (widget.props.autovalidateMode != AutovalidateMode.disabled &&
        widget.props.validatorRules != null &&
        widget.props.controller?.text.isNotEmpty == true) {
      validationResult = validate(value, widget.props.validatorRules!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      maxLines: 1,
      controller: widget.props.controller,
      focusNode: widget.props.focusNode,
      autovalidateMode: widget.props.autovalidateMode,
      decoration: InputDecoration(
        isDense: true,
        suffix: validationResult?.isNotEmpty == true
            ? const Icon(Icons.error, color: ColorRes.red, size: 14)
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 9),
        labelText: _hasValue() || _hasFocus()
            ? widget.props.hint?.toUpperCase()
            : null,
        labelStyle: _getLabelStyle(),
        hintText: !_hasValue() && !_hasFocus() ? widget.props.hint : null,
        hintStyle: Styles.body1,
        errorStyle: Styles.error,
        errorMaxLines: 3,
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ColorRes.gallery.withAlpha(128))),
        errorBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: ColorRes.red)),
      ),
      textInputAction: widget.props.textInputAction,
      validator: (value) {
        if (widget.props.focusNode?.hasFocus == true ||
            widget.props.validatorRules == null) {
          validationResult = null;
          return null;
        }

        validationResult = validate(value, widget.props.validatorRules!);
        return validationResult;
      },
      textAlign: widget.props.textAlign,
      onFieldSubmitted: (value) {
        widget.props.focusNode?.unfocus();

        if (widget.props.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.props.nextFocusNode);
        }

        widget.props.onSubmitted?.call(value);
      },
      style: Styles.body1,
      onChanged: (value) => setState(() => this.value = value),
      obscureText: widget.props.obscureText,
      inputFormatters: widget.props.inputFormatters,
      maxLength: widget.props.maxLength,
      buildCounter: (
        context, {
        currentLength = 0,
        maxLength,
        isFocused = false,
      }) =>
          null,
    );
  }

  TextStyle _getLabelStyle() {
    final hasValue = _hasValue();
    final hasError = validationResult?.isNotEmpty == true;
    final hasFocus = widget.props.focusNode?.hasFocus == true;

    if (hasError && hasValue && !hasFocus) {
      return Styles.caption.copyWith(color: ColorRes.red);
    } else {
      return Styles.caption.copyWith(color: ColorRes.gallery);
    }
  }

  bool _hasValue() =>
      widget.props.controller?.text.isNotEmpty == true ||
      value?.isNotEmpty == true;

  bool _hasFocus() => widget.props.focusNode?.hasFocus == true;
}
