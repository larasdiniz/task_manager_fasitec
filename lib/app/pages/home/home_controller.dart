import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart'; 
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/pages/home/home_state.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';

class HomeController extends Cubit<HomeState> {
  final TaskRepository _taskRepository;
  TaskRepository get taskRepository => _taskRepository;
  
  HomeController(this._taskRepository) : super(HomeState.initial());

  Future<void> onInit() async {
    emit(state.copyWith(status: BaseStatus.loading));

    try {
      final List<TaskModel> taskList = await _taskRepository.getAllTasks();
      final metrics = _calculateMetrics(taskList);

      emit(state.copyWith(
        status: BaseStatus.loaded,
        taskList: taskList,
        filteredTaskList: taskList,
        selectedStatusFilter: 'Todos',
        tasksInProgress: metrics['tasksInProgress'] ?? 0,
        completionRate: metrics['completionRate'] ?? 0.0,
      ));
      
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus.error,
      ));
    }
  }

  Future<void> updateStatusFilter(String filter) async {
    if (state.selectedStatusFilter == filter) return;
    
    emit(state.copyWith(
      selectedStatusFilter: filter,
      status: BaseStatus.loading,
    ));

    try {
      List<TaskModel> filteredList;
      
      if (filter == 'Todos') {
        filteredList = await _taskRepository.getAllTasks();
      } else {
        filteredList = await _taskRepository.getTasksByStatus(filter);
      }
      
      emit(state.copyWith(
        filteredTaskList: filteredList,
        status: BaseStatus.loaded,
      ));
      
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus.error,
      ));
    }
  }

  Map<String, dynamic> _calculateMetrics(List<TaskModel> taskList) {
    final tasksInProgress = taskList
        .where((task) => task.status == TaskStatus.emProgresso)
        .length;
    
    final tasksFinalizado = taskList
        .where((task) => task.status == TaskStatus.finalizado)
        .length;
    
    final completionRate = taskList.isEmpty 
        ? 0.0 
        : (tasksFinalizado / taskList.length) * 100;

    return {
      'tasksInProgress': tasksInProgress,
      'completionRate': completionRate,
    };
  }

  Future<void> refreshTasks() async {
    emit(state.copyWith(status: BaseStatus.loading));
    
    try {
      final List<TaskModel> taskList = await _taskRepository.getAllTasks();
      print('DEBUG: Total de tarefas: ${taskList.length}');

      final metrics = _calculateMetrics(taskList);
      print('DEBUG: Métricas calculadas - Em progresso: ${metrics['tasksInProgress']}, Conclusão: ${metrics['completionRate']}%');

      final currentFilter = state.selectedStatusFilter;
      List<TaskModel> filteredList;
      
      if (currentFilter == 'Todos') {
        filteredList = taskList;
      } else {
        filteredList = await _taskRepository.getTasksByStatus(currentFilter);
      }
      
      emit(state.copyWith(
        status: BaseStatus.loaded,
        taskList: taskList,
        filteredTaskList: filteredList,
        tasksInProgress: metrics['tasksInProgress'] ?? 0,
        completionRate: metrics['completionRate'] ?? 0.0,
      ));
      
    } catch (e) {
      print('DEBUG: Erro no refreshTasks: $e');
      emit(state.copyWith(
        status: BaseStatus.error,
      ));
    }
  }

  Future<void> onTaskChanged() async {
    await refreshTasks();
  }

  void toggleSelectionMode() {
    final newIsSelectionMode = !state.isSelectionMode;
    
    emit(state.copyWith(
      isSelectionMode: newIsSelectionMode,
      selectedTaskIds: newIsSelectionMode ? state.selectedTaskIds : {},
    ));
  }

  void toggleTaskSelection(int taskId) {
    final newSelectedIds = Set<int>.from(state.selectedTaskIds);
    if (newSelectedIds.contains(taskId)) {
      newSelectedIds.remove(taskId);
    } else {
      newSelectedIds.add(taskId);
    }
    
    emit(state.copyWith(selectedTaskIds: newSelectedIds));
  }

  void selectAllTasks() {
    final allIds = state.filteredTaskList.map((task) => task.id).toSet();
    emit(state.copyWith(selectedTaskIds: allIds));
  }

  void clearSelection() {
    emit(state.copyWith(selectedTaskIds: {}));
  }

  Future<void> deleteSelectedTasks() async {
    if (state.selectedTaskIds.isEmpty) return;
    
    emit(state.copyWith(status: BaseStatus.loading));
    
    try {
      await _taskRepository.deleteMultipleTasks(state.selectedTaskIds.toList());
      await refreshTasks();
      emit(state.copyWith(
        isSelectionMode: false,
        selectedTaskIds: {},
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus.error,
      ));
    }
  }

  Future<void> updateSelectedTasksStatus(TaskStatus newStatus) async {
    if (state.selectedTaskIds.isEmpty) return;
    
    emit(state.copyWith(status: BaseStatus.loading));
    
    try {
      await _taskRepository.updateMultipleTasksStatus(
        state.selectedTaskIds.toList(), 
        newStatus
      );
      await refreshTasks();
      emit(state.copyWith(
        isSelectionMode: false,
        selectedTaskIds: {},
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BaseStatus.error,
      ));
    }
  }
}