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
    canvasColor: _colors.white,

    colorScheme: ColorScheme.light(
      primary: _colors.primaryBlue,
      secondary: _colors.darkBlue,
      background: _colors.white,
      surface: _colors.white,
      error: _colors.error,
      onPrimary: _colors.white,
      onSecondary: _colors.white,
      onBackground: _colors.black,
      onSurface: _colors.black,
      onError: _colors.white,
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
      margin: EdgeInsets.zero,
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
    
    scaffoldBackgroundColor: _colors.darkBackground, 
    canvasColor: _colors.darkBackground, 

    colorScheme: ColorScheme.dark(
      primary: _colors.primaryBlue, 
      secondary: _colors.darkBlue, 
      background: _colors.darkBackground, 
      surface: _colors.darkSurface, 
      error: _colors.error, 
      onPrimary: _colors.white, 
      onSecondary: _colors.white, 
      onBackground: _colors.white, 
      onSurface: _colors.white, 
      onError: _colors.white, 
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: _colors.darkSurface, 
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
        color: _colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: _colors.white.withOpacity(0.7),
      ),
    ),

    cardTheme: CardThemeData( 
      color: _colors.darkSurface, 
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.zero,
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: _colors.primaryBlue,
      selectionColor: _colors.primaryBlue.withOpacity(0.3),
    ),
  );

  static ThemeData getTheme(bool isDark) {
    return isDark ? darkTheme : lightTheme;
  }
}