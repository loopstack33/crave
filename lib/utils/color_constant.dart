import 'package:flutter/material.dart';

class AppColors {
  /// BASIC COLORS ////
  static const primaryColorLight = Color(0xFF52C7E0);
  static const primaryColorDark = Color(0xFF1A5C9C);
  static const bbColor = Color(0xFF676060);
  static const greyShade = Color(0xFF7A7A7A);
  static const greyLightShade = Color(0xFFC4C4C4);
  static const white = Colors.white;
  static const black = Colors.black;
  static const redcolor = Color(0xffC70606);
  static const textcolor = Color(0xff2A2E32);
  static const shahdowColor = Color(0xFFAEAEAE);

  static const grey1 = Color(0xffE5E5E5);

//// EXTRA COLORS ////
  static const containerborder = Color(0xFFE4DFDF);
  static const textColor = Color(0xFF636363);
  static const textColor2= Color(0xFFBDBDBD);
  static const blueShade = Color(0xFF1C609E);
  static const purpleShade = Color(0xFFBD80E1);
  static const orangeShade = Color(0xFFEB7A12);

//// GRADIENT SHADES ////
  static const primaryDarkGradient = LinearGradient(
    colors: [
      Color(0xFF52C7E0),
      Color(0xFF1A5C9C),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

//// GRADIENT SHADES ////
  static const primaryreadGradient = LinearGradient(
    colors: [
      Color(0xFFFF878C),
      Color(0xFFE01F27),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
