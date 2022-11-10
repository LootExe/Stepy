import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager {
  static ThemeData get lightTheme {
    final theme = FlexColorScheme.light(
      scheme: FlexScheme.blue,
      fontFamily: GoogleFonts.rubik(fontWeight: FontWeight.w500).fontFamily,
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
        primary: Colors.white,
        background: Color(0xFF1B1B1B),
      ),
      fontFamily: GoogleFonts.rubik(fontWeight: FontWeight.w500).fontFamily,
      useMaterial3: true,
    ).toTheme;

    return theme.copyWith(
      appBarTheme: AppBarTheme(
        foregroundColor: theme.colorScheme.primary,
      ),
    );
  }
}
