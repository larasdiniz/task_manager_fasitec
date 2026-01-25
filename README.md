# 📝 Desafio Técnico – Flutter

Bem-vindo(a)! 👋  
Este desafio tem como objetivo avaliar seus conhecimentos práticos em **Flutter**, organização de código, gerenciamento de estado e construção de interfaces responsivas.

Você receberá um projeto base já estruturado, contendo uma **Fake API** e dados mockados. A partir disso, esperamos que você implemente as funcionalidades descritas abaixo.

---

## 🎯 Objetivo do Desafio

Desenvolver um aplicativo de **Gerenciamento de Tasks** utilizando Flutter, consumindo uma Fake API já fornecida no projeto base.

O foco principal será avaliar:

- Organização do código
- Uso correto de widgets
- Gerenciamento de estado
- Responsividade
- Clareza e legibilidade

---

## 📱 Funcionalidades Obrigatórias

### 1️⃣ Tela de Listagem de Tasks

- Exibir uma lista de tarefas
- Cada tarefa deve mostrar, no mínimo:
  - **Título**
  - **Status**
- A listagem deve consumir os dados vindos da Fake API

---

### 2️⃣ Tela de Criação de Task

- Formulário para criar uma nova tarefa
- Campos obrigatórios:
  - Título
  - Descrição
  - Status (Em Aberto, Em Progresso, Finalizado)
- Ao salvar, a nova task deve aparecer na listagem

---

### 3️⃣ Tela de Edição de Task

- Permitir editar uma task existente
- Campos editáveis:
  - Título
  - Descrição
  - Status
- O **ID da task não deve ser alterado**
- Os dados devem ser carregados previamente no formulário

---

### 4️⃣ Funcionalidade de Deletar Task

- Permitir remover uma task pelo ID
- A task deve ser removida da listagem após a exclusão

---

### 5️⃣ Responsividade

- O aplicativo deve se adaptar bem a diferentes tamanhos de tela
- Deve funcionar corretamente em:
  - Smartphones
  - Tablets (ou telas maiores)
- Fique à vontade para usar:
  - `LayoutBuilder`
  - `MediaQuery`
  - `Flexible`
  - `Expanded`

---

## 🧠 Regras Importantes

- A **Fake API retorna dados no formato `String` (JSON)**
  - O parse para `TaskModel` deve ser feito no **Repository**
- O candidato **pode adicionar novas funcionalidades à Fake API**, como por exemplo:
  - Buscar tasks por status (`getByStatus`)
  - Deletar múltiplas tasks ao mesmo tempo
  - Novos métodos de consulta ou manipulação
- As **funcionalidades já existentes devem, preferencialmente, manter o comportamento original**
  - Ajustes são permitidos, desde que não quebrem o fluxo principal da aplicação
- Evite lógica de negócio diretamente nos widgets

---

## 🎨 Design e Funcionalidades Extras

Você está **totalmente livre** para:

- Personalizar o design da aplicação
- Criar componentes reutilizáveis
- Adicionar animações
- Implementar novas funcionalidades, como:
  - Filtro de tarefas por status
  - Tema claro/escuro
  - Persistência local
  - Feedback visual (loading, erro, empty state)

✨ **Tudo isso será considerado um diferencial**, mas não é obrigatório.

---

## 🗂️ Estrutura do Projeto

O projeto base já possui uma estrutura inicial organizada.  
Sinta-se à vontade para ajustar ou expandir a arquitetura, desde que mantenha o código limpo e compreensível.

---

## 🚀 Entrega

- Caso implemente algo além do solicitado, sinta-se à vontade para documentar

---

## ✅ Critérios de Avaliação

- Funcionamento correto das funcionalidades solicitadas
- Organização e clareza do código
- Uso adequado do Flutter e do gerenciamento de estado
- Responsividade
- Boas práticas de desenvolvimento

---

Boa sorte 🚀  
Estamos ansiosos para ver sua solução e suas ideias!
