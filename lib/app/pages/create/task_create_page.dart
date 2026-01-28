// lib/app/pages/create/task_create_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/base_state/base_state.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart';
import 'package:task_manager/app/core/ui/extensions/size_extensions.dart';
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
      Navigator.of(context).pop(true); // Retorna true para indicar sucesso
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
    final colors = ColorsApp.i;
    final isDark = theme.brightness == Brightness.dark;

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
            color: isDark ? Colors.white70 : colors.gray,
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

              _buildCard(
                theme: theme,
                colors: colors,
                isDark: isDark,
                title: "Status",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Chip(
                      backgroundColor: colors.warning, // Em Aberto
                      label: Text(
                        'Em Aberto',
                        style: TextStyle().smallText.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Definido automaticamente',
                      style: TextStyle().smallText.copyWith(
                        color: isDark ? Colors.white54 : colors.gray,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),

              _buildCard(
                theme: theme,
                colors: colors,
                isDark: isDark,
                title: "ID",
                child: Text(
                  'Será gerado automaticamente',
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
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: (state.isSaving || !state.isValid)
                          ? null
                          : _createTask,
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