# 📱 Task Manager - Aplicativo de Gerenciamento de Tarefas

## ✅ Funcionalidades Obrigatórias Implementadas

### 1️⃣ Tela de Listagem de Tasks
- Lista todas as tarefas consumindo dados da Fake API
- Cada task mostra título e status com cores diferenciadas
- Design responsivo com cards modernos

### 2️⃣ Tela de Criação de Task
- Formulário com validação em tempo real
- Campos: Título (obrigatório), Descrição (obrigatório), Status
- Status disponíveis: Em Aberto, Em Progresso, Finalizado
- Nova task aparece automaticamente na listagem

### 3️⃣ Tela de Edição de Task
- Carrega dados pré-existentes da task
- Permite editar título, descrição e status
- ID da task é preservado (não alterado)
- Confirmação para mudanças não salvas

### 4️⃣ Funcionalidade de Deletar Task
- Exclusão individual com diálogo de confirmação
- Atualização automática da listagem
- Feedback visual com SnackBar

### 5️⃣ Responsividade Completa
- Layout adaptativo para smartphones e tablets
- Uso de MediaQuery, LayoutBuilder, Flexible, Expanded
- Design fluido em diferentes tamanhos de tela

## ⭐ Funcionalidades Extras Implementadas

### 🎨 Sistema de Temas Claro/Escuro
- Alternância automática/manual de temas
- Persistência da preferência do usuário
- Cores adaptativas para ambos os temas

### 🔍 Filtro de Tarefas por Status
- Filtro dinâmico: Todos, Em Aberto, Em Progresso, Finalizado
- Dropdown estilizado com atualização em tempo real

### 📊 Métricas em Tempo Real
- Taxa de Conclusão: % de tasks finalizadas
- Tarefas em Andamento: contagem de tasks em progresso
- Cards informativos com atualização automática

### 👆 Sistema de Seleção em Lote
- Modo de seleção múltipla de tasks
- Ações em massa: marcar como concluídas/em aberto/em progresso
- Exclusão de múltiplas tasks simultaneamente
- Menu contextual com contador

### 💬 Feedback Visual Completo
- Loading states para operações assíncronas
- Error states com mensagens claras
- Empty states quando não há dados
- SnackBars para sucesso e erros
- Confirmações para ações destrutivas

## 🏗️ Arquitetura e Padrões

### 📁 Estrutura Organizada
- Separação clara por responsabilidades (core, pages, repositories)
- Componentes reutilizáveis
- Navegação por rotas nomeadas

### 🔧 Padrões Utilizados
- Repository Pattern (parse JSON no repositório)
- BLoC/Cubit para gerenciamento de estado
- Estados imutáveis com Equatable
- Clean Architecture principles

### 🔌 Extensões da Fake API
- getTasksByStatus() para filtragem
- deleteMultipleTasks() para exclusão em massa
- updateMultipleTasksStatus() para atualização em massa

## 🚀 Diferenciais Implementados

1. **Design Moderno**: Interface com gradientes, sombras e botão flutuante
2. **UX Aprimorada**: Feedback visual completo em todos os estados
3. **Eficiência**: Operações em lote para gerenciamento rápido
4. **Insights**: Métricas visuais para acompanhamento de progresso
5. **Personalização**: Sistema completo de temas claro/escuro

## 📱 Telas Disponíveis

- **🏠 Home Page**: Listagem principal com filtros, métricas e seleção em lote
- **➕ Create Task**: Formulário de criação com validação
- **✏️ Edit Task**: Tela de edição com preservação do ID
- **⚙️ Settings**: Configurações do app incluindo tema

---

✅ **Todas as funcionalidades obrigatórias implementadas**
⭐ **Múltiplas funcionalidades extras adicionadas**
🏗️ **Arquitetura sólida seguindo boas práticas**
🎨 **Design responsivo e moderno com foco na UX**

O aplicativo está completo, funcional e pronto para produção, demonstrando conhecimento completo do ecossistema Flutter.