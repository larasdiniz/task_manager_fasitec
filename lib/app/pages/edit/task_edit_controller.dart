// lib/app/pages/edit/task_edit_controller.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/pages/edit/task_edit_state.dart';
import 'package:task_manager/app/repositories/task_repository/task_repository.dart';

class TaskEditController extends Cubit<TaskEditState> {
  final TaskRepository _taskRepository;
  final TaskModel initialTask;

  TaskEditController({
    required TaskRepository taskRepository,
    required this.initialTask,
  })  : _taskRepository = taskRepository,
        super(TaskEditState.initial().copyWith(
          task: initialTask,
          titulo: initialTask.titulo,
          descricao: initialTask.descricao,
          status: BaseStatus.loaded,
        ));

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

  Future<bool> saveTask() async {
    if (state.isSaving || !state.hasChanges) return false;

    emit(state.copyWith(isSaving: true, errorMessage: null));

    try {
      final updatedTask = await _taskRepository.updateTask(
        id: initialTask.id,
        titulo: state.titulo,
        descricao: state.descricao,
      );

      emit(state.copyWith(
        isSaving: false,
        task: updatedTask,
        titulo: updatedTask.titulo,
        descricao: updatedTask.descricao,
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        isSaving: false,
        errorMessage: 'Erro ao salvar tarefa: $e',
      ));
      return false;
    }
  }

  Future<bool> deleteTask() async {
    if (state.isDeleting) return false;

    emit(state.copyWith(isDeleting: true, errorMessage: null));

    try {
      await _taskRepository.deleteTask(initialTask.id);
      emit(state.copyWith(isDeleting: false));
      return true;
    } catch (e) {
      emit(state.copyWith(
        isDeleting: false,
        errorMessage: 'Erro ao excluir tarefa: $e',
      ));
      return false;
    }
  }
}