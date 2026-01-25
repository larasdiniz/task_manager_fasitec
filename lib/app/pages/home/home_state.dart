// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/models/task_model.dart';

class HomeState extends Equatable {
  final BaseStatus status;
  final List<TaskModel> taskList;
  final int tasksInProgress;
  final double completionRate;

  const HomeState({
    required this.status,
    required this.taskList,
    required this.tasksInProgress,
    required this.completionRate,
  });

  HomeState.initial() 
    : status = BaseStatus.initial, 
      taskList = [],
      tasksInProgress = 0,
      completionRate = 0.0;

  @override
  List<Object?> get props => [status, taskList, tasksInProgress, completionRate];

  HomeState copyWith({
    BaseStatus? status,
    List<TaskModel>? taskList,
    int? tasksInProgress,
    double? completionRate,
  }) {
    return HomeState(
      status: status ?? this.status,
      taskList: taskList ?? this.taskList,
      tasksInProgress: tasksInProgress ?? this.tasksInProgress,
      completionRate: completionRate ?? this.completionRate,
    );
  }
}