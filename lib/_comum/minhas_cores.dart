import 'package:flutter/material.dart';

class MinhasCores {
  static const MaterialColor azulEscuro =
      MaterialColor(_azulescuroPrimaryValue, <int, Color>{
        50: Color(0xFFE2EDF2),
        100: Color(0xFFB6D3DE),
        200: Color(0xFF85B6C9),
        300: Color(0xFF5499B3),
        400: Color(0xFF2F83A2),
        500: Color(_azulescuroPrimaryValue),
        600: Color(0xFF09658A),
        700: Color(0xFF075A5A7F),
        800: Color(0xFF055075),
        900: Color(0xFF033E63),
      });
  static const int _azulescuroPrimaryValue = 0xff0A6D92;

  static const MaterialColor azulEscuroAccent =
      MaterialColor(_azulescuroccentValue, <int, Color>{
        100: Color(0xFFFFFFFF),
        200: Color(_azulescuroccentValue),
        400: Color(0xFFB7D9FF),
        700: Color(0xFF9DCCFF),
      });
  static const int _azulescuroccentValue = 0xFF00ADFA;

  static const MaterialColor azulTopoGradiente =
      MaterialColor(_azultopogradientePrimaryValue, <int, Color>{
        50: Color(0xFFE0F5FE),
        100: Color(0xFFB3E6FE),
        200: Color(0xFF80D6FD),
        300: Color(0xFF4DC6FC),
        400: Color(0xFF42A5F5),
        500: Color(_azultopogradientePrimaryValue),
        600: Color(0xFF00A6F9),
        700: Color(0xFF009CF9),
        800: Color(0xFF0093F8),
        900: Color(0xFF0083F6),
      });
  static const int _azultopogradientePrimaryValue = 0xFF00ADFA;

  static const MaterialColor azulTopoGradienteAccent =
      MaterialColor(_azultopogradienteAccentValue, <int, Color>{
        100: Color(0xFFFFFFFF),
        200: Color(_azultopogradienteAccentValue),
        400: Color(0xFFB7D9FF),
        700: Color(0xFF9DCCFF),
      });
  static const int _azultopogradienteAccentValue = 0xFF00ADFA;

  static const MaterialColor azulBaixoGradiente =
      MaterialColor(_azulbaixogradienteValue, <int, Color>{
        50: Color(0xFFF7FEFF),
        100: Color(0xFFECFDFF),
        200: Color(0xFFDFFCFF),
        300: Color(0xFFD2FBFF),
        400: Color(0xFFC9FAFF),
        500: Color(_azulbaixogradienteValue),
        600: Color(0xFFB9F8FF),
        700: Color(0xFFB1F7FF),
        800: Color(0xFFA9F6FF),
        900: Color(0xFF9BF5FF),
      });
  static const int _azulbaixogradienteValue = 0xffBFF9FF;

  static const MaterialColor azulBaixoGradienteAccent =
      MaterialColor(_azultopogradienteAccentValue, <int, Color>{
        100: Color(0xFFFFFFFF),
        200: Color(_azulbaixogradienteAccent),
        400: Color(0xFFFFFFFF),
        700: Color(0xFFFFFFFF),
      });
  static const int _azulbaixogradienteAccent = 0xFFFFFFFF;
}
