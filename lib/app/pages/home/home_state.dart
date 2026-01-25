// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/models/task_model.dart';

class HomeState extends Equatable {
  final BaseStatus status;
  final List<TaskModel> taskList;

  const HomeState(this.status, this.taskList);

  HomeState.initial() : status = BaseStatus.initial, taskList = [];

  @override
  List<Object?> get props => [status, taskList];

  HomeState copyWith({BaseStatus? status, List<TaskModel>? taskList}) {
    return HomeState(status ?? this.status, taskList ?? this.taskList);
  }
}
