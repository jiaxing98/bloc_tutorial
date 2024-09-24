import 'dart:convert';

import 'package:bloc_tutorial/todo/data/entities/todo.dart';
import 'package:bloc_tutorial/todo/data/exceptions/todo_exception.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class TodoDataSource {
  Stream<List<Todo>> getTodos();
  Future<void> saveTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<int> clearCompleted();
  Future<int> completeAll(bool isCompleted);
  Future<void> close();
}

class TodoDataSourceImpl extends TodoDataSource {
  final SharedPreferences _storage;

  TodoDataSourceImpl({required SharedPreferences storage}) : _storage = storage {
    _init();
  }

  late final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  @visibleForTesting
  static const kTodosCollectionKey = '__todos_collection_key__';

  @override
  Future<int> clearCompleted() async {
    final todos = [..._todoStreamController.value];
    final completedTodosAmount = todos.where((e) => e.isCompleted).length;
    todos.removeWhere((t) => t.isCompleted);
    _todoStreamController.add(todos);
    await _setValue(kTodosCollectionKey, json.encode(todos));
    return completedTodosAmount;
  }

  @override
  Future<void> close() {
    return _todoStreamController.close();
  }

  @override
  Future<int> completeAll(bool isCompleted) async {
    final todos = [..._todoStreamController.value];
    final changedTodosAmount = todos.where((t) => t.isCompleted != isCompleted).length;
    final newTodos = [
      for (final todo in todos) todo.copyWith(isCompleted: isCompleted),
    ];
    _todoStreamController.add(newTodos);
    await _setValue(kTodosCollectionKey, json.encode(newTodos));
    return changedTodosAmount;
  }

  @override
  Future<void> deleteTodo(String id) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((e) => e.id == id);
    if (todoIndex == -1) throw TodoNotFoundException();

    todos.removeAt(todoIndex);
    _todoStreamController.add(todos);
    return _setValue(kTodosCollectionKey, json.encode(todos));
  }

  @override
  Stream<List<Todo>> getTodos() {
    return _todoStreamController.asBroadcastStream();
  }

  @override
  Future<void> saveTodo(Todo todo) {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((e) => e.id == todo.id);
    todoIndex >= 0 ? todos[todoIndex] = todo : todos.add(todo);

    _todoStreamController.add(todos);
    return _setValue(kTodosCollectionKey, json.encode(todos));
  }

  void _init() {
    final todosJson = _getValue(kTodosCollectionKey);
    if (todosJson == null) {
      _todoStreamController.add(const []);
      return;
    }

    final todos = List<Map<dynamic, dynamic>>.from(
      json.decode(todosJson) as List,
    ).map((jsonMap) => Todo.fromJson(Map<String, dynamic>.from(jsonMap))).toList();
    _todoStreamController.add(todos);
  }

  String? _getValue(String key) => _storage.getString(key);

  Future<void> _setValue(String key, String value) => _storage.setString(key, value);
}
