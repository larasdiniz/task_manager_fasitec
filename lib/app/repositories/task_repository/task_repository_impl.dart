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
  Future<List<TaskModel>> getTasksByStatus(String status) async {
    try {
      final response = await api.getTasksByStatus(status);
      final List<dynamic> decodeList = jsonDecode(response);
      return decodeList.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao filtrar tarefas por status: $e');
    }
  }

  @override
  Future<TaskModel> createTask({
    required String titulo,
    required String descricao,
    required TaskStatus status, 
  }) async {
    try {
      final response = await api.addTask(
        titulo: titulo,
        descricao: descricao,
        status: status, 
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
    TaskStatus? status,
  }) async {
    try {
      final response = await api.updateTask(
        id: id,
        titulo: titulo,
        descricao: descricao,
        status: status,
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

  @override
  Future<void> deleteMultipleTasks(List<int> ids) async {
    try {
      final response = await api.deleteMultipleTasks(ids);
      final Map<String, dynamic> json = jsonDecode(response);
      
      if (json.containsKey('error')) {
        throw Exception(json['error']);
      }
    } catch (e) {
      throw Exception('Erro ao excluir múltiplas tarefas: $e');
    }
  }

  @override
  Future<void> updateMultipleTasksStatus(List<int> ids, TaskStatus newStatus) async {
    try {
      final response = await api.updateMultipleTasksStatus(ids, newStatus);
      final Map<String, dynamic> json = jsonDecode(response);
      
      if (json.containsKey('error')) {
        throw Exception(json['error']);
      }
    } catch (e) {
      throw Exception('Erro ao atualizar status de múltiplas tarefas: $e');
    }
  }
}