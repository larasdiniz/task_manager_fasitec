// lib/app/repositories/task_repository/task_repository_impl.dart
import 'dart:convert';
import 'package:task_manager/app/core/enums/task_status_enum.dart';
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
  Future<TaskModel> createTask({
    required String titulo,
    required String descricao,
  }) async {
    try {
      final response = await api.addTask(
        titulo: titulo,
        descricao: descricao,
        status: TaskStatus.emAberto, // Nova tarefa sempre começa como "Em Aberto"
      );
      
      final Map<String, dynamic> json = jsonDecode(response);
      
      if (json.containsKey('error')) {
        throw Exception(json['error']);
      }
      
      return TaskModel.fromJson(json);
    } catch (e) {
      throw Exception('Erro ao criar tarefa: $e');
    }
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
      
      if (json.containsKey('error')) {
        throw Exception(json['error']);
      }
    } catch (e) {
      throw Exception('Erro ao excluir tarefa: $e');
    }
  }
}