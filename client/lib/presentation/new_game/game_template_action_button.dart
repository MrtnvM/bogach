import 'package:cash_flow/resources/colors.dart';
import 'package:cash_flow/resources/styles.dart';
import 'package:flutter/material.dart';

class GameTemplateActionButton extends StatelessWidget {
  const GameTemplateActionButton({
    Key? key,
    this.action,
    this.color,
    this.title,
  }) : super(key: key);

  final VoidCallback? action;
  final Color? color;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: action,
      child: Container(
        height: 34,
        width: screenWidth < 350 ? 100 : 130,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: ColorRes.grey.withAlpha(70)),
        ),
        child: Text(title!, style: Styles.bodyBlack.copyWith(fontSize: 12.5)),
      ),
    );
  }
}
