// lib/app/pages/task_edit/task_edit_router.dart - JÁ ESTÁ CORRETO
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app/pages/edit/task_edit_controller.dart';
import 'package:task_manager/app/pages/edit/task_edit_page.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository_impl.dart';
import 'package:task_manager/fake_task_api.dart';

class TaskEditRouter {
  TaskEditRouter._();

  static Widget getPage({required int taskId, required String taskTitle}) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>(
          create: (context) => TaskRepositoryImpl(context.read<FakeTasksApi>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          final taskRepository = context.read<TaskRepository>();
          return FutureBuilder(
            future: _loadTask(taskRepository, taskId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (snapshot.hasError || snapshot.data == null) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(taskTitle),
                  ),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 50, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Erro ao carregar tarefa',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Voltar'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final task = snapshot.data!;
              return Provider(
                create: (context) => TaskEditController(
                  taskRepository: taskRepository,
                  initialTask: task,
                ),
                child: const TaskEditPage(),
              );
            },
          );
        },
      ),
    );
  }

  static Future<dynamic> _loadTask(TaskRepository repository, int taskId) async {
    try {
      final tasks = await repository.getAllTasks();
      final task = tasks.firstWhere((task) => task.id == taskId);
      return task;
    } catch (e) {
      return null;
    }
  }
}