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
