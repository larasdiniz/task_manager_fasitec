import 'package:equatable/equatable.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/models/task_model.dart';

class HomeState extends Equatable {
  final BaseStatus status;
  final List<TaskModel> taskList;
  final List<TaskModel> filteredTaskList;
  final String selectedStatusFilter;
  final int tasksInProgress;
  final double completionRate;
  final bool isSelectionMode;
  final Set<int> selectedTaskIds;

  const HomeState({
    required this.status,
    required this.taskList,
    required this.filteredTaskList,
    required this.selectedStatusFilter,
    required this.tasksInProgress,
    required this.completionRate,
    this.isSelectionMode = false,
    this.selectedTaskIds = const {},
  });

  HomeState.initial() 
    : status = BaseStatus.initial, 
      taskList = [],
      filteredTaskList = [],
      selectedStatusFilter = 'Todos',
      tasksInProgress = 0,
      completionRate = 0.0,
      isSelectionMode = false,
      selectedTaskIds = {};

  @override
  List<Object?> get props => [
    status, 
    taskList, 
    filteredTaskList, 
    selectedStatusFilter,
    tasksInProgress, 
    completionRate,
    isSelectionMode,
    selectedTaskIds,
  ];

  HomeState copyWith({
    BaseStatus? status,
    List<TaskModel>? taskList,
    List<TaskModel>? filteredTaskList,
    String? selectedStatusFilter,
    int? tasksInProgress,
    double? completionRate,
    bool? isSelectionMode,
    Set<int>? selectedTaskIds,
  }) {
    return HomeState(
      status: status ?? this.status,
      taskList: taskList ?? this.taskList,
      filteredTaskList: filteredTaskList ?? this.filteredTaskList,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      tasksInProgress: tasksInProgress ?? this.tasksInProgress,
      completionRate: completionRate ?? this.completionRate,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedTaskIds: selectedTaskIds ?? this.selectedTaskIds,
    );
  }

  // Métodos auxiliares
  int get selectedCount => selectedTaskIds.length;
  bool get hasSelectedTasks => selectedTaskIds.isNotEmpty;
  bool isTaskSelected(int taskId) => selectedTaskIds.contains(taskId);
}