import 'package:flutter/material.dart';

class CustomColors {
  static const bianco = Color(0xFFFFFFFF);
  static const biancoCard = Color(0xFFEEEEEE);
  static const azzurro = Color(0xFF6CD6D3);
  static const revee = Color(0xFFE20074);
  static const reveePallido = Color(0xFFE962AA);
  static const rosa = Color(0xFFDB3D8C);
  static const rosso = Color(0xffFF1744);
  static const giallo = Color(0xFFDDDD3C);
  static const viola = Color(0xFF9C1AB2);
  static const violaScuro = Color(0xFF241D2D);
  static const rosaSemitrasparente = Color(0xAAE962AA);
  static const neroRevee = Color(0xFF161329);
  static const grigioChiaro = Color(0xFF888888);
  static const grigio = Color(0xFF333333);
  static const grigioScuro = Color(0xFF2A2A2A);
  static const blueTiffany = Color(0xFF0ABAB5);
  static const blueTiffanyPallido = Color(0x8F0ABAB5);
}

final reveeTheme = ThemeData(
//  primarySwatch: MaterialColor(0xffdf1275, {}),
  brightness: Brightness.light,
  primaryColor: CustomColors.revee,
  backgroundColor: CustomColors.biancoCard,

  //checkbox
  toggleableActiveColor: CustomColors.revee,

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    splashColor: CustomColors.reveePallido,
  ),

  //colori textbox
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: CustomColors.rosa,
    selectionColor: CustomColors.revee.withOpacity(0.2),
    selectionHandleColor: CustomColors.rosa,
  ),

  indicatorColor: CustomColors.rosa,

  //separatori trasparenti
  dividerColor: Colors.transparent,

  //colore degli InkWell
  splashColor: CustomColors.revee.withAlpha(150),

  secondaryHeaderColor: CustomColors.violaScuro,

  

  buttonTheme: ButtonThemeData(
    textTheme: ButtonTextTheme.primary,
    buttonColor: CustomColors.revee,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
      color: CustomColors.violaScuro,
      fontWeight: FontWeight.bold,
      fontSize: 22,
    ),
    headline2: TextStyle(
      color: CustomColors.violaScuro,
      fontWeight: FontWeight.bold,
      fontSize: 21,
    ),
    headline3: TextStyle(
      color: CustomColors.violaScuro,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    headline4: TextStyle(
      color: CustomColors.violaScuro,
      fontWeight: FontWeight.normal,
      fontSize: 18,
    ),
    headline5: TextStyle(
      color: CustomColors.violaScuro,
      fontWeight: FontWeight.normal,
      fontSize: 16,
    ),
    headline6: TextStyle(
      color: CustomColors.violaScuro,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    ),
    bodyText2: TextStyle(color: Color(0xff333333)),
    bodyText1: TextStyle(color: Color(0xff202020)),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    prefixStyle: TextStyle(color: CustomColors.revee),
    suffixStyle: TextStyle(color: CustomColors.revee),
    border: OutlineInputBorder(
      // ignore: avoid_redundant_argument_values
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
    fillColor: Colors.transparent,
    filled: true,
  ),
  colorScheme: const ColorScheme(
    primary: CustomColors.revee,
    secondary: CustomColors.viola,
    surface: CustomColors.biancoCard,
    background: CustomColors.bianco,
    error: CustomColors.rosso,
    onPrimary: CustomColors.bianco,
    onSecondary: CustomColors.bianco,
    onSurface: CustomColors.violaScuro,
    onBackground: CustomColors.bianco,
    onError: CustomColors.neroRevee,
    brightness: Brightness.light,
  ).copyWith(secondary: CustomColors.revee),
);
