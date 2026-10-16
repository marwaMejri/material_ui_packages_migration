import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color seed = Color(0xFF00695C);
  static const Color codeBlock = Color(0xFFFFF3C4);

  static ThemeData light() {
    final ColorScheme colors = ColorScheme.fromSeed(seedColor: seed);
    return ThemeData(
      colorScheme: colors,
      textTheme: GoogleFonts.merriweatherTextTheme(),
      appBarTheme: AppBarThemeData(backgroundColor: colors.primaryContainer),
      cardTheme: const CardThemeData(color: codeBlock),
    );
  }
}