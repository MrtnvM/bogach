import 'package:cash_flow/presentation/new_gameboard/widgets/passession_button.dart';
import 'package:flutter/material.dart';

class PassessionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Expanded(child: PassessionButton('5 000₽', 'Доходы')),
            SizedBox(width: 12),
            Expanded(child: PassessionButton('5 000₽', 'Расходы'))
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Expanded(child: PassessionButton('2 000₽', 'Активы')),
            SizedBox(width: 12),
            Expanded(child: PassessionButton('2 000 000₽', 'Пассивы'))
          ],
        ),
      ],
    );
  }
}
