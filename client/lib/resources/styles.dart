import 'package:cash_flow/resources/colors.dart';
import 'package:flutter/cupertino.dart';

const _defaultTextColor = ColorRes.white;
const _defaultFontFamily = 'Montserrat';

const List<Color> _gradientColors = [ColorRes.mainGreen, ColorRes.lightGreen];
const List<double> _gradientStops = [0.0, 1.0];

// ignore: avoid_classes_with_only_static_members
class Styles {
  static const linearGradient = LinearGradient(
    colors: _gradientColors,
    stops: _gradientStops,
    begin: Alignment(0.4, 0.6),
    end: Alignment(2.2, 0.2),
  );

  static const head = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
  );

  static const subhead = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
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

  static const bodyWhiteBold14 = TextStyle(
    color: ColorRes.primaryWhiteColor,
    fontFamily: _defaultFontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static const body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
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

  static const bodyBold = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
    color: _defaultTextColor,
  );

  static const bodyBlackSemibold = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: ColorRes.mainBlack,
  );

  static const bodySemibold = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    color: _defaultTextColor,
  );

  static const caption = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 12,
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
  );

  static const overline = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    color: _defaultTextColor,
    fontFamily: _defaultFontFamily,
  );

  static const error = TextStyle(
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.6,
    color: ColorRes.red,
    fontFamily: _defaultFontFamily,
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

  static const tableDialogSubtitleBlack = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.mainBlack,
    fontSize: 14,
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

  static const onboardingTitle = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.white,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static final onboardingSubtitle = TextStyle(
    fontFamily: _defaultFontFamily,
    color: ColorRes.white.withAlpha(220),
    fontSize: 18,
    fontWeight: FontWeight.w400,
  );

  static final badgeContent = Styles.bodyBlack.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
  );

  static const accountCommon = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 19,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: ColorRes.black,
  );

  static const friendName = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 15,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    color: ColorRes.black,
  );

  static const dialogTitle = TextStyle(
    fontFamily: _defaultFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ColorRes.black,
  );

  static const defaultColorButtonText = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16,
    color: ColorRes.mainBlack,
    fontWeight: FontWeight.w500,
  );

  static const selectedTab = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
    color: ColorRes.mainGreen,
    fontFamily: _defaultFontFamily,
  );

  static final unselectedTab = selectedTab.copyWith(
    fontSize: 11,
    color: ColorRes.greyCog,
  );
}
