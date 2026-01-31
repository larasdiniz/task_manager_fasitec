import 'dart:convert';

import 'package:task_manager/app/core/enums/task_status_enum.dart';
import 'package:task_manager/app/core/ui/extensions/task_status_extension.dart';

class TaskModel {
  final int id;
  final String titulo;
  final String descricao;
  final TaskStatus status;

  TaskModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      titulo: json['titulo'],
      descricao: json['descricao'],
      status: TaskStatusExtension.fromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'status': status.label,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}