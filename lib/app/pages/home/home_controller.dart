import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/pages/home/home_state.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';

class HomeController extends Cubit<HomeState> {
  final TaskRepository _taskRepository;
  HomeController(this._taskRepository) : super(HomeState.initial());

  Future<void> onInit() async {
    emit(state.copyWith(status: BaseStatus.loading));

    final List<TaskModel> taskList = await _taskRepository.getAllTasks();

    int tasksInProgress = 0;
    int tasksFinalizado = 0;
    
    for (var task in taskList) {
      final statusString = task.status.toString();
      
      if (statusString.contains('emProgresso')) {
        tasksInProgress++;
      }
      if (statusString.contains('finalizado')) {
        tasksFinalizado++;
      }
    }
    
    final completionRate = taskList.isEmpty ? 0.0 : (tasksFinalizado / taskList.length) * 100;

    emit(state.copyWith(
      status: BaseStatus.loaded,
      taskList: taskList,
      tasksInProgress: tasksInProgress,
      completionRate: completionRate,
    ));
  }
}