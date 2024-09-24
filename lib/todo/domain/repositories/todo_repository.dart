import 'package:bloc_tutorial/todo/data/data_sources/todo_data_sources.dart';
import 'package:bloc_tutorial/todo/data/entities/todo.dart';

class TodoRepository {
  final TodoDataSource _todoDS;

  TodoRepository({required TodoDataSource todoDS}) : _todoDS = todoDS;

  Stream<List<Todo>> getTodos() => _todoDS.getTodos();

  Future<void> saveTodo(Todo todo) => _todoDS.saveTodo(todo);

  Future<void> deleteTodo(String id) => _todoDS.deleteTodo(id);

  Future<int> clearCompleted() => _todoDS.clearCompleted();

  Future<int> completeAll(bool isCompleted) => _todoDS.completeAll(isCompleted);
}
