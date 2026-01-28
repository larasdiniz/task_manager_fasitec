// lib/app/core/ui/theme/theme_manager.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDark = false;

  ThemeManager() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _isDark;

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        if (savedTheme == 'dark') {
          _themeMode = ThemeMode.dark;
          _isDark = true;
        } else if (savedTheme == 'light') {
          _themeMode = ThemeMode.light;
          _isDark = false;
        } else {
          _themeMode = ThemeMode.system;
          _isDark = Theme.of(navigatorKey.currentContext!).brightness == Brightness.dark;
        }
      } else {
        _themeMode = ThemeMode.system;
        _isDark = Theme.of(navigatorKey.currentContext!).brightness == Brightness.dark;
      }
      notifyListeners();
    } catch (e) {
      _themeMode = ThemeMode.system;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _isDark = mode == ThemeMode.dark;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode == ThemeMode.dark ? 'dark' : mode == ThemeMode.light ? 'light' : 'system');
    } catch (e) {
      // Ignore error
    }
    
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}

// Chave global para acessar o contexto
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();