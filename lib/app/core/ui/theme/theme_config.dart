// lib/app/core/ui/theme/theme_config.dart
import 'package:flutter/material.dart';
import 'package:task_manager/app/core/ui/styles/colors_app.dart';

class ThemeConfig {
  ThemeConfig._();

  static ColorsApp get _colors => ColorsApp.i;

  // TEMA CLARO
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    scaffoldBackgroundColor: _colors.white,

    colorScheme: ColorScheme.light(
      primary: _colors.primaryBlue,
      secondary: _colors.darkBlue,
      background: _colors.white,
      surface: _colors.white,
      error: _colors.error,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: _colors.primaryBlue,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: _colors.white),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _colors.white,
      ),
    ),

    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: _colors.black,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: _colors.gray,
      ),
    ),


    cardTheme: CardThemeData(
      color: _colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: _colors.primaryBlue,
      selectionColor: _colors.primaryBlue.withOpacity(0.3),
    ),
  );

  // TEMA ESCURO
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    
    scaffoldBackgroundColor: const Color(0xFF121212),

    colorScheme: ColorScheme.dark(
      primary: _colors.primaryBlue,
      secondary: _colors.darkBlue,
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
      error: _colors.error,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.white70,
      ),
    ),


    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: _colors.primaryBlue,
      selectionColor: _colors.primaryBlue.withOpacity(0.3),
    ),
  );


  static ThemeData get theme => lightTheme;
}

/*
import 'package:flutter/material.dart';
import 'package:task_manager/app/core/ui/styles/colors_app.dart';

class ThemeConfig {
  ThemeConfig._();

  static ColorsApp get _colorsApp => ColorsApp.i;

  static final theme = ThemeData(
    scaffoldBackgroundColor: _colorsApp.white,
    textSelectionTheme: TextSelectionThemeData(cursorColor: ColorsApp.i.black),
    cardTheme: CardThemeData(color: Colors.transparent, elevation: 0),
  );
}
*/