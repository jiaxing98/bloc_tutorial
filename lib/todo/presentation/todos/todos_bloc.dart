import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/todo/data/entities/todo.dart';
import 'package:bloc_tutorial/todo/domain/repositories/todo_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoRepository _todoRepository;

  TodosBloc({required TodoRepository todoRepository})
      : _todoRepository = todoRepository,
        super(const TodosState()) {
    on<TodosSubscriptionRequested>(_onSubscriptionRequested);
    on<TodosCompletionToggled>(_onCompletionToggled);
    on<TodosDeleted>(_onDeleted);
    on<TodosUndoDeletionRequested>(_undoDeletionRequested);
    on<TodoFilterChanged>(_onFilterChanged);
    on<TodosToggleAllRequested>(_onToggleAllRequested);
    on<TodosClearCompletedRequested>(_onClearCompletedRequested);
  }

  Future<void> _onSubscriptionRequested(
      TodosSubscriptionRequested event, Emitter<TodosState> emit) async {
    emit(state.copyWith(status: TodoStatus.loading));

    await emit.forEach<List<Todo>>(
      _todoRepository.getTodos(),
      onData: (todos) => state.copyWith(
        status: TodoStatus.success,
        todos: todos,
      ),
      onError: (_, __) => state.copyWith(status: TodoStatus.failure),
    );
  }

  Future<void> _onCompletionToggled(TodosCompletionToggled event, Emitter<TodosState> emit) async {
    final newTodo = event.todo.copyWith(isCompleted: event.isCompleted);
    await _todoRepository.saveTodo(newTodo);
  }

  Future<void> _onDeleted(TodosDeleted event, Emitter<TodosState> emit) async {
    emit(state.copyWith(lastDeletedTodo: event.todo));
    await _todoRepository.deleteTodo(event.todo.id);
  }

  Future<void> _undoDeletionRequested(
      TodosUndoDeletionRequested event, Emitter<TodosState> emit) async {
    assert(state.lastDeletedTodo != null, "Last deleted todo cannot be null");

    final todo = state.lastDeletedTodo!;
    emit(state.copyWith(lastDeletedTodo: null));
    await _todoRepository.saveTodo(todo);
  }

  Future<void> _onFilterChanged(TodoFilterChanged event, Emitter<TodosState> emit) async {
    emit(state.copyWith(filter: event.filter));
  }

  Future<void> _onToggleAllRequested(
      TodosToggleAllRequested event, Emitter<TodosState> emit) async {
    final areAllCompleted = state.todos.every((e) => e.isCompleted);
    await _todoRepository.completeAll(!areAllCompleted);
  }

  Future<void> _onClearCompletedRequested(
      TodosClearCompletedRequested event, Emitter<TodosState> emit) async {
    await _todoRepository.clearCompleted();
  }
}
