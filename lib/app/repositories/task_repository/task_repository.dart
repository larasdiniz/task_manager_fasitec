import 'package:task_manager/app/core/enums/task_status_enum.dart';
import 'package:task_manager/app/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTasks();
  Future<List<TaskModel>> getTasksByStatus(String status);
  
  Future<TaskModel> createTask({
    required String titulo,
    required String descricao,
    required TaskStatus status, 
  });
  
  Future<TaskModel> updateTask({
    required int id,
    String? titulo,
    String? descricao,
    TaskStatus? status,
  });
  
  Future<void> deleteTask(int id);
  Future<void> deleteMultipleTasks(List<int> ids);
  Future<void> updateMultipleTasksStatus(List<int> ids, TaskStatus newStatus);
}