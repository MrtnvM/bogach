import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class Condition extends StatelessWidget {
  const Condition(this.flowValue, this.cashValue, this.creditValue);

  final String flowValue;
  final String cashValue;
  final String creditValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 35,
        color: ColorRes.primaryWhiteColor,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ConditionContainer(flowValue, 'Поток'),
            VerticalDivider(),
            ConditionContainer(cashValue, 'Наличные'),
            VerticalDivider(),
            ConditionContainer(creditValue, 'Кредит'),
          ],
        ));
  }
}

class VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1,
        height: 30,
        color: ColorRes.newGameBoardConditionDividerColor);
  }
}

class ConditionContainer extends StatelessWidget {
  const ConditionContainer(this.value, this.textValue);

  final String value;
  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: ColorRes.newGameBoardPrimaryTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              textValue,
              style: TextStyle(
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
