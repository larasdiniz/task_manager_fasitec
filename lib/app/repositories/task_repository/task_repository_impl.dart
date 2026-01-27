
import 'dart:convert';
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';
import 'package:task_manager/fake_task_api.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FakeTasksApi api;

  TaskRepositoryImpl(this.api);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final response = await api.getAllTasks();
    final List<dynamic> decodeList = jsonDecode(response);
    return decodeList.map((json) => TaskModel.fromJson(json)).toList();
  }

  @override
  Future<TaskModel> updateTask({
    required int id,
    String? titulo,
    String? descricao,
  }) async {
    try {
      final response = await api.updateTask(
        id: id,
        titulo: titulo,
        descricao: descricao,
      );
      
      final Map<String, dynamic> json = jsonDecode(response);
      
      if (json.containsKey('error')) {
        throw Exception(json['error']);
      }
      
      return TaskModel.fromJson(json);
    } catch (e) {
      throw Exception('Erro ao atualizar tarefa: $e');
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      final response = await api.deleteTask(id);
      final Map<String, dynamic> json = jsonDecode(response);
      
      // Verifica se há erro na resposta
      if (json.containsKey('error')) {
        throw Exception(json['error']);
      }
    } catch (e) {
      throw Exception('Erro ao excluir tarefa: $e');
    }
  }
}

/*
import 'dart:convert';

import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';
import 'package:task_manager/fake_task_api.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FakeTasksApi api;

  TaskRepositoryImpl(this.api);

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final response = await api.getAllTasks();

    final List<dynamic> decodeList = jsonDecode(response);

    return decodeList.map((json) => TaskModel.fromJson(json)).toList();
  }
}
*/