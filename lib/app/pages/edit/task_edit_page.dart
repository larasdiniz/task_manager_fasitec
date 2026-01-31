// lib/app/pages/edit/task_edit_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/base_state/base_state.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/core/ui/extensions/size_extensions.dart';
import 'package:task_manager/app/core/ui/extensions/task_status_extension.dart';
import 'package:task_manager/app/core/ui/extensions/text_style_extensions.dart';
import 'package:task_manager/app/core/ui/styles/colors_app.dart';
import 'package:task_manager/app/pages/edit/task_edit_controller.dart';
import 'package:task_manager/app/pages/edit/task_edit_state.dart';
import 'package:task_manager/app/core/enums/task_status_enum.dart';

class TaskEditPage extends StatefulWidget {
  const TaskEditPage({super.key});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends BaseState<TaskEditPage, TaskEditController> {
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController();
    _descricaoController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    _updateControllersFromState();
  }

  void _updateControllersFromState() {
    final state = controller.state;
    if (_tituloController.text.isEmpty && state.titulo != null) {
      _tituloController.text = state.titulo!;
    }
    if (_descricaoController.text.isEmpty && state.descricao != null) {
      _descricaoController.text = state.descricao!;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    final success = await controller.saveTask();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Tarefa salva com sucesso!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.pop(context, true);
    } else if (controller.state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.state.errorMessage!),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> _deleteTask() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => _buildDeleteDialog(context),
    );

    if (confirmed == true) {
      final success = await controller.deleteTask();

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Tarefa excluída com sucesso!'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Widget _buildDeleteDialog(BuildContext context) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: Text(
        'Excluir Tarefa',
        style: TextStyle().mediumText.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
      content: Text(
        'Tem certeza que deseja excluir esta tarefa? Esta ação não pode ser desfeita.',
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
            foregroundColor: Colors.white,
          ),
          child: Text(
            'Excluir',
            style: TextStyle().smallText.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskEditController, TaskEditState>(
      builder: (context, state) {
        if (state.status == BaseStatus.loaded &&
            (_tituloController.text.isEmpty ||
                _descricaoController.text.isEmpty)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _tituloController.text = state.titulo ?? '';
            _descricaoController.text = state.descricao ?? '';
          });
        }

        return _buildScaffold(context, state);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, TaskEditState state) {
    final theme = Theme.of(context);
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Editar Tarefa',
          style: TextStyle().largeText.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.appBarTheme.titleTextStyle?.color,
          ),
        ),
        iconTheme: theme.appBarTheme.iconTheme,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white70 : colors.gray,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _buildBody(context, state, theme, colors, isDark),
    );
  }

  Widget _buildBody(
    BuildContext context,
    TaskEditState state,
    ThemeData theme,
    ColorsApp colors,
    bool isDark,
  ) {
    if (state.status == BaseStatus.loading) {
      return Center(
        child: CircularProgressIndicator(color: theme.colorScheme.primary),
      );
    }

    if (state.status == BaseStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 12.w,
              color: theme.colorScheme.error,
            ),
            SizedBox(height: 2.h),
            Text(
              'Erro ao carregar tarefa',
              style: TextStyle().mediumText.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Voltar', style: TextStyle().buttom()),
            ),
          ],
        ),
      );
    }

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
              SizedBox(height: 2.h),

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
              SizedBox(height: 2.h),

              if (state.task?.status != null) ...[
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
                            'Status atual',
                            style: TextStyle().smallText.copyWith(
                              color: isDark ? Colors.white54 : colors.gray,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      
                      // Seletor de novo status
                      Text(
                        'Alterar status:',
                        style: TextStyle().smallText.copyWith(
                          color: isDark ? Colors.white70 : colors.darkBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      
                      // Botões para selecionar status
                      Row(
                        children: [
                          // Botão Em Aberto
                          Expanded(
                            child: _buildStatusButton(
                              context: context,
                              status: TaskStatus.emAberto,
                              currentStatus: state.selectedStatus,
                              colors: colors,
                            ),
                          ),
                          SizedBox(width: 1.h),
                          // Botão Em Progresso
                          Expanded(
                            child: _buildStatusButton(
                              context: context,
                              status: TaskStatus.emProgresso,
                              currentStatus: state.selectedStatus,
                              colors: colors,
                            ),
                          ),
                          SizedBox(width: 1.h),
                          // Botão Finalizado
                          Expanded(
                            child: _buildStatusButton(
                              context: context,
                              status: TaskStatus.finalizado,
                              currentStatus: state.selectedStatus,
                              colors: colors,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 1.h),
                      Text(
                        'Clique para mudar o status da tarefa',
                        style: TextStyle().smallText.copyWith(
                          color: isDark ? Colors.white54 : colors.gray,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
              ],

              _buildCard(
                theme: theme,
                colors: colors,
                isDark: isDark,
                title: "ID",
                child: Text(
                  'Tarefa #${state.task?.id ?? ''}',
                  style: TextStyle().mediumText.copyWith(
                    color: isDark ? Colors.white70 : colors.darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 4.h),

              if (state.errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
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
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: state.isDeleting ? null : _deleteTask,
                      child: state.isDeleting
                          ? SizedBox(
                              height: 3.h,
                              width: 3.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colors.error,
                              ),
                            )
                          : Text(
                              "Excluir",
                              style: TextStyle().mediumText.copyWith(
                                color: colors.error,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(width: context.percentWidth(0.03)),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primaryBlue,
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: (state.isSaving || !state.hasChanges)
                          ? null
                          : _saveTask,
                      child: state.isSaving
                          ? SizedBox(
                              height: 3.h,
                              width: 3.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              "Salvar",
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

  Widget _buildStatusButton({
    required BuildContext context,
    required TaskStatus status,
    required TaskStatus currentStatus,
    required ColorsApp colors,
  }) {
    final isSelected = currentStatus == status;
    final color = _getTaskColor(status); 
    
    return GestureDetector(
      onTap: () => controller.updateStatus(status),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 0.5.h),
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
              size: 20,
              color: isSelected ? Colors.white : color,
            ),
            SizedBox(height: 0.5.h),
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
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(2.h),
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