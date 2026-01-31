// lib/app/pages/home/home_controller.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart'; 
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/pages/home/home_state.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';

class HomeController extends Cubit<HomeState> {
  final TaskRepository _taskRepository;
  HomeController(this._taskRepository) : super(HomeState.initial());

  // Carrega todas as tarefas inicialmente
  Future<void> onInit() async {
    emit(state.copyWith(status: BaseStatus.loading));

    try {
      final List<TaskModel> taskList = await _taskRepository.getAllTasks();
      
      // Calcula métricas totais
      final metrics = _calculateMetrics(taskList);
      
      // Usa a lista completa inicialmente
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

  // Método para aplicar filtro
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

  // Método para calcular métricas (retorna um Map)
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

  // Atualiza quando uma tarefa é criada/editada/excluída
  Future<void> refreshTasks() async {
    emit(state.copyWith(status: BaseStatus.loading));
    
    try {
      // Busca todas as tarefas atualizadas
      final List<TaskModel> taskList = await _taskRepository.getAllTasks();
      print('DEBUG: Total de tarefas: ${taskList.length}');
      
      // Calcula as novas métricas
      final metrics = _calculateMetrics(taskList);
      print('DEBUG: Métricas calculadas - Em progresso: ${metrics['tasksInProgress']}, Conclusão: ${metrics['completionRate']}%');
    
      
      // Aplica o filtro atual nas novas tarefas
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

  // Método para quando uma tarefa é adicionada/atualizada/deletada
  Future<void> onTaskChanged() async {
    await refreshTasks();
  }
}