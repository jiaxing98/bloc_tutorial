import 'dart:developer';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/todo/app.dart';
import 'package:bloc_tutorial/todo/data/data_sources/todo_data_sources.dart';
import 'package:bloc_tutorial/todo/domain/repositories/todo_repository.dart';
import 'package:bloc_tutorial/todo/observer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt todoSL = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log(error.toString(), stackTrace: stack);
    return true;
  };

  Bloc.observer = const TodoBlocObserver();

  await injectDependencies();

  runApp(const TodoApp());
}

Future<void> injectDependencies() async {
  todoSL.registerSingleton<TodoDataSource>(
    TodoDataSourceImpl(storage: await SharedPreferences.getInstance()),
  );

  todoSL.registerSingleton<TodoRepository>(
    TodoRepository(todoDS: todoSL.get<TodoDataSource>()),
  );
}
