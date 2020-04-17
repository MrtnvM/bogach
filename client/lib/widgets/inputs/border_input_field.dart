import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:cash_flow/utils/validators.dart';
import 'package:cash_flow/widgets/inputs/input_field_props.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BorderInputField extends StatefulWidget {
  const BorderInputField({
    @required this.props,
  }) : assert(props != null);

  final InputFieldProps props;

  @override
  State<StatefulWidget> createState() {
    return _BorderInputFieldState();
  }
}

class _BorderInputFieldState extends State<BorderInputField> {
  final _key = GlobalKey<FormFieldState>();
  String _validationResult;

  @override
  void initState() {
    super.initState();
    widget.props.focusNode?.addListener(() {
      _key.currentState?.validate();
    });

    if (widget.props.autoValidate == true &&
        widget.props.validatorRules != null &&
        widget.props.controller?.text?.isNotEmpty == true) {
      _validationResult = validate(
        widget.props.controller.text,
        widget.props.validatorRules,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasHint = widget.props.hint?.isNotEmpty == true;
    final hasLabel = widget.props.label?.isNotEmpty == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (hasHint && hasLabel)
          Row(
            children: <Widget>[
              Text(
                widget.props.label.toUpperCase(),
                style: _validationResult?.isNotEmpty == true
                    ? Styles.caption.copyWith(color: ColorRes.errorRed)
                    : Styles.caption.copyWith(color: ColorRes.grey),
              ),
              const Spacer(),
              if (_validationResult?.isNotEmpty == true)
                Text(
                  _validationResult,
                  style: Styles.overline.copyWith(color: ColorRes.errorRed),
                ),
            ],
          ),
        if (hasHint && hasLabel) const SizedBox(height: 6),
        TextFormField(
          key: _key,
          minLines: widget.props.lines,
          maxLines: widget.props.maxLines,
          controller: widget.props.controller,
          focusNode: widget.props.focusNode,
          decoration: InputDecoration(
            isDense: true,
            suffix: _validationResult?.isNotEmpty == true
                ? Icon(Icons.error, color: ColorRes.errorRed, size: 14)
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            hintText: widget.props.hint,
            hintStyle: Styles.body1
                .copyWith(fontStyle: FontStyle.italic, color: ColorRes.grey),
            enabledBorder: OutlineInputBorder(
              borderSide: _validationResult?.isNotEmpty == true
                  ? const BorderSide(color: ColorRes.errorRed)
                  : const BorderSide(color: ColorRes.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorRes.blue),
              borderRadius: BorderRadius.circular(4),
            ),
            filled: true,
            fillColor: ColorRes.white,
          ),
          textInputAction: widget.props.nextFocusNode == null
              ? TextInputAction.done
              : TextInputAction.next,
          textCapitalization: widget.props.textCapitalization,
          validator: (String value) {
            if (widget.props.focusNode?.hasFocus == true ||
                widget.props.validatorRules == null) {
              _validationResult = null;
              return null;
            }

            _validationResult = validate(value, widget.props.validatorRules);
            return null;
          },
          textAlign: widget.props.textAlign,
          onFieldSubmitted: (value) {
            widget.props.focusNode?.unfocus();

            if (widget.props.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.props.nextFocusNode);
            }

            widget.props.onSubmitted?.call(value);
          },
          style: Styles.body1.copyWith(color: ColorRes.black),
          obscureText: widget.props.obscureText,
          keyboardType: widget.props.keyboardType,
          autovalidate: widget.props.autoValidate,
          inputFormatters: widget.props.inputFormatters,
        ),
      ],
    );
  }
}
