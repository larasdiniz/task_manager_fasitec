// lib/app/repositories/task_repository/task_repository.dart
import 'package:task_manager/app/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTasks();
  

  Future<TaskModel> updateTask({
    required int id,
    String? titulo,
    String? descricao,
  });
  
  Future<void> deleteTask(int id);
}

/*
import 'package:task_manager/app/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTasks();
}
*/