// lib/app/pages/create/task_create_router.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app/pages/create/task_create_controller.dart';
import 'package:task_manager/app/pages/create/task_create_page.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository_impl.dart';
import 'package:task_manager/fake_task_api.dart';

class TaskCreateRouter {
  TaskCreateRouter._();

  static Widget getPage() {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>(
          create: (context) => TaskRepositoryImpl(context.read<FakeTasksApi>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final taskRepository = context.read<TaskRepository>();
          return Provider(
            create: (context) => TaskCreateController(
              taskRepository: taskRepository,
            ),
            child: const TaskCreatePage(),
          );
        },
      ),
    );
  }
}