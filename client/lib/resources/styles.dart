import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/cupertino.dart';

const _defaultTextColor = ColorRes.white;
const _defaultFontFamily = 'Montserrat';

const List<Color> _gradientColors = [ColorRes.mainGreen, ColorRes.lightGreen];
const List<double> _gradientStops = [0.0, 1.0];

class Styles {
  static const linearGradient = LinearGradient(
    colors: _gradientColors,
    stops: _gradientStops,
    begin: Alignment(0.4, 0.6),
    end: Alignment(2.2, 0.2),
  );

  static const subhead = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
  );

  static const body1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
  );

  static const bodyWhiteBold = TextStyle(
    color: ColorRes.primaryWhiteColor,
    fontFamily: _defaultFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 12,
  );

  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
  );

  static const bodyBlack = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    color: ColorRes.mainBlack,
  );

  static const bodyBlackBold = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    color: ColorRes.mainBlack,
  );

  static const bodyBlackSemibold = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorRes.mainBlack,
  );

  static const caption = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: _defaultTextColor,
  );

  static const overline = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: _defaultTextColor,
  );

  static const error = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.6,
    color: ColorRes.errorRed,
  );

  static const navBarTitle = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.primaryYellowColor,
    fontWeight: FontWeight.w700,
    fontSize: 16,
  );

  static const navBarSubtitle = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.levelColor,
    fontWeight: FontWeight.w200,
    fontSize: 16,
  );

  static const tableRowTitle = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
  );

  static const tableRowValue = Styles.tableRowTitle;

  static const tableRowDetails = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorRes.primaryGreyColor,
    fontFamily: _defaultFontFamily,
  );

  static const tableHeaderTitleBlue = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.darkBlue,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const tableHeaderTitleBlack = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.mainBlack,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const tableHeaderValueBlue = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.newGameBoardPrimaryTextColor,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  
   static const tableHeaderValueBlack = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.mainBlack,
    fontSize: 15,
    fontWeight: FontWeight.w700,
  );
  

  static TextStyle bottomNavBarButtonTitle({bool isSelected = false}) {
    return TextStyle(
      color: isSelected ? ColorRes.mainGreen : ColorRes.primaryGreyColor,
      fontSize: 10,
      fontFamily: _defaultFontFamily,
      fontWeight: FontWeight.normal,
      fontStyle: FontStyle.normal,
    );
  }
}
