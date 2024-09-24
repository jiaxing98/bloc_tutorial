import 'package:bloc_tutorial/todo/l10n/l10n.dart';
import 'package:bloc_tutorial/todo/presentation/home/homepage.dart';
import 'package:bloc_tutorial/todo/theme.dart';
import 'package:flutter/material.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterTodoTheme.light,
      darkTheme: FlutterTodoTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
    );
  }
}
