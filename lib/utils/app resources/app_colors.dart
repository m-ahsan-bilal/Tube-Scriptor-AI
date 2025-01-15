import 'package:flutter/material.dart';

class AppColors {
  Color transparent = const Color(0x0000ffff);
  Color yellow = const Color(0xFFFFC107);
  Color white = const Color(0xFFffffff);
  Color black = const Color(0xff000000);
  Color red = const Color.fromRGBO(255, 0, 0, 1);
  Color green = const Color(0xff28A745);
  Color purpleColor = const Color(0xFF888AC8);
  Color activeOfferAppleGreen = const Color(0xffDAEF86);
  Color appleGreenexpOffer = const Color(0xffCCF0BF);
  Color darkGrey = const Color(0xFF3D4A59);
  Color lightGrey = const Color(0xFFF2F2F2);
  Color shadowColor = const Color(0xffCCCCCC);
  Color mistyWhite = const Color(0xffF7F8FC);
  Color tealDark = const Color(0xFF0F2D52);
  Color tealLight = const Color(0xff0D709D);
  Color primaryColor = const Color(0xFFC9450C);
  Color secondaryColor = const Color(0xff060A57);
  Color lightBlack = const Color(0xFF242424);
  Color textMediumGrey = const Color(0xff5F5F5F);
  Color textLightGrey = const Color(0xFF999999);
  Color blueGrey = const Color(0xff748A9D);

  Color themePink = const Color(0xffDEC7BD);
  Color softYellow = const Color(0xffFDE68A);
  Color palePink = const Color(0xffFBCFE7);
  Color mintGreen = const Color(0xffA7D6C4);
  Color lavender = const Color(0xffD3BCE7);
  Color softWhite = const Color(0xffFFF7E8);
  Color softlime = const Color(0xffFFF9CE);
  Color softPink = const Color(0xffFEC8CD);

// gradients
  Gradient gradient1 = LinearGradient(
    colors: [
      Colors.red.shade700,
      Colors.pinkAccent.shade100,
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomRight,
  );

  Gradient gradient2 = LinearGradient(colors: [
    Colors.deepPurple,
    Colors.lightBlueAccent,
  ], begin: Alignment.topCenter, end: Alignment.bottomLeft);

  Gradient appGradient3 = const LinearGradient(
    colors: [Color(0xffFBCFE7), Color(0xffA7D6C4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.1, 0.7],
  );
  Color greyBlack = const Color(0xff343A40);

  Color lightYellowColor = const Color(0xffECEDDD);
  Color sideIconColor = const Color(0xff8598A0);
  Color lightSliver = const Color(0xff7C7875);
  Color lightPurple = const Color(0xff1A192F);

  /// old
  Color offWhite = const Color(0xffF3F3F3);
  Color blackText = const Color(0xff111010);
  Color greyText = const Color(0xff5F5F5F);
  Color skyBlue = const Color(0xff1387FC);
  Color backgroundColor = const Color(0xffF7F8FA);
  Color pinkRed = const Color(0xffFB1463);
  Color greenButton = const Color(0xff00BF78);
  Color lightGreyColor = const Color(0xffD6D6D6);
  Color lightGreyColor2 = const Color(0xff8598A0);
  Color lightTheme = const Color(0xffFFF9F9);
  Color orangeColor = const Color(0xffE59A2C);
  Color grey = const Color(0xffABABAB);
  Color infoTextColor = const Color(0xffA9B6C9);
  Color videoBorderColor = const Color(0xff707070);
  Color borderColor = const Color(0xffDFDFDF);
  Color hintIconColor = const Color(0xffB2BAC1);
  Color hintTextColor = const Color(0xff979797);
}
