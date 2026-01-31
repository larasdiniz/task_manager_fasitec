// lib/app/pages/edit/task_edit_state.dart
import 'package:equatable/equatable.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/models/task_model.dart';

class TaskEditState extends Equatable {
  final BaseStatus status;
  final TaskModel? task;
  final String? titulo;
  final String? descricao;
  final TaskStatus selectedStatus; 
  final String? errorMessage;
  final bool isSaving;
  final bool isDeleting;

  const TaskEditState({
    required this.status,
    this.task,
    this.titulo,
    this.descricao,
    required this.selectedStatus,
    this.errorMessage,
    this.isSaving = false,
    this.isDeleting = false,
  });

  TaskEditState.initial()
      : status = BaseStatus.initial,
        task = null,
        titulo = null,
        descricao = null,
        selectedStatus = TaskStatus.emAberto, 
        errorMessage = null,
        isSaving = false,
        isDeleting = false;

  @override
  List<Object?> get props => [
        status,
        task,
        titulo,
        descricao,
        selectedStatus,
        errorMessage,
        isSaving,
        isDeleting,
      ];

  TaskEditState copyWith({
    BaseStatus? status,
    TaskModel? task,
    String? titulo,
    String? descricao,
    TaskStatus? selectedStatus,
    String? errorMessage,
    bool? isSaving,
    bool? isDeleting,
  }) {
    return TaskEditState(
      status: status ?? this.status,
      task: task ?? this.task,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isSaving: isSaving ?? this.isSaving,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  bool get hasChanges {
    if (task == null) return false;
    return titulo != task?.titulo || 
           descricao != task?.descricao || 
           selectedStatus != task?.status;
  }
}