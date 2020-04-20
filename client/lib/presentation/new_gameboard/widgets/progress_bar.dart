import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar(this.value1, this.value2);

  final String value1;
  final String value2;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, top: 14.0, right: 16),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
        color: ColorRes.primaryWhiteColor,
      ),
      child: Column(
        children: [
          TextContainer(value1),
          Container(
            height: 20,
            child: Stack(
              children: [
                const ProgressLine(30),
                Container(
                  //height: 2,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    border: Border.all(color: ColorRes.progressBarBorderColor),
                  ),
                ),
                ProgressBarText(value2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TextContainer extends StatelessWidget {
  const TextContainer(this.value);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Text(
            'Капитал: ',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: ColorRes.primaryBackgroundColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: ColorRes.newGameBoardPrimaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine(this.progress);
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: progress,
        //height: 19.0,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: ColorRes.primaryYellowColor,
        ));
  }
}

class ProgressBarText extends StatelessWidget {
  const ProgressBarText(this.value);
  final String value;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        value,
        style: const TextStyle(
          fontSize: 12,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
