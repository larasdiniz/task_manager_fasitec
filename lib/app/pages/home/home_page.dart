import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager/app/core/ui/base_state/base_state.dart';
import 'package:task_manager/app/core/ui/base_state/base_status.dart'; 
import 'package:task_manager/app/core/enums/task_status_enum.dart';
import 'package:task_manager/app/pages/home/home_controller.dart';
import 'package:task_manager/app/pages/home/home_state.dart';

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

  // Função para determinar a cor baseada no status REAL da API
  Color _getTaskColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.finalizado:
        return const Color(0xFFB991FF); 
      case TaskStatus.emProgresso:
        return const Color(0xFF4CAF50);
      case TaskStatus.emAberto:
        return const Color(0xFFE6C026); 
    }
  }

  // Texto amigável para o status
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

  // Verifica se a tarefa está concluída
  bool _isCompleted(TaskStatus status) {
    return status == TaskStatus.finalizado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      
      // AppBar
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Tarefas',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.titleTextStyle?.color,
          ),
        ),
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              size: 28.sp,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {},
          ),
          SizedBox(width: 12),
        ],
      ),

      body: SafeArea(
        child: BlocBuilder<HomeController, HomeState>(
          builder: (context, state) {
            // Verifica se está carregando
            if (state.status == BaseStatus.loading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Verifica se há erro
            if (state.status == BaseStatus.error) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Erro ao carregar tarefas',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cards principais
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFA069FF), Color(0xFFB991FF)],
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${state.completionRate.toStringAsFixed(0)}%",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: Theme.of(context).brightness == Brightness.dark
                                  ? [const Color(0xFF2A2A3D), const Color(0xFF1E1E2C)]
                                  : [const Color(0xFFC8B6F3), const Color(0xFFE0D9F0)],
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
                                style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.dark 
                                      ? Colors.white70 
                                      : const Color(0xFF413491),
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${state.tasksInProgress}",
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark 
                                              ? Colors.white70 
                                              : const Color(0xFF413491),
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        "tarefas",
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark 
                                              ? Colors.white70 
                                              : const Color(0xFF413491),
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.directions_run,
                                    color: Theme.of(context).brightness == Brightness.dark 
                                        ? Colors.white70 
                                        : const Color(0xFF413491),
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFA069FF), Color(0xFFB991FF)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Prioridade",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: 'Todas',
                                    dropdownColor: const Color(0xFFA069FF),
                                    iconEnabledColor: Colors.white,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                                    items: ['Todas', 'Alta', 'Média', 'Baixa']
                                        .map(
                                          (p) => DropdownMenuItem(
                                            value: p,
                                            child: Text(p),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark 
                                ? const Color(0xFF2A2A3D) 
                                : const Color(0xFFE0D9F0),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: 'Prazo',
                              icon: Icon(
                                Icons.keyboard_arrow_down,
                                size: 24,
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white70 
                                    : const Color(0xFF413491),
                              ),
                              style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.dark 
                                    ? Colors.white70 
                                    : const Color(0xFF413491),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              items: ['Prazo', 'Prioridade', 'Alfabética']
                                  .map(
                                    (opcao) => DropdownMenuItem(
                                      value: opcao,
                                      child: Text(opcao),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Lista de tarefas
                Expanded(
                  child: _buildTaskList(state),
                ),
              ],
            );
          },
        ),
      ),

      // Footer
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? const Color(0xFF333333) 
                  : const Color(0xFF818181),
              width: 0.5,
            ),
          ),
          color: Theme.of(context).brightness == Brightness.dark 
              ? const Color(0xFF1E1E1E) 
              : Colors.white,
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
    final taskList = state.taskList;
    
    // Verificar status inicial ou carregando
    if (state.status == BaseStatus.initial || state.status == BaseStatus.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    
    if (taskList.isEmpty && state.status == BaseStatus.loaded) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task,
              size: 50,
              color: Colors.grey.withOpacity(0.5),
            ),
            SizedBox(height: 16),
            Text(
              'Nenhuma tarefa encontrada',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Clique no + para adicionar',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.withOpacity(0.8),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        final task = taskList[index];
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;
        final taskColor = _getTaskColor(task.status);
        final isCompleted = _isCompleted(task.status);
        final statusText = _getStatusText(task.status);

        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(isDarkMode ? 0.1 : 0.15),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Checkbox com cor baseada no status
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
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
                        color: Colors.white,
                      )
                    : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.titulo,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: isCompleted
                            ? Colors.grey
                            : Theme.of(context).textTheme.bodyLarge?.color,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          "Status: $statusText",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDarkMode ? Colors.white54 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 28,
          color: isActive
              ? (isDarkMode ? Theme.of(context).primaryColor : const Color(0xFFA069FF))
              : (isDarkMode ? Colors.white54 : Colors.grey[600]),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: isActive
                ? (isDarkMode ? Theme.of(context).primaryColor : const Color(0xFFA069FF))
                : (isDarkMode ? Colors.white54 : Colors.grey[600]),
          ),
        ),
      ],
    );
  }
}