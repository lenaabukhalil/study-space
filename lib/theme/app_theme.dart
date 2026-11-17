import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color leaf = Colors.green.shade800;
  static final Color jasmine = Colors.amber.shade200;
  static final Color cream = Colors.orange.shade50;

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: leaf,
      primary: leaf,
      onPrimary: Colors.white,
      secondary: jasmine,
      onSecondary: Colors.brown.shade900,
      secondaryContainer: Colors.amber.shade100,
      onSecondaryContainer: Colors.brown.shade800,
      surface: Colors.white,
    );
    final base = ThemeData(colorScheme: scheme);

    return base.copyWith(
      scaffoldBackgroundColor: cream,
      textTheme: _textTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: Colors.grey.shade900,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade900,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 3,
        shadowColor: Colors.black.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: _inputTheme(scheme),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        selectedColor: jasmine,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: leaf,
        unselectedItemColor: Colors.grey.shade500,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static TextTheme _textTheme(TextTheme base) {
    final body = GoogleFonts.poppinsTextTheme(base);
    TextStyle? heading(TextStyle? style) {
      return GoogleFonts.playfairDisplay(
        textStyle: style,
        fontWeight: FontWeight.w700,
      );
    }

    return body.copyWith(
      displayLarge: heading(body.displayLarge),
      displayMedium: heading(body.displayMedium),
      displaySmall: heading(body.displaySmall),
      headlineLarge: heading(body.headlineLarge),
      headlineMedium: heading(body.headlineMedium),
      headlineSmall: heading(body.headlineSmall),
      titleLarge: heading(body.titleLarge),
    );
  }

  static InputDecorationTheme _inputTheme(ColorScheme scheme) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: border(Colors.grey.shade300),
      enabledBorder: border(Colors.grey.shade300),
      focusedBorder: border(scheme.primary, 2),
      errorBorder: border(Colors.red.shade300),
      focusedErrorBorder: border(Colors.red.shade700, 2),
    );
  }
}
