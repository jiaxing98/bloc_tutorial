part of 'todos_bloc.dart';

@immutable
sealed class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

final class TodosSubscriptionRequested extends TodosEvent {
  const TodosSubscriptionRequested();
}

final class TodosCompletionToggled extends TodosEvent {
  final Todo todo;
  final bool isCompleted;

  const TodosCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [todo, isCompleted];
}

final class TodosDeleted extends TodosEvent {
  final Todo todo;

  const TodosDeleted(this.todo);

  @override
  List<Object> get props => [todo];
}

final class TodosUndoDeletionRequested extends TodosEvent {
  const TodosUndoDeletionRequested();
}

class TodoFilterChanged extends TodosEvent {
  final TodosViewFilter filter;

  const TodoFilterChanged(this.filter);

  @override
  List<Object> get props => [filter];
}

class TodosToggleAllRequested extends TodosEvent {
  const TodosToggleAllRequested();
}

class TodosClearCompletedRequested extends TodosEvent {
  const TodosClearCompletedRequested();
}
