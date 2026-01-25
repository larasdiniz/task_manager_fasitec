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
