// lib/app/pages/create/task_create_controller.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart'; // ADICIONE ESTE IMPORT
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/pages/create/task_create_state.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';

class TaskCreateController extends Cubit<TaskCreateState> {
  final TaskRepository _taskRepository;

  TaskCreateController({
    required TaskRepository taskRepository,
  })  : _taskRepository = taskRepository,
        super(TaskCreateState.initial());

  void updateTitulo(String titulo) {
    if (titulo != state.titulo) {
      emit(state.copyWith(titulo: titulo));
    }
  }

  void updateDescricao(String descricao) {
    if (descricao != state.descricao) {
      emit(state.copyWith(descricao: descricao));
    }
  }

  void updateStatus(TaskStatus newStatus) {
    if (newStatus != state.selectedStatus) {
      emit(state.copyWith(selectedStatus: newStatus));
    }
  }

  Future<TaskModel?> createTask() async {
    if (state.isSaving || !state.isValid) return null;

    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      final newTask = await _taskRepository.createTask(
        titulo: state.titulo!.trim(),
        descricao: state.descricao!.trim(),
        status: state.selectedStatus,
      );

      emit(state.copyWith(
        isSaving: false,
        status: BaseStatus.success,
      ));

      return newTask;
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Erro ao criar tarefa: $e',
      ));
      return null;
    }
  }

  void reset() {
    emit(TaskCreateState.initial());
  }
}