import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'values.dart';

class AppThemes {
  static ThemeData lightTheme = _buildTheme(
    ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.seedColor,
        // primary: AppColors.primaryColor,
        onPrimary: AppColors.backgroundColorLight,
        secondary: AppColors.secondaryColor,
        surface: AppColors.backgroundColorLight,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    ),
  );

  static ThemeData darkTheme = _buildTheme(
    ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.seedColor,
        // primary: AppColors.primaryColor,
        onPrimary: AppColors.backgroundColorLight,
        secondary: AppColors.secondaryColor,
        surface: AppColors.backgroundColorDark,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
  );

  static final RoundedRectangleBorder _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
  );

  static InputDecorationTheme _buildInputDecorationTheme(ThemeData baseTheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: baseTheme.colorScheme.surface,
        border: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
          borderSide: BorderSide(color: baseTheme.colorScheme.onSurface, width: .5),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
          borderSide: BorderSide(color: baseTheme.colorScheme.onSurface, width: .5),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary, width: .5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
          borderSide: BorderSide(color: baseTheme.colorScheme.primary, width: .5),
        ),
        errorBorder: OutlineInputBorder(
          gapPadding: 0.0,
          borderRadius: BorderRadius.circular(DefaultValues.radius / 2),
          borderSide: BorderSide(color: baseTheme.colorScheme.error, width: .5),
        ),
      );

  static ThemeData _buildTheme(ThemeData baseTheme) {
    final inputDecorationTheme = _buildInputDecorationTheme(baseTheme);
    return baseTheme.copyWith(
      textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme),
      appBarTheme: const AppBarTheme(centerTitle: true),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: baseTheme.colorScheme.primary,
        unselectedItemColor: baseTheme.colorScheme.onSurface,
        showUnselectedLabels: true,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(shape: _shape),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(shape: _shape),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(shape: _shape),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(shape: _shape),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: inputDecorationTheme,
      ),
      inputDecorationTheme: inputDecorationTheme,
    );
  }
}
