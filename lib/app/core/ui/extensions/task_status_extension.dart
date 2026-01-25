import 'package:task_manager/app/core/enums/task_status_enum.dart';

extension TaskStatusExtension on TaskStatus {
  String get label {
    switch (this) {
      case TaskStatus.emAberto:
        return 'Em Aberto';
      case TaskStatus.emProgresso:
        return 'Em Progresso';
      case TaskStatus.finalizado:
        return 'Finalizado';
    }
  }

  static TaskStatus fromString(String value) {
    switch (value) {
      case 'Em Aberto':
        return TaskStatus.emAberto;
      case 'Em Progresso':
        return TaskStatus.emProgresso;
      case 'Finalizado':
        return TaskStatus.finalizado;
      default:
        return TaskStatus.emAberto;
    }
  }
}
