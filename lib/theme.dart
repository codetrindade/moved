
import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
    platform: TargetPlatform.android,
    fontFamily: 'Intelo',
    primaryColor: AppColors.colorGradientPrimary,
    primaryColorDark: AppColors.colorGradientSecondary,
    //buttonColor: AppColors.colorSecondary,
    //accentColor: Colors.grey,
    canvasColor: Colors.white,
    backgroundColor: Colors.white);

final LinearGradient appGradient = LinearGradient(colors: [
  AppColors.colorGradientPrimary,
  AppColors.colorGradientPrimary,
  AppColors.colorGradientSecondary
], begin: Alignment.topCenter, end: Alignment.bottomCenter);

class AppColors {
  static const colorGradientPrimary = Color(0xFF2A7EF6);
  static const colorGradientSecondary = Color(0xFF3BC0FF);

  static const colorWhite = Color(0xFFffffff);

  static const colorGrey = const Color(0xFFd2cfcf);

  static const colorPurpleLight = Color(0xFF924ce2);
  static const colorPurpleDark = Color(0xFF6b23ea);
  static const colorGreenLight = Color(0xFF00E787);
  static const colorBlueDarkOpacity = Color(0xEE4440c3);
  static const colorBlueLight = Color(0xFF5ea1fe);
  static const colorGreyDark = Color(0xFF787878);
  static const colorTextSecondary = Color(0xFF808080);
  static const colorBlackTransparent = Color(0xa0000000);
  static const colorGreyLight = Color(0xFFd2cfcf);
  static const colorTextGreyLight = Color(0xFFf8f8f8);
  static const colorGreen = Color(0xFF7AD06D);
  static const colorBlueDark = const Color(0xFF2A7EF6);
}

class AppSizes {
  static const fontExtraSmall = 14.0;
  static const fontSmall = 16.0;
  static const fontMedium = 18.0;
  static const fontBig = 20.0;
  static const fontExtraBig = 40.0;

  static const inputPadding = EdgeInsets.all(15.0);
  static const inputPaddingHorizontalDouble = 20.0;
  static const inputPaddingVerticalDouble = 15.0;
  static const inputRadiusDouble = 20.0;

  static const buttonHeight = 50.0;
  static var buttonCorner = BorderRadius.circular(25.0);
  static const buttonCornerDouble = 25.0;

  static var logoMarginTop = 0.07;
}

class AppFont {
  static const fontMontserrat = "Montserrat";
}

class AppRadius {
  static var bottomRadius = Radius.circular(30.0);
  static var containerRadius = Radius.circular(15.0);
  static var inputRadius = Radius.circular(5.0);
}

class AppTextStyle {

  static const textBlackMediumBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorBlackTransparent);

  static const textBlackBig = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontBig,
      color: AppColors.colorBlackTransparent);

  static const textBlackBigBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontBig,
      color: AppColors.colorBlackTransparent);

  static const textWhiteSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorWhite);

  static const textWhiteBigBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontBig,
      color: AppColors.colorWhite);

  static const textGreyExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorTextSecondary);

  static const textGreySmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorTextSecondary);

  static const textWhiteSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorWhite);

  static const textWhiteExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorWhite);

  static const textWhiteExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorWhite);

  static const textBoldWhiteMedium = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorWhite);

  static const textBlueLightExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorBlueLight);

  static var textBlueLightExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorBlueLight);

  static const textBlueLightSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorBlueLight);

  static const textBlueLightMedium = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorBlueLight);

  static const textBlueDarkSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorGreyDark);

  static const textBlueDarkExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorGreenLight);

  static const textBlueDarkSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorGreyDark);

  static const textBlueDarkMediumBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorGreyDark);

  static const textBlueDarkBigBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontBig,
      color: AppColors.colorGreenLight);

  static var textBlueDarkExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorGreyDark);

  static const textBlueLightSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorBlueLight);

  static const textBlueLightMediumBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontMedium,
      color: AppColors.colorBlueLight);

  static const textGreyExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorGreyDark);

  static const textGreySmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorGreyDark);

  static const textBlueBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorBlueDark);

  static const textGreyDarkSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorGreyDark);

  static const textGreyDarkBig = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontBig,
      color: AppColors.colorGreyDark);

  static const textGreyDarkExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorGreyDark);

  static const textPurpleDarkExtraSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorPurpleDark);

  static const textPurpleDarkSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorPurpleDark);

  static const textPurpleLightSmall = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.normal,
      fontSize: AppSizes.fontSmall,
      color: AppColors.colorPurpleLight);

  static const textGreenExtraSmallBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraSmall,
      color: AppColors.colorGreen);

  static const textGreenExtraBigBold = TextStyle(
      fontFamily: AppFont.fontMontserrat,
      fontWeight: FontWeight.bold,
      fontSize: AppSizes.fontExtraBig,
      color: AppColors.colorGreen);
}
