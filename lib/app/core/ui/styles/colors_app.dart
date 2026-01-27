import 'package:flutter/material.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart';

class ColorsApp {
  static ColorsApp? _instance;
  ColorsApp._();

  static ColorsApp get i {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get white => const Color(0xFFFFFFFF);
  Color get black => const Color(0xFF1D1B20);
  Color get gray => const Color(0xFF49454F);
  Color get primaryBlue => const Color(0xFF2563EB);
  Color get darkBlue => const Color(0xFF1E40AF);
  Color get lightBlue => const Color(0xFFDBEAFE);
  Color get success => const Color(0xFF2E7D32);
  Color get warning => const Color(0xFFF57C00);
  Color get error => Colors.red;


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



/*
import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get i {
    _instance ??= ColorsApp._();
    return _instance!;
  }

  Color get white => const Color(0XFFFFFFFF);
  Color get black => const Color(0XFF1D1B20);
  Color get gray => const Color(0XFF49454F);
}

extension ColorsAppExtension on BuildContext {
  ColorsApp get colors => ColorsApp.i;
}
*/