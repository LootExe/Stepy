import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager {
  static final _fontFamiliy =
      GoogleFonts.montserrat(fontWeight: FontWeight.w300).fontFamily;

  static ThemeData get lightTheme {
    final theme = FlexColorScheme.light(
      scheme: FlexScheme.blue,
      fontFamily: _fontFamiliy,
      useMaterial3: true,
    ).toTheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
    );
  }

  static ThemeData get darkTheme {
    final theme = FlexColorScheme.dark(
      colorScheme: const ColorScheme.dark(
        secondary: Colors.greenAccent,
        primary: Colors.white,
        background: Color(0xFF1B1B1B),
      ),
      fontFamily: _fontFamiliy,
      useMaterial3: true,
    ).toTheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        foregroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
