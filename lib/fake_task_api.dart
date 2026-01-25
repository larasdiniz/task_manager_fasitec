import 'dart:async';
import 'dart:convert';

import 'package:task_manager/app/core/enums/task_status_enum.dart';
import 'package:task_manager/app/core/ui/extensions/task_status_extension.dart';

class FakeTasksApi {
  final List<Map<String, dynamic>> _tasksDatabase = [
    {'id': 1, 'titulo': 'Estudar Flutter', 'descricao': 'Revisar widgets básicos', 'status': 'Em Aberto'},
    {'id': 2, 'titulo': 'Criar projeto', 'descricao': 'Iniciar o desafio técnico', 'status': 'Em Progresso'},
    {'id': 3, 'titulo': 'Configurar ambiente', 'descricao': 'Instalar Flutter e dependências', 'status': 'Finalizado'},
    {'id': 4, 'titulo': 'Organizar pastas', 'descricao': 'Definir arquitetura do projeto', 'status': 'Finalizado'},
    {'id': 5, 'titulo': 'Criar Fake API', 'descricao': 'Simular requisições de backend', 'status': 'Em Progresso'},
    {'id': 6, 'titulo': 'Modelar Task', 'descricao': 'Criar model e enum de status', 'status': 'Finalizado'},
    {'id': 7, 'titulo': 'Implementar Repository', 'descricao': 'Converter JSON para Model', 'status': 'Em Aberto'},
    {'id': 8, 'titulo': 'Criar BLoC', 'descricao': 'Definir events e states', 'status': 'Em Progresso'},
    {'id': 9, 'titulo': 'Listar tarefas', 'descricao': 'Exibir lista na Home', 'status': 'Finalizado'},
    {'id': 10, 'titulo': 'Criar formulário', 'descricao': 'Tela de criação de tarefas', 'status': 'Em Aberto'},
    {'id': 11, 'titulo': 'Validações', 'descricao': 'Validar campos obrigatórios', 'status': 'Em Progresso'},
    {'id': 12, 'titulo': 'Responsividade', 'descricao': 'Adaptar layout para tablets', 'status': 'Em Aberto'},
    {'id': 13, 'titulo': 'Criar componentes', 'descricao': 'TaskCard reutilizável', 'status': 'Finalizado'},
    {'id': 14, 'titulo': 'Tema do app', 'descricao': 'Configurar tema claro e escuro', 'status': 'Em Progresso'},
    {'id': 15, 'titulo': 'Provider global', 'descricao': 'Injetar dependências', 'status': 'Finalizado'},
    {'id': 16, 'titulo': 'Filtro de tarefas', 'descricao': 'Filtrar por status', 'status': 'Em Aberto'},
    {'id': 17, 'titulo': 'Tratamento de erro', 'descricao': 'Exibir mensagens de erro', 'status': 'Em Progresso'},
    {'id': 18, 'titulo': 'Persistência local', 'descricao': 'Salvar dados localmente', 'status': 'Em Aberto'},
    {'id': 19, 'titulo': 'Testes unitários', 'descricao': 'Testar BLoC e Repository', 'status': 'Em Progresso'},
    {'id': 20, 'titulo': 'Documentação', 'descricao': 'Escrever README do projeto', 'status': 'Finalizado'},
  ];

  /// GET - Buscar todas as tasks
  Future<String> getAllTasks() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return jsonEncode(_tasksDatabase);
  }

  /// POST - Adicionar nova task
  Future<String> addTask({
    required String titulo,
    required String descricao,
    TaskStatus status = TaskStatus.emAberto,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final lastId = _tasksDatabase.isEmpty
        ? 0
        : _tasksDatabase.map((task) => task['id'] as int).reduce((a, b) => a > b ? a : b);

    final newTask = {'id': lastId + 1, 'titulo': titulo, 'descricao': descricao, 'status': status.label};

    _tasksDatabase.add(newTask);

    return jsonEncode(newTask);
  }

  /// DELETE - Remover task pelo id
  Future<String> deleteTask(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tasksDatabase.indexWhere((task) => task['id'] == id);

    if (index == -1) {
      return jsonEncode({'error': 'Task não encontrada'});
    }

    _tasksDatabase.removeAt(index);

    return jsonEncode({'success': true});
  }

  /// PUT / PATCH - Editar task pelo id
  Future<String> updateTask({required int id, String? titulo, String? descricao, TaskStatus? status}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _tasksDatabase.indexWhere((task) => task['id'] == id);

    if (index == -1) {
      return jsonEncode({'error': 'Task não encontrada'});
    }

    final task = _tasksDatabase[index];

    _tasksDatabase[index] = {
      'id': task['id'],
      'titulo': titulo ?? task['titulo'],
      'descricao': descricao ?? task['descricao'],
      'status': status?.label ?? task['status'],
    };

    return jsonEncode(_tasksDatabase[index]);
  }
}
