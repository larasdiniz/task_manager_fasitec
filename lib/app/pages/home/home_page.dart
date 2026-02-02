// lib/app/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/base_state/base_state.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart'; 
import 'package:task_manager/app/core/enums/task_status_enum.dart';
import 'package:task_manager/app/core/ui/extensions/size_extensions.dart';
import 'package:task_manager/app/core/ui/extensions/text_style_extensions.dart';
import 'package:task_manager/app/core/ui/styles/colors_app.dart'; 
import 'package:task_manager/app/pages/home/home_controller.dart';
import 'package:task_manager/app/pages/home/home_state.dart';
import 'package:task_manager/app/models/task_model.dart';
import 'package:task_manager/app/core/utils/router_name_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseState<HomePage, HomeController> {
  @override
  void onReady() {
    controller.onInit();
    super.onReady();
  }

  Color _getTaskColor(TaskStatus status) {
    final colors = ColorsApp.i;
    switch (status) {
      case TaskStatus.finalizado:
        return colors.primaryBlue;
      case TaskStatus.emProgresso:
        return colors.success;
      case TaskStatus.emAberto:
        return colors.warning;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.finalizado:
        return 'Concluído';
      case TaskStatus.emProgresso:
        return 'Em Progresso';
      case TaskStatus.emAberto:
        return 'Em Aberto';
    }
  }

  bool _isCompleted(TaskStatus status) {
    return status == TaskStatus.finalizado;
  }

  Future<void> _toggleTaskStatus(TaskModel task) async {
    TaskStatus newStatus;
    
    if (task.status == TaskStatus.finalizado) {
      newStatus = TaskStatus.emAberto;
    } else {
      newStatus = TaskStatus.finalizado;
    }

    try {
      await controller.taskRepository.updateTask(
        id: task.id,
        titulo: task.titulo,
        descricao: task.descricao,
        status: newStatus,
      );
      controller.refreshTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == TaskStatus.finalizado 
              ? 'Tarefa marcada como concluída!' 
              : 'Tarefa reaberta!',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar tarefa: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _navigateToEditTask(BuildContext context, TaskModel task) {
    Navigator.of(context).pushNamed(
      RouterNameUtils.getTaskEditPage, 
      arguments: {                   
        'taskId': task.id,
        'taskTitle': task.titulo,
      },
    ).then((result) {
      if (result == true) {
        controller.refreshTasks();
      }
    });
  }

  void _navigateToCreateTask(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouterNameUtils.getTaskCreatePage,
    ).then((result) {
      if (result == true) {
        controller.refreshTasks();
      }
    });
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouterNameUtils.getSettingsPage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation ?? 0,
        centerTitle: theme.appBarTheme.centerTitle ?? false,
        automaticallyImplyLeading: false,
        title: Text(
          'Tarefas',
          style: TextStyle().largeText.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color,
          ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 28.sp,
              color: theme.appBarTheme.titleTextStyle?.color ?? theme.appBarTheme.iconTheme?.color,
            ),
            onPressed: () => _navigateToCreateTask(context),
          ),
          const SizedBox(width: 12),
        ],
      ),

      body: SafeArea(
        child: BlocBuilder<HomeController, HomeState>(
          builder: (context, state) {
            if (state.status == BaseStatus.loading) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary, 
                ),
              );
            }

            if (state.status == BaseStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50,
                      color: theme.colorScheme.error, 
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar tarefas',
                      style: TextStyle().mediumText.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cards de métricas
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.percentWidth(0.05),
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      // Card 1: Taxa de conclusão
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colors.darkBlue, colors.primaryBlue],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Taxa de conclusão",
                                style: TextStyle().smallText.copyWith(
                                  color: colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${state.completionRate.toStringAsFixed(0)}%",
                                    style: TextStyle().largeText.copyWith(
                                      color: colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.verified,
                                    color: colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Card 2: Em andamento
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [colors.darkBlueGradient, colors.darkBlue]
                                  : [colors.lightBlue, colors.lightBlue],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Em andamento",
                                style: TextStyle().smallText.copyWith(
                                  color: isDark ? colors.textSecondaryDark : colors.darkBlue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${state.tasksInProgress}",
                                        style: TextStyle().largeText.copyWith(
                                          color: isDark ? colors.textSecondaryDark : colors.darkBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "tarefas",
                                        style: TextStyle().smallText.copyWith(
                                          color: isDark ? colors.textSecondaryDark : colors.darkBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.directions_run,
                                    color: isDark ? colors.textSecondaryDark : colors.darkBlue,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Filtros
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.percentWidth(0.05),
                  ),
                  child: Row(
                    children: [
                      // Filtro por Status
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colors.darkBlue, colors.primaryBlue],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Status",
                                style: TextStyle().smallText.copyWith(
                                  color: colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: state.selectedStatusFilter,
                                    dropdownColor: colors.darkBlue,
                                    iconEnabledColor: colors.white,
                                    style: TextStyle().smallText.copyWith(color: colors.white),
                                    items: ['Todos', 'Em Aberto', 'Em Progresso', 'Finalizado']
                                        .map(
                                          (status) => DropdownMenuItem(
                                            value: status,
                                            child: Text(
                                              status,
                                              style: TextStyle().smallText.copyWith(color: colors.white),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.updateStatusFilter(value);
                                      }
                                    },
                                    isExpanded: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Ordenação
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isDark
                                ? colors.darkBlueGradient
                                : colors.lightBlue,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'Prazo',
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 24,
                                color: isDark ? colors.textSecondaryDark : colors.darkBlue,
                              ),
                              style: TextStyle().smallText.copyWith(
                                color: isDark ? colors.textSecondaryDark : colors.darkBlue,
                                fontWeight: FontWeight.bold,
                              ),
                              items: ['Prazo', 'Prioridade', 'Alfabética']
                                  .map(
                                    (opcao) => DropdownMenuItem(
                                      value: opcao,
                                      child: Text(
                                        opcao,
                                        style: TextStyle().smallText.copyWith(
                                          color: isDark ? colors.textSecondaryDark : colors.darkBlue,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {},
                              isExpanded: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: _buildTaskList(state),
                ),
              ],
            );
          },
        ),
      ),

      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? colors.darkGray : colors.lightGray,
              width: 0.5,
            ),
          ),
          color: isDark ? colors.darkSurface : colors.lightSurface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.task, 'Tarefas', true),
            _buildNavItem(Icons.category, 'Categorias', false),
            _buildNavItem(Icons.flag, 'Metas', false),
            _buildNavItem(Icons.bar_chart, 'Estatísticas', false),
            _buildNavItem(Icons.settings, 'Config', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(HomeState state) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;
    
    if (state.status == BaseStatus.initial || state.status == BaseStatus.loading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }
    
    if (state.filteredTaskList.isEmpty && state.status == BaseStatus.loaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              state.selectedStatusFilter == 'Todos' 
                ? Icons.task 
                : Icons.filter_list,
              size: 50,
              color: theme.disabledColor,
            ),
            const SizedBox(height: 16),
            Text(
              state.selectedStatusFilter == 'Todos'
                  ? 'Nenhuma tarefa encontrada'
                  : 'Nenhuma tarefa com status "${state.selectedStatusFilter}"',
              style: TextStyle().mediumText.copyWith(
                color: theme.disabledColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.selectedStatusFilter == 'Todos'
                  ? 'Clique no + para adicionar'
                  : 'Tente selecionar outro filtro',
              style: TextStyle().smallText.copyWith(
                color: theme.disabledColor.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: context.percentWidth(0.05),
      ),
      itemCount: state.filteredTaskList.length,
      itemBuilder: (context, index) {
        final task = state.filteredTaskList[index];
        final taskColor = _getTaskColor(task.status);
        final isCompleted = _isCompleted(task.status);
        final statusText = _getStatusText(task.status);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(isDark ? 0.1 : 0.15),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox clicável
              GestureDetector(
                onTap: () => _toggleTaskStatus(task),
                child: Container(
                  margin: const EdgeInsets.all(12),
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: isCompleted ? taskColor : Colors.transparent,
                    border: Border.all(
                      color: taskColor,
                      width: 2,
                    ),
                  ),
                  child: isCompleted
                      ? Icon(
                          Icons.check,
                          size: 16,
                          color: colors.white,
                        )
                      : null,
                ),
              ),
              
              // Resto da tarefa (clicável para editar)
              Expanded(
                child: GestureDetector(
                  onTap: () => _navigateToEditTask(context, task),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Título
                              Text(
                                task.titulo,
                                style: TextStyle().mediumText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: isCompleted
                                      ? theme.disabledColor
                                      : theme.colorScheme.onSurface,
                                  decoration: isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Status badge + ID
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: taskColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: taskColor.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle().smallText.copyWith(
                                        color: taskColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (state.selectedStatusFilter == 'Todos')
                                    Text(
                                      "ID: ${task.id}",
                                      style: TextStyle().smallText.copyWith(
                                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Ícone de seta
                        Icon(
                          Icons.chevron_right,
                          color: theme.disabledColor,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = theme.colorScheme.primary; 
    final inactiveColor = isDark ? colors.textSecondaryDark : colors.textSecondaryLight;

    return GestureDetector(
      onTap: () {
        if (label == 'Config') {
          _navigateToSettings(context);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isActive ? activeColor : inactiveColor,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle().smallText.copyWith(
              fontSize: 12.sp,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}