import 'package:task_manager/app/models/task_model.dart';

abstract class TaskRepository {
  Future<List<TaskModel>> getAllTasks();
}
