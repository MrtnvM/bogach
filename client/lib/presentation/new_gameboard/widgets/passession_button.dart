import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class PassessionButton extends StatelessWidget {
  const PassessionButton(this.value, this.title);

  final String value;
  final String title;

  @override
  Widget build(BuildContext context) {
    int _count = 0;
    return GestureDetector(
      onTap: () {
        _count++;
        print(_count);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 1.0, spreadRadius: 1.0),
          ],
          color: Colors.white,
        ),
        alignment: Alignment.center,
        height: 62,
        constraints: const BoxConstraints(minWidth: 150),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              value,
              style: TextStyle(
                color: ColorRes.newGameBoardPrimaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }
}
