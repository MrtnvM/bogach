import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/material.dart';

class FooterButton extends StatelessWidget {
  const FooterButton({this.image, this.text});

  final String image;
  final String text;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        color: ColorRes.primaryBackgroundColor,
        height: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage(image),
            ),
            Text(
              text,
              style: TextStyle(
                color: ColorRes.primaryWhiteColor,
                fontFamily: 'Montserrat',
                fontSize: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
