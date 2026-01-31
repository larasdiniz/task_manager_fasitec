// lib/app/pages/home/home_state.dart
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

  const HomeState({
    required this.status,
    required this.taskList,
    required this.filteredTaskList,
    required this.selectedStatusFilter,
    required this.tasksInProgress,
    required this.completionRate,
  });

  HomeState.initial() 
    : status = BaseStatus.initial, 
      taskList = [],
      filteredTaskList = [],
      selectedStatusFilter = 'Todos',
      tasksInProgress = 0,
      completionRate = 0.0;

  @override
  List<Object?> get props => [
    status, 
    taskList, 
    filteredTaskList, 
    selectedStatusFilter,
    tasksInProgress, 
    completionRate
  ];

  HomeState copyWith({
    BaseStatus? status,
    List<TaskModel>? taskList,
    List<TaskModel>? filteredTaskList,
    String? selectedStatusFilter,
    int? tasksInProgress,
    double? completionRate,
  }) {
    return HomeState(
      status: status ?? this.status,
      taskList: taskList ?? this.taskList,
      filteredTaskList: filteredTaskList ?? this.filteredTaskList,
      selectedStatusFilter: selectedStatusFilter ?? this.selectedStatusFilter,
      tasksInProgress: tasksInProgress ?? this.tasksInProgress,
      completionRate: completionRate ?? this.completionRate,
    );
  }
}