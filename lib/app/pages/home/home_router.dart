import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/app/pages/home/home_controller.dart';
import 'package:task_manager/app/pages/home/home_page.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository_impl.dart';
import 'package:task_manager/fake_task_api.dart';

class HomeRouter {
  HomeRouter._();

  static Widget get page => MultiProvider(
    providers: [
      Provider<TaskRepository>(create: (context) => TaskRepositoryImpl(context.read<FakeTasksApi>())),
      Provider(create: (context) => HomeController(context.read<TaskRepository>())),
    ],
    child: HomePage(),
  );
}
