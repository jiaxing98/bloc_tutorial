import 'package:bloc_tutorial/github_search/domain/repositories/github_repository.dart';
import 'package:bloc_tutorial/github_search/main.dart';
import 'package:bloc_tutorial/github_search/presentation/search/bloc/search_bloc.dart';
import 'package:bloc_tutorial/github_search/presentation/search/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GithubApp extends StatelessWidget {
  const GithubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github Search',
      home: Scaffold(
        appBar: AppBar(title: const Text('Github Search')),
        body: BlocProvider(
          create: (_) => SearchBloc(githubRepository: githubSL.get<GithubRepository>()),
          child: const SearchPage(),
        ),
      ),
    );
  }
}
