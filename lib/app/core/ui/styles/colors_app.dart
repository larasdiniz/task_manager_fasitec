// lib/app/core/ui/styles/colors_app.dart
import 'package:flutter/material.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart';

class ColorsApp {
  static ColorsApp? _instance;
  ColorsApp._();

  static ColorsApp get i {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  // Cores base
  Color get white => const Color(0xFFFFFFFF);
  Color get black => const Color(0xFF1D1B20);
  Color get gray => const Color(0xFF49454F);
  Color get primaryBlue => const Color(0xFF2563EB);
  Color get darkBlue => const Color(0xFF1E40AF);
  Color get lightBlue => const Color(0xFFDBEAFE);
  Color get success => const Color(0xFF2E7D32);
  Color get warning => const Color(0xFFF57C00);
  Color get error => Colors.red;
  Color get darkBlueGradient => const Color(0xFF1E3A8A);
  
  // Cores para tema escuro
  Color get darkBackground => const Color(0xFF121212);
  Color get darkSurface => const Color(0xFF1E1E1E);
  Color get darkSurfaceVariant => const Color(0xFF2D2D2D);
  Color get darkGray => const Color(0xFF333333);
  Color get darkText => Colors.white;
  Color get darkTextSecondary => Colors.white70;
  Color get darkDivider => const Color(0xFF333333);
  
  // Cores para tema claro
  Color get lightBackground => white;
  Color get lightSurface => white;
  Color get lightSurfaceVariant => const Color(0xFFF5F5F5);
  Color get lightGray => const Color(0xFF818181);
  Color get lightText => black;
  Color get lightTextSecondary => gray;
  Color get lightDivider => const Color(0xFF818181);
  Color get cardBorderDark => const Color(0xFF424242);
  Color get cardBorderLight => const Color(0xFFE0E0E0); 
  Color get textSecondaryDark => Colors.white54; 
  Color get textSecondaryLight => const Color(0xFF757575); 
  Color get cardBackgroundDark => const Color(0xFF1E1E1E);
  Color get cardBackgroundLight => const Color(0xFFFAFAFA); 

  // Método para cores de status
  Color getTaskStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.finalizado:
        return primaryBlue;
      case TaskStatus.emProgresso:
        return success;
      case TaskStatus.emAberto:
        return warning;
    }
  }
}

extension ColorsAppExtension on BuildContext {
  ColorsApp get colors => ColorsApp.i;
}