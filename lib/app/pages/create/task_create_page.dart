// lib/app/pages/create/task_create_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart';
import 'package:task_manager/app/core/ui/base_state/base_state.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/core/ui/extensions/size_extensions.dart';
import 'package:task_manager/app/core/ui/extensions/task_status_extension.dart';
import 'package:task_manager/app/core/ui/extensions/text_style_extensions.dart';
import 'package:task_manager/app/core/ui/styles/colors_app.dart';
import 'package:task_manager/app/pages/create/task_create_controller.dart';
import 'package:task_manager/app/pages/create/task_create_state.dart';

class TaskCreatePage extends StatefulWidget {
  const TaskCreatePage({super.key});

  @override
  State<TaskCreatePage> createState() => _TaskCreatePageState();
}

class _TaskCreatePageState extends BaseState<TaskCreatePage, TaskCreateController> {
  late final TextEditingController _tituloController;
  late final TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _descricaoController = TextEditingController();
  }

  Future<void> _createTask() async {
    final newTask = await controller.createTask();
    
    if (newTask != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tarefa criada com sucesso!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } else if (controller.state.errorMessage != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.state.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (_tituloController.text.isNotEmpty || _descricaoController.text.isNotEmpty) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) => _buildUnsavedChangesDialog(context),
      );
      return result ?? false;
    }
    return true;
  }

  Widget _buildUnsavedChangesDialog(BuildContext context) {
    final colors = ColorsApp.i;
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: Text(
        'Alterações não salvas',
        style: TextStyle().mediumText.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: Text(
        'Você tem alterações não salvas. Deseja descartá-las?',
        style: TextStyle().smallText.copyWith(
          color: theme.colorScheme.onSurface.withOpacity(0.8),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancelar',
            style: TextStyle().smallText.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(
            backgroundColor: colors.error,
            foregroundColor: colors.white,
          ),
          child: Text(
            'Descartar',
            style: TextStyle().smallText.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocConsumer<TaskCreateController, TaskCreateState>(
        listener: (context, state) {
          if (state.status == BaseStatus.success && mounted) {
            _tituloController.clear();
            _descricaoController.clear();
            controller.reset();
          }
        },
        builder: (context, state) {
          return _buildScaffold(context, state);
        },
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, TaskCreateState state) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Nova Tarefa',
          style: TextStyle().largeText.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color,
          ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.appBarTheme.titleTextStyle?.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _buildBody(context, state),
    );
  }

  Widget _buildBody(BuildContext context, TaskCreateState state) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(context.percentWidth(0.05)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildCard(
                theme: theme,
                colors: colors,
                isDark: isDark,
                title: "Título",
                child: TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Digite o título da tarefa",
                    hintStyle: TextStyle().inputText.copyWith(
                      color: isDark ? Colors.white54 : colors.gray,
                    ),
                  ),
                  style: TextStyle().mediumText.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  onChanged: controller.updateTitulo,
                ),
              ),
              SizedBox(height: context.percentHeight(0.02)),

              _buildCard(
                theme: theme,
                colors: colors,
                isDark: isDark,
                title: "Descrição",
                child: TextField(
                  controller: _descricaoController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Digite a descrição da tarefa",
                    hintStyle: TextStyle().inputText.copyWith(
                      color: isDark ? Colors.white54 : colors.gray,
                    ),
                  ),
                  style: TextStyle().mediumText.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  onChanged: controller.updateDescricao,
                ),
              ),
              SizedBox(height: context.percentHeight(0.02)),

              _buildCard(
                theme: theme,
                colors: colors,
                isDark: isDark,
                title: "Status",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getTaskColor(state.selectedStatus).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: _getTaskColor(state.selectedStatus).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _getStatusText(state.selectedStatus),
                            style: TextStyle().smallText.copyWith(
                              color: _getTaskColor(state.selectedStatus),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Status selecionado',
                          style: TextStyle().smallText.copyWith(
                            color: isDark ? Colors.white54 : colors.gray,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.percentHeight(0.02)),
                    Text(
                      'Selecione o status inicial:',
                      style: TextStyle().smallText.copyWith(
                        color: isDark ? Colors.white70 : colors.darkBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: context.percentHeight(0.015)),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusButton(
                            context: context,
                            status: TaskStatus.emAberto,
                            currentStatus: state.selectedStatus,
                            colors: colors,
                            isSelected: state.selectedStatus == TaskStatus.emAberto,
                          ),
                        ),
                        SizedBox(width: context.percentWidth(0.02)),
                        Expanded(
                          child: _buildStatusButton(
                            context: context,
                            status: TaskStatus.emProgresso,
                            currentStatus: state.selectedStatus,
                            colors: colors,
                            isSelected: state.selectedStatus == TaskStatus.emProgresso,
                          ),
                        ),
                        SizedBox(width: context.percentWidth(0.02)),
                        Expanded(
                          child: _buildStatusButton(
                            context: context,
                            status: TaskStatus.finalizado,
                            currentStatus: state.selectedStatus,
                            colors: colors,
                            isSelected: state.selectedStatus == TaskStatus.finalizado,
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: context.percentHeight(0.015)),
                    Text(
                      'A tarefa será criada com o status selecionado',
                      style: TextStyle().smallText.copyWith(
                        color: isDark ? Colors.white54 : colors.gray,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: context.percentHeight(0.04)),

              if (state.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(bottom: context.percentHeight(0.02)),
                  child: Text(
                    state.errorMessage!,
                    style: TextStyle().smallText.copyWith(color: colors.error),
                    textAlign: TextAlign.center,
                  ),
                ),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark
                            ? theme.colorScheme.surface
                            : colors.lightBlue,
                        padding: EdgeInsets.symmetric(vertical: context.percentHeight(0.02)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        "Cancelar",
                        style: TextStyle().mediumText.copyWith(
                          color: isDark ? Colors.white70 : colors.gray,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.percentWidth(0.03)),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isValid
                            ? colors.primaryBlue
                            : colors.gray.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: context.percentHeight(0.02)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: (state.isSaving || !state.isValid)
                          ? null
                          : _createTask,
                      child: state.isSaving
                          ? SizedBox(
                              height: context.percentHeight(0.03),
                              width: context.percentHeight(0.03),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Criar",
                              style: TextStyle()
                                  .buttom(color: Colors.white)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.percentHeight(0.03)),
            ],
          ),
        ),
      ),
    );
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

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.emAberto:
        return Icons.hourglass_empty;
      case TaskStatus.emProgresso:
        return Icons.directions_run;
      case TaskStatus.finalizado:
        return Icons.check_circle;
    }
  }

  Widget _buildStatusButton({
    required BuildContext context,
    required TaskStatus status,
    required TaskStatus currentStatus,
    required ColorsApp colors,
    required bool isSelected,
  }) {
    final color = _getTaskColor(status); 
    
    return GestureDetector(
      onTap: () {
        controller.updateStatus(status);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.percentHeight(0.01), 
          horizontal: context.percentWidth(0.005),
        ),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : color.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(status),
              size: context.percentWidth(0.05).clamp(20, 24),
              color: isSelected ? Colors.white : color,
            ),
            SizedBox(height: context.percentHeight(0.005)),
            Text(
              status.label,
              textAlign: TextAlign.center,
              style: TextStyle().smallText.copyWith(
                color: isSelected ? Colors.white : color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required ThemeData theme,
    required ColorsApp colors,
    required bool isDark,
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle().smallText.copyWith(
            color: colors.primaryBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: context.percentHeight(0.01)),
        Container(
          padding: EdgeInsets.all(context.percentWidth(0.04)),
          decoration: BoxDecoration(
            color: isDark ? theme.colorScheme.surface : colors.lightBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: child,
        ),
      ],
    );
  }
}