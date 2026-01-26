import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart'; 
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/pages/home/home_state.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';

class HomeController extends Cubit<HomeState> {
  final TaskRepository _taskRepository;
  HomeController(this._taskRepository) : super(HomeState.initial());

  Future<void> onInit() async {
    emit(state.copyWith(status: BaseStatus.loading));

    try {
      final List<TaskModel> taskList = await _taskRepository.getAllTasks();

      final tasksInProgress = taskList
          .where((task) => task.status == TaskStatus.emProgresso)
          .length;
      
      final tasksFinalizado = taskList
          .where((task) => task.status == TaskStatus.finalizado)
          .length;
      
      final completionRate = taskList.isEmpty 
          ? 0.0 
          : (tasksFinalizado / taskList.length) * 100;

      emit(state.copyWith(
        status: BaseStatus.loaded,
        taskList: taskList,
        tasksInProgress: tasksInProgress,
        completionRate: completionRate,
      ));
      
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus.error,
      ));
    }
  }
}