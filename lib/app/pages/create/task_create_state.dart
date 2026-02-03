// lib/app/pages/create/task_create_state.dart
import 'package:equatable/equatable.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart'; 
import 'package:task_manager/app/core/ui/base_state/base_status.dart';

class TaskCreateState extends Equatable {
  final BaseStatus status;
  final String? titulo;
  final String? descricao;
  final TaskStatus selectedStatus; 
  final String? errorMessage;
  final bool isSaving;

  const TaskCreateState({
    required this.status,
    this.titulo,
    this.descricao,
    required this.selectedStatus, 
    this.errorMessage,
    this.isSaving = false,
  });

  TaskCreateState.initial()
      : status = BaseStatus.initial,
        titulo = null,
        descricao = null,
        selectedStatus = TaskStatus.emAberto, 
        errorMessage = null,
        isSaving = false;

  @override
  List<Object?> get props => [
        status,
        titulo,
        descricao,
        selectedStatus, 
        errorMessage,
        isSaving,
      ];

  TaskCreateState copyWith({
    BaseStatus? status,
    String? titulo,
    String? descricao,
    TaskStatus? selectedStatus, 
    String? errorMessage,
    bool? isSaving,
  }) {
    return TaskCreateState(
      status: status ?? this.status,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      selectedStatus: selectedStatus ?? this.selectedStatus, 
      errorMessage: errorMessage ?? this.errorMessage,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  bool get isValid {
    return (titulo?.trim().isNotEmpty ?? false) && 
           (descricao?.trim().isNotEmpty ?? false);
  }
}