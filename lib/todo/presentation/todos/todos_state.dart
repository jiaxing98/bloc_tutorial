part of 'todos_bloc.dart';

enum TodoStatus { initial, loading, success, failure }

enum TodosViewFilter { all, activeOnly, completedOnly }

final class TodosState extends Equatable {
  final TodoStatus status;
  final List<Todo> todos;
  final TodosViewFilter filter;
  final Todo? lastDeletedTodo;

  const TodosState({
    this.status = TodoStatus.initial,
    this.todos = const [],
    this.filter = TodosViewFilter.all,
    this.lastDeletedTodo,
  });

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  TodosState copyWith({
    TodoStatus? status,
    List<Todo>? todos,
    TodosViewFilter? filter,
    Todo? lastDeletedTodo,
  }) {
    return TodosState(
      status: status ?? this.status,
      todos: todos ?? this.todos,
      filter: filter ?? this.filter,
      lastDeletedTodo: lastDeletedTodo ?? this.lastDeletedTodo,
    );
  }

  @override
  List<Object?> get props => [status, todos, filter, lastDeletedTodo];
}

extension TodosViewFilterX on TodosViewFilter {
  bool apply(Todo todo) {
    switch (this) {
      case TodosViewFilter.all:
        return true;
      case TodosViewFilter.activeOnly:
        return !todo.isCompleted;
      case TodosViewFilter.completedOnly:
        return todo.isCompleted;
    }
  }

  Iterable<Todo> applyAll(Iterable<Todo> todos) {
    return todos.where(apply);
  }
}
